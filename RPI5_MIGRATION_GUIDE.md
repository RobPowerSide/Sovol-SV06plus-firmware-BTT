# 🚀 Raspberry Pi 5 Migration Guide - Sovol SV06 Plus

## 🎯 Übersicht

Migration von BTT Pi 1.2 zu Raspberry Pi 5 mit MainsailOS + GitHub Auto-Sync.

**Hardware:**
- Raspberry Pi 5 (8GB empfohlen)
- NVMe SSD (für `/home/pi/printer_data`)
- MainsailOS (Debian 12 Bookworm)
- Hostname: `3dpi`
- IP: `192.168.10.5` (statisch via Ubiquiti DHCP)

**Features:**
- ✅ GitHub Auto-Sync (Push auf GitHub → Auto-Pull auf Pi)
- ✅ SSH Key Authentication (bereits beim Flash)
- ✅ NVMe für Klipper-Daten (schneller, zuverlässiger)
- ✅ VS Code Remote SSH
- ✅ Moonraker Update Manager mit Git Integration

---

## 📋 PHASE 1: VOR DEM FLASH

### 1.1 Backup vom BTT Pi erstellen

**Auf BTT Pi (192.168.10.5):**

```bash
# SSH zum BTT Pi
ssh biqu@192.168.10.5

# Komplettes Config Backup
cd ~/printer_data/config
tar -czf ~/klipper-config-backup-$(date +%Y%m%d).tar.gz .

# MCU Serial Path notieren
ls -la /dev/serial/by-id/

# Ausgabe notieren! Beispiel:
# /dev/serial/by-id/usb-1a86_USB_Serial-if00-port0

# Moonraker Config prüfen
cat ~/printer_data/config/moonraker.conf | grep -A 5 "update_manager"

# Backup zum Mac kopieren
exit
```

**Auf deinem Mac:**

```bash
# Backup herunterladen
scp biqu@192.168.10.5:~/klipper-config-backup-*.tar.gz ~/Desktop/

# Verifizieren
ls -lh ~/Desktop/klipper-config-backup-*.tar.gz
```

✅ **Backup gesichert!**

---

### 1.2 GitHub Repo vorbereiten

**Du hast bereits das Repo im aktuellen Verzeichnis. Jetzt für Drucker separieren:**

```bash
# Terminal auf Mac
cd "/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT"

# Prüfen ob Git Repo
git status
```

**Option A: Bestehendes Repo nutzen (Empfohlen)**

```bash
# Alle wichtigen Configs sind bereits hier!
# Einfach auf GitHub pushen:

git add .
git commit -m "Pre-RPi5 migration backup - BTT Pi 1.2 final config"
git push origin master

# Branch für RPi5 erstellen (optional):
git checkout -b rpi5-migration
```

**Option B: Neues separates Drucker-Repo erstellen**

```bash
# Nur Klipper-Configs extrahieren
mkdir ~/klipper-sv06plus-prod
cd ~/klipper-sv06plus-prod

# Nur relevante Dateien kopieren
cp -r "/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT/cfgs" .
cp "/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT/printer.cfg" .
cp "/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT/moonraker.conf" .

# Git Repo erstellen
git init
git add .
git commit -m "Initial commit - Sovol SV06 Plus production config"

# GitHub Repo erstellen (via CLI)
gh repo create klipper-sv06plus-prod --private --source=. --remote=origin
git push -u origin main
```

**Empfehlung:** Option A (bestehendes Repo), da du schon alles perfekt dokumentiert hast!

---

### 1.3 SSH Public Key bereitstellen

```bash
# Public Key anzeigen
cat ~/.ssh/id_ed25519.pub

# Gesamte Zeile kopieren (für Raspberry Pi Imager)
# Beispiel:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIxxx... mac@sv06plus
```

**In Zwischenablage kopieren (Cmd+C)**

---

## 📋 PHASE 2: RASPBERRY PI IMAGER SETUP

### 2.1 MainsailOS flashen

**Download:**
- https://github.com/mainsail-crew/MainsailOS/releases
- Latest: `mainsail-rpi-arm64-*.img.xz` (für RPi 5)

**Raspberry Pi Imager:**

1. **Choose OS** → **Use custom** → MainsailOS Image wählen
2. **Choose Storage** → SD-Karte (min. 16GB, empfohlen 32GB+)
3. **⚙️ Advanced Options** (Zahnrad-Icon):

