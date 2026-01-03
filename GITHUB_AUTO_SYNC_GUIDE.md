# 🔄 GitHub Auto-Sync Setup Guide - Klipper Configs

## 🎯 Ziel

**Push auf GitHub → Automatischer Pull auf Raspberry Pi 5**

Jede Änderung die du auf GitHub pushst, wird automatisch auf deinen 3D-Drucker synchronisiert!

---

## 📊 Verfügbare Methoden

| Methode | Geschwindigkeit | Komplexität | Zuverlässigkeit |
|---------|-----------------|-------------|-----------------|
| **Moonraker Update Manager** | ⭐⭐⭐ Sehr gut (1-2 Min) | ⭐⭐ Mittel | ⭐⭐⭐ Hoch |
| **GitHub Webhook** | ⭐⭐⭐ Instant (<10 Sek) | ⭐⭐⭐ Komplex | ⭐⭐ Mittel |
| **Cron Job** | ⭐ Langsam (2-5 Min) | ⭐ Einfach | ⭐⭐⭐ Hoch |

**Empfehlung:** Moonraker Update Manager + GitHub Webhook (Kombination)

---

## 🔧 METHODE 1: Moonraker Update Manager (EMPFOHLEN)

### Vorteile:
- ✅ Integriert in Mainsail UI
- ✅ Ein-Klick Update in der GUI
- ✅ Automatisches Polling alle 60 Sekunden
- ✅ Kein externer Service nötig
- ✅ Zeigt Update-Status in Mainsail

### 1.1 Moonraker Config

**Auf Raspberry Pi 5:**

```bash
ssh sv06
nano ~/printer_data/config/moonraker.conf
```

**Folgende Section HINZUFÜGEN (oder vorhandene anpassen):**

```ini
[update_manager klipper_config]
type: git_repo
path: /home/pi/printer_data/config
origin: git@github.com:DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git
primary_branch: master
is_system_service: False
managed_services: klipper
refresh_interval: 60

# Wenn du HTTPS statt SSH nutzt:
# origin: https://github.com/DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git

# Optional: Enable notifications
enable_auto_refresh: True
```

**Erklärung der Parameter:**

| Parameter | Wert | Bedeutung |
|-----------|------|-----------|
| `type` | git_repo | Repository-basiertes Update |
| `path` | /home/pi/printer_data/config | Lokaler Config-Ordner |
| `origin` | GitHub URL | Dein Repository |
| `primary_branch` | master | Branch zum Tracken |
| `is_system_service` | False | Kein System-Service (nur Configs) |
| `managed_services` | klipper | Services die neu gestartet werden |
| `refresh_interval` | 60 | Prüft alle 60 Sekunden |
| `enable_auto_refresh` | True | Auto-Refresh aktiv |

**Speichern:** `Ctrl+O`, Enter, `Ctrl+X`

---

### 1.2 Moonraker neu starten

```bash
sudo systemctl restart moonraker

# Status prüfen
sudo systemctl status moonraker

# Logs checken (sollte Update Manager laden)
journalctl -u moonraker | grep "update_manager"
```

**Erwartete Log-Ausgabe:**

```
Jan 03 10:00:00 3dpi moonraker[1234]: update_manager: Registered client: klipper_config
Jan 03 10:00:00 3dpi moonraker[1234]: update_manager: Git Repo 'klipper_config': Current version: abc123...
```

✅ **Update Manager aktiv!**

---

### 1.3 Mainsail UI - Update Manager

**Im Browser:**

```
http://192.168.10.5
# Oder: http://3dpi.local
```

**In Mainsail:**

1. **Settings** (⚙️) → **Update Manager**
2. **Du siehst jetzt:**
   ```
   Software Updates:
   - Klipper
   - Moonraker
   - Mainsail
   - klipper_config ← Neu!
   ```