```
✅ Set hostname
   └─ Hostname: 3dpi

✅ Enable SSH
   └─ ● Allow public-key authentication only

   Authorized keys:
   ┌────────────────────────────────────────────────────────┐
   │ ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIxxx... mac@sv06plus│
   └────────────────────────────────────────────────────────┘

   WICHTIG: Deinen kompletten Public Key hier einfügen!

✅ Set username and password
   └─ Username: pi
   └─ Password: [SICHERES-PASSWORT]  (für Recovery/Console)

✅ Set locale settings
   └─ Time zone: Europe/Zurich
   └─ Keyboard layout: de

❌ Configure wireless LAN
   └─ Nicht nötig (du nutzt LAN)
```

4. **Save**
5. **Write** → Warten (~5-10 Min)

✅ **SD-Karte fertig!**

---

### 2.2 NVMe SSD Setup (Optional aber empfohlen)

**Falls du NVMe für `/home/pi/printer_data` nutzen willst:**

**Hardware:**
- NVMe Base Board für RPi 5
- M.2 NVMe SSD (z.B. 128GB reicht)

**Nach erstem Boot konfigurieren** (siehe Phase 3.3)

---

## 📋 PHASE 3: RASPBERRY PI 5 ERSTE SCHRITTE

### 3.1 Erster Boot & SSH Test

**Hardware:**
1. SD-Karte in RPi 5 einlegen
2. Drucker per USB verbinden (für MCU)
3. LAN-Kabel verbinden
4. Strom anschließen → Boot (~30 Sekunden)

**Auf deinem Mac:**

```bash
# SSH Config anpassen
code ~/.ssh/config
```

**SSH Config aktualisieren:**

```ssh
# Sovol SV06 Plus - Raspberry Pi 5 (MainsailOS)
Host sv06
    HostName 192.168.10.5
    User pi
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ForwardAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes

# Alternative: Hostname-basiert (funktioniert auch ohne DHCP)
Host 3dpi
    HostName 3dpi.local
    User pi
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ForwardAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
```

**Speichern (Cmd+S)**

**SSH Verbindung testen:**

```bash
# Mit Hostname (sollte direkt funktionieren)
ssh 3dpi

# ODER mit IP (nachdem Ubiquiti DHCP Reservation aktiv)
ssh sv06

# Sollte OHNE Passwort verbinden!
pi@3dpi:~ $
```

✅ **SSH funktioniert!**

---

### 3.2 System Update & Git Setup

```bash
# Im SSH Terminal (auf RPi 5):

# System updaten
sudo apt update && sudo apt upgrade -y

# Git Version prüfen
git --version
# Sollte: git version 2.39.x oder höher

# Git global konfigurieren
git config --global user.name "Silvan Wigger"
git config --global user.email "deine@email.com"

# SSH-Agent für GitHub (falls du SSH für GitHub nutzt)
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

### 3.3 NVMe SSD einrichten (Optional)

**Falls du NVMe nutzt:**

```bash
# NVMe erkennen
lsblk

# Erwartete Ausgabe:
# nvme0n1     259:0    0  XXG  0 disk
# mmcblk0     179:0    0  XXG  0 disk  ← SD-Karte
# └─mmcblk0p1 179:1    0  XXG  0 part /

# NVMe formatieren (ACHTUNG: Alle Daten werden gelöscht!)
sudo mkfs.ext4 /dev/nvme0n1

# Mount-Point erstellen
sudo mkdir -p /mnt/nvme

# NVMe mounten
sudo mount /dev/nvme0n1 /mnt/nvme

# Auto-Mount bei Boot (fstab)
echo "/dev/nvme0n1 /mnt/nvme ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab

# Klipper-Daten auf NVMe verschieben
sudo systemctl stop klipper moonraker

# Daten kopieren
sudo rsync -av /home/pi/printer_data/ /mnt/nvme/printer_data/

# Symlink erstellen
sudo mv /home/pi/printer_data /home/pi/printer_data.backup
sudo ln -s /mnt/nvme/printer_data /home/pi/printer_data

# Services neu starten
sudo systemctl start klipper moonraker

# Prüfen
df -h /home/pi/printer_data
# Sollte nvme0n1 zeigen!
```

✅ **NVMe aktiv! Viel schneller für Logs/Configs!**

---

## 📋 PHASE 4: GITHUB AUTO-SYNC SETUP

### 4.1 GitHub Repo auf RPi 5 clonen

**Im SSH Terminal (auf RPi 5):**

```bash
# Klipper stoppen
sudo systemctl stop klipper moonraker

# Standard-Config sichern
cd ~/printer_data
mv config config.mainsail-default-backup

# GitHub Repo clonen
git clone git@github.com:DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git config

# ODER mit HTTPS (falls du kein GitHub SSH-Key hast):
git clone https://github.com/DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git config

# In Config-Ordner wechseln
cd config

# Prüfen
ls -la
# Sollte alle deine Configs zeigen (printer.cfg, cfgs/, etc.)
```

---

### 4.2 GitHub SSH-Key für RPi 5 erstellen (für Push-Rechte)

**Falls du vom Pi aus auch pushen willst:**

```bash
# Auf RPi 5:
ssh-keygen -t ed25519 -C "rpi5@3dpi"

# Public Key anzeigen
cat ~/.ssh/id_ed25519.pub

# Kopieren und zu GitHub hinzufügen:
# https://github.com/settings/keys
# → "New SSH key" → Einfügen

# SSH zu GitHub testen
ssh -T git@github.com
# Erwartete Ausgabe: "Hi DEIN-USERNAME! You've successfully authenticated..."
```

---

### 4.3 Moonraker Update Manager für GitHub

**Moonraker Config bearbeiten:**

```bash
# Auf RPi 5:
nano ~/printer_data/config/moonraker.conf
```

**Folgende Section HINZUFÜGEN (oder anpassen falls vorhanden):**

```ini
[update_manager klipper_config]
type: git_repo
path: /home/pi/printer_data/config
origin: git@github.com:DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git
primary_branch: master
is_system_service: False
managed_services: klipper

# Falls du HTTPS nutzt statt SSH:
# origin: https://github.com/DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git
```

**Speichern:** `Ctrl+O`, Enter, `Ctrl+X`

**Moonraker neu starten:**

```bash
sudo systemctl restart moonraker
```

---

### 4.4 GitHub Webhook für Auto-Pull (INSTANT UPDATE!)

**Das ist der Clou: Push auf GitHub → Pi pulled automatisch!**

#### Option A: Moonraker API Webhook (Empfohlen!)

**1. Moonraker API Token erstellen:**

```bash
# Auf RPi 5:
cd ~/printer_data/config

# API Token anzeigen (wird automatisch von Moonraker generiert)
curl http://localhost:7125/access/api_key
```

**Ausgabe notieren (z.B.):**
```json
{"result": "abc123xyz456..."}
```

**2. GitHub Webhook einrichten:**

**Auf github.com:**
1. Gehe zu deinem Repo: `https://github.com/DEIN-USERNAME/Sovol-SV06plus-firmware-BTT`
2. **Settings** → **Webhooks** → **Add webhook**
3. **Payload URL:**
   ```
   http://192.168.10.5:7125/server/database/item?namespace=update_manager
   ```
   **ODER (sicherer, falls du Port-Forwarding hast):**
   ```
   https://3dpi.deine-domain.com:7125/server/database/item?namespace=update_manager
   ```
4. **Content type:** `application/json`
5. **Secret:** (leer lassen)
6. **Which events?** → ✅ Just the `push` event
7. **Active** → ✅
8. **Add webhook**

**3. Moonraker Config für Auto-Update:**

```bash
nano ~/printer_data/config/moonraker.conf
```

**Erweitern der `[update_manager klipper_config]` Section:**

```ini
[update_manager klipper_config]
type: git_repo
path: /home/pi/printer_data/config
origin: git@github.com:DEIN-USERNAME/Sovol-SV06plus-firmware-BTT.git
primary_branch: master
is_system_service: False
managed_services: klipper
refresh_interval: 60  # Alle 60 Sekunden prüfen
```

**Speichern & Restart:**

```bash
sudo systemctl restart moonraker
```

#### Option B: Cron Job (Fallback)

**Falls Webhook nicht funktioniert:**

```bash
# Crontab öffnen
crontab -e

# Folgende Zeile hinzufügen (alle 2 Minuten Pull):
*/2 * * * * cd /home/pi/printer_data/config && git pull origin master >/dev/null 2>&1
```

---

### 4.5 Test: GitHub → RPi Auto-Sync

**Auf deinem Mac (im Repo-Ordner):**