3. **Bei neuen Commits auf GitHub:**
   - `klipper_config` zeigt: **"Update available"**
   - Klicke **"Update"**
   - Moonraker pulled automatisch und startet Klipper neu!

---

### 1.4 Test: GitHub → Moonraker Update

**Auf deinem Mac:**

```bash
cd "/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT"

# Test-Änderung
echo "# Auto-Sync Test $(date)" >> README.md

git add README.md
git commit -m "Test: Moonraker Auto-Sync"
git push origin master
```

**In Mainsail UI (nach ~60 Sekunden):**

- **Update Manager** → `klipper_config` sollte **"Update available"** zeigen
- Klicke **"Update"**
- Moonraker pulled die Änderungen
- Klipper wird neu gestartet (falls `managed_services: klipper`)

**Auf RPi 5 prüfen:**

```bash
ssh sv06
cd ~/printer_data/config
git log -1
# Sollte deinen neuen Commit zeigen!

cat README.md
# Sollte die neue Zeile zeigen!
```

✅ **Moonraker Update Manager funktioniert!**

---

## 🚀 METHODE 2: GitHub Webhook (FÜR INSTANT UPDATES)

### Vorteile:
- ✅ **Instant Updates** (~5-10 Sekunden nach Push!)
- ✅ Keine Polling-Verzögerung
- ✅ Serverless (nutzt GitHub-Infrastruktur)

### Nachteile:
- ⚠️ Komplexeres Setup
- ⚠️ Benötigt öffentliche IP oder Reverse Proxy
- ⚠️ Sicherheitsrisiko wenn nicht richtig konfiguriert

---

### 2.1 Setup - Custom Webhook Script

**Auf Raspberry Pi 5:**

```bash
ssh sv06

# Webhook-Script erstellen
nano ~/printer_data/scripts/github_webhook.sh
```

**Script-Inhalt:**

```bash
#!/bin/bash

# GitHub Webhook Handler für Klipper Config Auto-Sync
# Wird von GitHub beim Push aufgerufen

LOG_FILE="/home/pi/printer_data/logs/github_webhook.log"
CONFIG_DIR="/home/pi/printer_data/config"

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "Webhook triggered!"

# Zum Config-Ordner wechseln
cd "$CONFIG_DIR" || exit 1

# Git Pull
log "Pulling latest changes from GitHub..."
git pull origin master >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    log "Git pull successful!"

    # Klipper neu starten (nur wenn .cfg Dateien geändert)
    if git diff HEAD@{1} --name-only | grep -q "\.cfg$"; then
        log "Config files changed, restarting Klipper..."
        sudo systemctl restart klipper
        log "Klipper restarted!"
    else
        log "No config files changed, skipping Klipper restart."
    fi
else
    log "ERROR: Git pull failed!"
    exit 1
fi

log "Webhook completed!"
exit 0
```

**Speichern:** `Ctrl+O`, Enter, `Ctrl+X`

**Executable machen:**

```bash
chmod +x ~/printer_data/scripts/github_webhook.sh

# Script-Ordner erstellen falls nicht vorhanden
mkdir -p ~/printer_data/scripts
mkdir -p ~/printer_data/logs
```

---

### 2.2 Webhook Listener mit Python

**Python Webhook-Server erstellen:**

```bash
nano ~/printer_data/scripts/webhook_server.py
```

**Python Script:**