```bash
cd "/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT"

# Test-Änderung machen
echo "# Test: GitHub Auto-Sync $(date)" >> README.md

# Committen & Pushen
git add README.md
git commit -m "Test: GitHub Auto-Sync"
git push origin master
```

**Auf RPi 5 prüfen (nach 1-2 Min):**

```bash
ssh sv06

cd ~/printer_data/config
git log -1
# Sollte deinen neuen Commit zeigen!

cat README.md
# Sollte die neue Zeile zeigen!
```

✅ **Auto-Sync funktioniert!**

---

## 📋 PHASE 5: KLIPPER MCU KONFIGURATION

### 5.1 MCU Serial Path ermitteln

**Auf RPi 5:**

```bash
# Drucker per USB verbinden (falls noch nicht geschehen)

# Serial Path finden
ls -la /dev/serial/by-id/

# Ausgabe notieren! Beispiel:
# lrwxrwxrwx 1 root root 13 Jan  3 10:00 usb-1a86_USB_Serial-if00-port0 -> ../../ttyUSB0
```

**Serial Path ist:** `/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0`

---

### 5.2 printer.cfg anpassen

**Auf RPi 5:**

```bash
nano ~/printer_data/config/printer.cfg
```

**MCU Section prüfen/anpassen:**

```ini
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB_Serial-if00-port0
# ↑ Hier dein Serial Path eintragen!

restart_method: command
```

**Speichern:** `Ctrl+O`, Enter, `Ctrl+X`

---

### 5.3 Klipper Firmware Restart

```bash
# Klipper neu starten
sudo systemctl restart klipper

# Status prüfen
sudo systemctl status klipper

# Sollte: "active (running)" zeigen

# Logs checken
journalctl -u klipper -f
# Sollte KEINE Errors zeigen
# Ctrl+C zum Beenden
```

---

### 5.4 Mainsail UI testen

**Im Browser (auf deinem Mac):**

```
http://192.168.10.5
# ODER:
http://3dpi.local
```

**Sollte Mainsail UI öffnen!**

**Prüfen:**
- ✅ Klipper Status: "Ready"
- ✅ MCU verbunden
- ✅ Temperature sensors angezeigt
- ✅ Keine Errors

---

## 📋 PHASE 6: VS CODE REMOTE SSH

### 6.1 VS Code verbinden

**Auf deinem Mac:**

1. **VS Code öffnen**
2. **Cmd+Shift+P** → `Remote-SSH: Connect to Host...`
3. **Wähle:** `sv06` (oder `3dpi`)
4. **Warte ~10 Sekunden** (beim ersten Mal VS Code Server Installation)
5. **Unten links sollte stehen:** `SSH: sv06`

---

### 6.2 Config-Ordner öffnen

**In VS Code (verbunden mit RPi 5):**

1. **File** → **Open Folder...**
2. **Eingabe:** `/home/pi/printer_data/config`
3. **OK**

**Du siehst jetzt:**
```
📁 config/
├── 📁 cfgs/
│   ├── btt-eddy.cfg
│   ├── flow-test.cfg
│   ├── misc-macros.cfg
│   └── ...
├── printer.cfg
├── moonraker.conf
└── ...
```

---

### 6.3 Live-Editing mit Auto-Sync

**Workflow:**

```
1. In VS Code (Remote auf RPi 5): Datei editieren
2. Cmd+S → Speichert direkt auf Pi
3. Im VS Code Terminal:
   git add .
   git commit -m "Updated XYZ"
   git push origin master
4. → Änderungen sind auf GitHub
5. → Backup automatisch in Cloud!
```

**Alternative (nur lokale Änderungen):**

```
1. Auf Mac: Dateien editieren im Repo-Ordner
2. git push origin master
3. → RPi 5 pulled automatisch (Webhook/Cron)
4. → FIRMWARE_RESTART in Mainsail
```

---

## 📋 PHASE 7: BTT EDDY 2.0 VORBEREITUNG

### 7.1 BTT Eddy Config vorbereiten

**Datei bereits vorhanden: `cfgs/btt-eddy.cfg`**

**Anpassen für BTT Eddy 2.0 USB:**

```bash
# In VS Code Remote (oder SSH):
nano ~/printer_data/config/cfgs/btt-eddy.cfg
```

**Für BTT Eddy 2.0 USB:**

```ini
# BTT Eddy 2.0 Probe Configuration (USB Mode)
# Hardware: BTT Eddy USB/CAN Coil Probe v2.0
# Connection: USB
# Docs: https://bttwiki.com/eddy.html

[mcu eddy]
serial: /dev/serial/by-id/usb-Klipper_rp2040_XXXXXXXXXXXXXX-if00
# ↑ Wird später ersetzt wenn Eddy angeschlossen!

[temperature_sensor btt_eddy]
sensor_type: temperature_mcu
sensor_mcu: eddy
min_temp: 0
max_temp: 100

[probe_eddy_current btt_eddy]
sensor_type: ldc1612
i2c_mcu: eddy
i2c_bus: i2c0f  # BTT Eddy 2.0 USB nutzt i2c0f
z_offset: 0.0  # Wird nach Installation kalibriert!
x_offset: 27.0  # Anpassen an deine Mount-Position!
y_offset: -20.0  # Anpassen an deine Mount-Position!

# Probing Settings
samples: 3
samples_result: median
samples_tolerance: 0.005
samples_tolerance_retries: 3

# Speed Settings
speed: 10.0  # Probing speed (mm/s)
lift_speed: 20.0
sample_retract_dist: 2.0

[bed_mesh]
speed: 250  # VIEL schneller mit Eddy!
horizontal_move_z: 2  # Eddy kann niedrig fahren
mesh_min: 32, 35
mesh_max: 273, 295
probe_count: 9, 9  # Höhere Auflösung möglich!
algorithm: bicubic
bicubic_tension: 0.2
fade_start: 1.0
fade_end: 10.0
fade_target: 0.0

# Temperature Drift Compensation
[probe_eddy_current btt_eddy]
drift_calibration:
    # Nach Installation kalibrieren mit:
    # PROBE_EDDY_DRIFT_CALIBRATION PROBE_TEMP_START=40 PROBE_TEMP_END=80 PROBE_TEMP_STEP=5

[gcode_macro PROBE_EDDY_DRIFT_CALIBRATE]
gcode:
    {% set start_temp = params.PROBE_TEMP_START|default(40)|float %}
    {% set end_temp = params.PROBE_TEMP_END|default(80)|float %}
    {% set step = params.PROBE_TEMP_STEP|default(5)|float %}

    RESPOND MSG="Starting Eddy drift calibration: {start_temp}°C to {end_temp}°C"
    TEMPERATURE_PROBE_CALIBRATE PROBE=btt_eddy PROBE_TEMP_START={start_temp} PROBE_TEMP_END={end_temp} PROBE_TEMP_STEP={step}
```

**Speichern!**

---

### 7.2 Installation Checklist (für später)

**Wenn BTT Eddy 2.0 ankommt:**

```bash
# 1. Hardware Installation
# - Eddy an Druckkopf montieren
# - USB-Kabel zum RPi 5 verbinden
# - X/Y Offset messen und in Config eintragen

# 2. Serial Path ermitteln
ls -la /dev/serial/by-id/ | grep rp2040

# 3. In btt-eddy.cfg eintragen
nano ~/printer_data/config/cfgs/btt-eddy.cfg
# [mcu eddy]
# serial: /dev/serial/by-id/usb-Klipper_rp2040_XXXXXX...

# 4. Eddy in printer.cfg includen (falls noch nicht)
nano ~/printer_data/config/printer.cfg
# [include ./cfgs/btt-eddy.cfg]

# 5. FIRMWARE_RESTART
# 6. Z-Offset kalibrieren: PROBE_CALIBRATE
# 7. Drift Calibration: PROBE_EDDY_DRIFT_CALIBRATE
# 8. Test Bed Mesh: BED_MESH_CALIBRATE
```

---

## 📋 CHECKLISTE - VOLLSTÄNDIGE MIGRATION

### ✅ Phase 1: Vorbereitung
- [ ] Backup vom BTT Pi erstellt
- [ ] GitHub Repo gepusht
- [ ] SSH Public Key kopiert

### ✅ Phase 2: MainsailOS Flash
- [ ] MainsailOS Image heruntergeladen
- [ ] Raspberry Pi Imager Advanced Options gesetzt:
  - [ ] Hostname: `3dpi`
  - [ ] SSH Public-Key eingefügt
  - [ ] Username: `pi`
  - [ ] Password gesetzt
  - [ ] Locale: Europe/Zurich
- [ ] SD-Karte geflasht