```python
#!/usr/bin/env python3

"""
GitHub Webhook Listener für Klipper Config Auto-Sync
Lauscht auf Port 9000 für GitHub Webhook POST Requests
"""

import http.server
import socketserver
import subprocess
import hashlib
import hmac
import json
import os

PORT = 9000
SECRET = "dein-geheimer-webhook-secret"  # Später in GitHub eintragen!
WEBHOOK_SCRIPT = "/home/pi/printer_data/scripts/github_webhook.sh"

class WebhookHandler(http.server.BaseHTTPRequestHandler):

    def do_POST(self):
        # Content Length lesen
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)

        # GitHub Signature verifizieren
        signature = self.headers.get('X-Hub-Signature-256')
        if signature:
            # HMAC-SHA256 berechnen
            expected_signature = 'sha256=' + hmac.new(
                SECRET.encode(),
                post_data,
                hashlib.sha256
            ).hexdigest()

            if not hmac.compare_digest(signature, expected_signature):
                self.send_response(401)
                self.end_headers()
                self.wfile.write(b"Invalid signature")
                print("ERROR: Invalid signature!")
                return

        # JSON parsen
        try:
            payload = json.loads(post_data)
            repo_name = payload.get('repository', {}).get('full_name', 'Unknown')
            commit_msg = payload.get('head_commit', {}).get('message', 'No message')

            print(f"Webhook received from: {repo_name}")
            print(f"Commit: {commit_msg}")

            # Webhook-Script ausführen
            result = subprocess.run(
                [WEBHOOK_SCRIPT],
                capture_output=True,
                text=True
            )

            if result.returncode == 0:
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"Webhook processed successfully!")
                print("SUCCESS: Config synced!")
            else:
                self.send_response(500)
                self.end_headers()
                self.wfile.write(b"Script execution failed")
                print(f"ERROR: {result.stderr}")

        except Exception as e:
            self.send_response(500)
            self.end_headers()
            self.wfile.write(f"Error: {str(e)}".encode())
            print(f"ERROR: {str(e)}")

    def log_message(self, format, *args):
        # Custom logging
        print(f"[{self.log_date_time_string()}] {format % args}")

if __name__ == "__main__":
    with socketserver.TCPServer(("", PORT), WebhookHandler) as httpd:
        print(f"Webhook server listening on port {PORT}...")
        httpd.serve_forever()
```

**Speichern:** `Ctrl+O`, Enter, `Ctrl+X`

**Executable machen:**

```bash
chmod +x ~/printer_data/scripts/webhook_server.py
```

---

### 2.3 Webhook Server als Systemd Service

**Systemd Service erstellen:**

```bash
sudo nano /etc/systemd/system/github-webhook.service
```

**Service-Datei:**

```ini
[Unit]
Description=GitHub Webhook Listener for Klipper Configs
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/printer_data/scripts
ExecStart=/usr/bin/python3 /home/pi/printer_data/scripts/webhook_server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Speichern:** `Ctrl+O`, Enter, `Ctrl+X`

**Service aktivieren:**

```bash
# Service laden
sudo systemctl daemon-reload

# Service starten
sudo systemctl start github-webhook

# Service beim Boot starten
sudo systemctl enable github-webhook

# Status prüfen
sudo systemctl status github-webhook
```

**Erwartete Ausgabe:**

```
● github-webhook.service - GitHub Webhook Listener for Klipper Configs
   Loaded: loaded (/etc/systemd/system/github-webhook.service; enabled)
   Active: active (running) since Fri 2026-01-03 10:00:00 CET; 5s ago
 Main PID: 1234 (python3)
   CGroup: /system.slice/github-webhook.service
           └─1234 /usr/bin/python3 /home/pi/printer_data/scripts/webhook_server.py

Jan 03 10:00:00 3dpi systemd[1]: Started GitHub Webhook Listener for Klipper Configs.
Jan 03 10:00:00 3dpi python3[1234]: Webhook server listening on port 9000...
```

✅ **Webhook Server läuft!**

---

### 2.4 Port Forwarding (Ubiquiti)

**Falls du von extern erreichbar sein willst:**

**Ubiquiti UniFi Controller:**

1. **Settings** → **Routing & Firewall** → **Port Forwarding**
2. **Create New Port Forward Rule:**
   ```
   Name: GitHub Webhook
   Enabled: ✅
   From: Any
   Port: 9000
   Forward IP: 192.168.10.5
   Forward Port: 9000
   Protocol: TCP
   ```
3. **Apply**

**Firewall-Regel (nur GitHub IPs erlauben):**

```bash
# GitHub Webhook IP-Ranges (Stand 2026)
# https://api.github.com/meta

sudo nano /etc/ufw/applications.d/github-webhooks
```

**Inhalt:**

```
[GitHubWebhooks]
title=GitHub Webhooks
description=GitHub Webhook IP Ranges
ports=9000/tcp
```

**UFW aktivieren:**

```bash
sudo ufw allow from 192.30.252.0/22 to any port 9000
sudo ufw allow from 185.199.108.0/22 to any port 9000
sudo ufw allow from 140.82.112.0/20 to any port 9000
sudo ufw enable
```

---

### 2.5 GitHub Webhook konfigurieren

**Auf github.com:**

1. **Gehe zu deinem Repo:**
   ```
   https://github.com/DEIN-USERNAME/Sovol-SV06plus-firmware-BTT
   ```

2. **Settings** → **Webhooks** → **Add webhook**

3. **Payload URL:**
   ```
   http://DEINE-ÖFFENTLICHE-IP:9000
   # Oder mit DynDNS:
   http://dein-hostname.dyndns.org:9000
   ```

4. **Content type:** `application/json`

5. **Secret:** `dein-geheimer-webhook-secret` (wie in webhook_server.py)

6. **Which events?**
   - ✅ Just the `push` event

7. **Active:** ✅

8. **Add webhook**

---

### 2.6 Test: GitHub Webhook

**Auf deinem Mac:**

```bash
cd "/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT"

# Test-Änderung
echo "# Webhook Test $(date)" >> README.md

git add README.md
git commit -m "Test: GitHub Webhook Instant Sync"
git push origin master
```

**Auf GitHub:**

- **Settings** → **Webhooks** → Dein Webhook
- **Recent Deliveries** sollte neuen Request zeigen (grüner Haken ✅)

**Auf RPi 5:**

```bash
# Webhook Logs checken
sudo journalctl -u github-webhook -f

# Git Log prüfen
cd ~/printer_data/config
git log -1
# Sollte neuen Commit nach ~5-10 Sekunden zeigen!
```

✅ **GitHub Webhook funktioniert! Instant Updates!**

---

## 🕐 METHODE 3: Cron Job (FALLBACK)

### Vorteile:
- ✅ Einfachstes Setup
- ✅ Keine externen Dependencies
- ✅ Funktioniert immer

### Nachteile:
- ❌ Langsam (2-5 Minuten Verzögerung)
- ❌ Unnecessary Git Pulls (auch wenn keine Änderungen)

---

### 3.1 Cron Job Setup

```bash
ssh sv06

# Crontab bearbeiten
crontab -e
```

**Folgende Zeile hinzufügen:**

```bash
# Klipper Config Auto-Sync (alle 2 Minuten)
*/2 * * * * cd /home/pi/printer_data/config && git pull origin master >> /home/pi/printer_data/logs/git-sync.log 2>&1
```

**Oder mit Klipper Auto-Restart bei Änderungen:**

```bash
*/2 * * * * /home/pi/printer_data/scripts/cron_git_sync.sh >> /home/pi/printer_data/logs/git-sync.log 2>&1
```

**Script erstellen:**

```bash
nano ~/printer_data/scripts/cron_git_sync.sh
```

**Inhalt:**

```bash
#!/bin/bash

CONFIG_DIR="/home/pi/printer_data/config"

cd "$CONFIG_DIR" || exit 1

# Git fetch + check for changes
git fetch origin master

if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/master)" ]; then
    echo "[$(date)] Changes detected, pulling..."
    git pull origin master

    # Restart Klipper if .cfg files changed
    if git diff HEAD@{1} --name-only | grep -q "\.cfg$"; then
        echo "[$(date)] Config changed, restarting Klipper..."
        sudo systemctl restart klipper
    fi