### ✅ Phase 3: RPi 5 Setup
- [ ] Ubiquiti DHCP Reservation: 192.168.10.5
- [ ] SSH Config angepasst (`~/.ssh/config`)
- [ ] SSH Verbindung ohne Passwort funktioniert
- [ ] System Update durchgeführt
- [ ] Git konfiguriert
- [ ] NVMe SSD eingerichtet (optional)

### ✅ Phase 4: GitHub Auto-Sync
- [ ] Repo auf RPi 5 geclont
- [ ] Moonraker Update Manager konfiguriert
- [ ] GitHub Webhook eingerichtet (optional)
- [ ] Auto-Sync getestet (Push → Pull)

### ✅ Phase 5: Klipper Config
- [ ] MCU Serial Path ermittelt
- [ ] printer.cfg angepasst
- [ ] Klipper neu gestartet
- [ ] Mainsail UI funktioniert
- [ ] MCU verbunden, keine Errors

### ✅ Phase 6: VS Code Remote
- [ ] VS Code mit RPi 5 verbunden
- [ ] Config-Ordner geöffnet
- [ ] Live-Editing getestet

### ✅ Phase 7: BTT Eddy Vorbereitung
- [ ] btt-eddy.cfg für Eddy 2.0 USB vorbereitet
- [ ] Installation Checklist bereit

---

## 🎯 NÄCHSTE SCHRITTE

**Nach erfolgreicher Migration:**

1. **Test-Print durchführen**
   - Benchy oder Calibration Cube
   - Prüfen ob alles wie vorher funktioniert

2. **Phase 1 Kalibrierungen durchführen**
   - Z-Tilt via Probe
   - Axis Twist Compensation
   - Bed Mesh mit neuem Setup

3. **KAMP aktivieren**
   - `variable_kamp_enable: 1` in misc-macros.cfg
   - PrusaSlicer Start-GCode anpassen

4. **Flow-Test durchführen**
   - `FLOW_TEST TEMP=215`
   - Maximale Volumetric Speed ermitteln

5. **PrusaSlicer anpassen**
   - Max Volumetric Speed auf 80% setzen

6. **Weitere Optimierungen**
   - PID Tuning
   - Pressure Advance
   - Input Shaper (mit ADXL345)

7. **BTT Eddy Installation** (wenn angekommen)
   - Hardware montieren
   - Firmware konfigurieren
   - Kalibrieren

---

## 🔧 TROUBLESHOOTING

### Problem: SSH Verbindung klappt nicht

```bash
# Ping testen
ping 192.168.10.5

# SSH verbose
ssh -v sv06

# Falls Permission denied:
# Public Key nochmal prüfen im Raspberry Pi Imager
```

### Problem: Git Pull schlägt fehl

```bash
# Auf RPi 5:
cd ~/printer_data/config
git status

# Falls "detached HEAD":
git checkout master
git pull origin master
```

### Problem: Klipper startet nicht

```bash
# Logs checken
journalctl -u klipper -n 50

# MCU Serial Path prüfen
ls -la /dev/serial/by-id/

# Config Syntax prüfen
cd ~/printer_data/config
python3 ~/klipper/klippy/klippy.py printer.cfg -I printer.cfg.dict
```

### Problem: Moonraker Update Manager zeigt Config nicht

```bash
# moonraker.conf prüfen
nano ~/printer_data/config/moonraker.conf

# Moonraker neu starten
sudo systemctl restart moonraker

# Logs checken
journalctl -u moonraker -f
```

---

## 📚 WICHTIGE BEFEHLE - QUICK REFERENCE

```bash
# SSH Verbindung
ssh sv06
ssh 3dpi

# Klipper Services
sudo systemctl status klipper
sudo systemctl restart klipper
sudo systemctl status moonraker
sudo systemctl restart moonraker

# Logs
journalctl -u klipper -f
journalctl -u moonraker -f

# Git Operations
cd ~/printer_data/config
git status
git pull origin master
git add .
git commit -m "Updated config"
git push origin master

# MCU Serial
ls -la /dev/serial/by-id/

# NVMe Check
df -h /home/pi/printer_data
```

---

**Erstellt:** 2026-01-03
**Für:** Sovol SV06 Plus + Raspberry Pi 5 + MainsailOS
**Auto-Sync:** GitHub Webhook/Moonraker Update Manager

**Viel Erfolg mit der Migration!** 🚀