else
    echo "[$(date)] No changes."
fi
```

**Executable machen:**

```bash
chmod +x ~/printer_data/scripts/cron_git_sync.sh
```

**Speichern:** `Ctrl+O`, Enter, `Ctrl+X`

**Testen:**

```bash
# Manuell ausführen
~/printer_data/scripts/cron_git_sync.sh

# Logs checken
tail -f ~/printer_data/logs/git-sync.log
```

✅ **Cron Job aktiv! Updates alle 2 Minuten!**

---

## 📊 METHODEN-VERGLEICH

| Feature | Moonraker | GitHub Webhook | Cron Job |
|---------|-----------|----------------|----------|
| **Setup-Dauer** | 5 Min | 30 Min | 2 Min |
| **Sync-Zeit** | 1-2 Min | 5-10 Sek | 2-5 Min |
| **GUI Integration** | ✅ Mainsail UI | ❌ | ❌ |
| **Auto-Restart Klipper** | ✅ | ✅ | ✅ |
| **Öffentliche IP nötig** | ❌ | ✅ | ❌ |
| **Sicherheit** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| **Zuverlässigkeit** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

---

## 🎯 EMPFOHLENE KOMBINATION

**Best Practice: Moonraker + Cron Fallback**

```ini
# moonraker.conf
[update_manager klipper_config]
type: git_repo
path: /home/pi/printer_data/config
origin: git@github.com:DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git
primary_branch: master
is_system_service: False
managed_services: klipper
refresh_interval: 60
enable_auto_refresh: True
```

**+**

```bash
# crontab (Fallback falls Moonraker nicht läuft)
*/5 * * * * /home/pi/printer_data/scripts/cron_git_sync.sh >> /home/pi/printer_data/logs/git-sync.log 2>&1
```

**Vorteile:**
- ✅ Primär: Moonraker (GUI + schnell)
- ✅ Fallback: Cron (falls Moonraker Probleme)
- ✅ Maximale Zuverlässigkeit

---

## 🔧 TROUBLESHOOTING

### Problem: Git Pull schlägt fehl (Permission denied)

```bash
# SSH-Agent prüfen
ssh-add -l

# Falls leer: Key hinzufügen
ssh-add ~/.ssh/id_ed25519

# GitHub SSH testen
ssh -T git@github.com
```

### Problem: Moonraker zeigt Update nicht an

```bash
# Moonraker Logs checken
journalctl -u moonraker | grep update_manager

# Update Manager neu initialisieren
sudo systemctl restart moonraker

# Mainsail Cache löschen (im Browser)
# Ctrl+Shift+R (Hard Refresh)
```

### Problem: Webhook Server startet nicht

```bash
# Port 9000 bereits belegt?
sudo netstat -tulpn | grep 9000

# Service Logs checken
sudo journalctl -u github-webhook -f

# Manuell starten (debug)
python3 ~/printer_data/scripts/webhook_server.py
```

### Problem: Klipper startet nach Pull nicht neu

```bash
# Prüfen ob managed_services gesetzt
grep managed_services ~/printer_data/config/moonraker.conf

# Sollte sein: managed_services: klipper

# Manuell neu starten
sudo systemctl restart klipper
```

---

## 📚 WICHTIGE BEFEHLE

```bash
# Moonraker Update Manager Status
journalctl -u moonraker | grep update_manager

# Git Sync Status
cd ~/printer_data/config
git status
git log -1

# Webhook Server Status
sudo systemctl status github-webhook

# Cron Job Logs
tail -f ~/printer_data/logs/git-sync.log

# Manueller Sync
cd ~/printer_data/config
git pull origin master
sudo systemctl restart klipper
```

---

**Erstellt:** 2026-01-03
**Für:** Raspberry Pi 5 + MainsailOS + Klipper
**Auto-Sync:** Push to GitHub → Auto-Pull auf Drucker

**Happy Printing!** 🚀
