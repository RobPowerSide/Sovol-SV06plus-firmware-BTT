# 💻 VS Code Remote SSH Setup für BTT Pi (192.168.10.5)

## 🎯 Übersicht

Du kannst VS Code direkt mit deinem BTT Pi verbinden und Klipper-Configs **live editieren**!

**Vorteile:**
- ✅ Configs direkt auf dem Pi editieren (kein SCP nötig!)
- ✅ Syntax-Highlighting für G-Code/Klipper
- ✅ Integriertes Terminal (SSH direkt in VS Code)
- ✅ File-Explorer für alle Config-Dateien
- ✅ Git-Integration für Klipper-Configs
- ✅ Multi-Cursor, Auto-Complete, etc.

---

## 📋 VORAUSSETZUNGEN

### 1. VS Code Extensions installieren

Öffne VS Code und installiere:

**A) Remote - SSH** (Microsoft)
- Extension ID: `ms-vscode-remote.remote-ssh`
- Ermöglicht SSH-Verbindung zu Linux-Hosts

**B) Remote - SSH: Editing Configuration Files** (Microsoft)
- Extension ID: `ms-vscode-remote.remote-ssh-edit`
- Für einfachere SSH-Config-Bearbeitung

**Optional aber empfohlen:**

**C) Klipper Configuration** (Michel Morin)
- Extension ID: `mmorin-ls.klipper-config`
- Syntax-Highlighting für Klipper `.cfg` Files

**D) G-Code** (Alexandre Papin)
- Extension ID: `stmn.gcode`
- Syntax-Highlighting für G-Code

### Installation:

```bash
# In VS Code:
Cmd+Shift+P → "Extensions: Install Extensions"

# Suche nach:
1. "Remote - SSH"
2. "Klipper Configuration"
3. "G-Code"
```

Oder direkt via Command-Line:
```bash
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension mmorin-ls.klipper-config
code --install-extension stmn.gcode
```

---

## 🔑 SSH-KEY SETUP (Empfohlen)

**Warum?**
- Keine Passwort-Eingabe bei jeder Verbindung
- Sicherer als Password-Auth
- Schnelleres Verbinden

### Schritt 1: SSH-Key generieren (falls nicht vorhanden)

```bash
# Terminal auf deinem Mac öffnen
cd ~/.ssh

# Prüfe ob Key existiert
ls -la

# Wenn id_rsa / id_ed25519 existiert → Skip zu Schritt 2
# Sonst: Neuen Key generieren
ssh-keygen -t ed25519 -C "dein-mac@sv06plus"

# Enter drücken für Default-Location
# Optional: Passphrase eingeben (oder leer lassen)
```

### Schritt 2: Public Key zum BTT Pi kopieren

```bash
# Public Key zum BTT Pi kopieren
ssh-copy-id biqu@192.168.10.5

# Passwort eingeben (letzte Mal!)
# Default BTT Pi Passwort ist meist: "biqu" oder "raspberry"
```

**Erwartete Ausgabe:**
```
Number of key(s) added: 1

Now try logging into the machine with:
   ssh 'biqu@192.168.10.5'
and check to make sure that only the key(s) you wanted were added.
```

### Schritt 3: Verbindung testen

```bash
# Sollte OHNE Passwort verbinden!
ssh biqu@192.168.10.5

# Wenn erfolgreich:
biqu@BTT-CB1:~$

# Mit Ctrl+D oder "exit" trennen
```

✅ **SSH-Key Setup abgeschlossen!**

---

## 🔧 VS CODE REMOTE SSH KONFIGURATION

### Methode 1: GUI (Einfach)

1. **Öffne VS Code**

2. **Command Palette öffnen:**
   - Mac: `Cmd+Shift+P`
   - Windows/Linux: `Ctrl+Shift+P`

3. **Suche:** `Remote-SSH: Connect to Host...`

4. **Klicke:** `+ Add New SSH Host...`

5. **Eingabe:**
   ```
   ssh biqu@192.168.10.5
   ```

6. **Wähle SSH Config File:**
   ```
   /Users/silvanwigger/.ssh/config
   ```

7. **Klicke:** `Connect`

8. **Wähle Platform:** `Linux`

9. **VS Code verbindet sich!** (beim ersten Mal dauert es ~30 Sek)

✅ **Fertig!**

---

### Methode 2: Manuelle Config (Empfohlen für Power-User)

#### Schritt 1: SSH Config bearbeiten

```bash
# Terminal öffnen
code ~/.ssh/config
```

#### Schritt 2: Folgende Config hinzufügen

```ssh
# Sovol SV06 Plus - BTT Pi 1.2
Host sv06plus
    HostName 192.168.10.5
    User biqu
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ForwardAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 3

    # Optional: Compression für langsame Verbindungen
    # Compression yes

    # Optional: Keep connection alive
    TCPKeepAlive yes

# Alternativ: Kürzerer Alias
Host sv06
    HostName 192.168.10.5
    User biqu
```

**Erklärung:**

| Parameter | Wert | Bedeutung |
|-----------|------|-----------|
| `Host` | sv06plus | Alias-Name (statt IP verwenden) |
| `HostName` | 192.168.10.5 | IP deines BTT Pi |
| `User` | biqu | Default-Username |
| `Port` | 22 | SSH-Port (Standard) |
| `IdentityFile` | ~/.ssh/id_ed25519 | Dein SSH-Key |
| `ServerAliveInterval` | 60 | Ping alle 60 Sek (verhindert Timeout) |

#### Schritt 3: Speichern & in VS Code verbinden

```
VS Code → Cmd+Shift+P → "Remote-SSH: Connect to Host..."
→ Wähle: "sv06plus"
```

✅ **Jetzt kannst du einfach "sv06plus" statt IP verwenden!**

---

## 📁 KLIPPER CONFIG ORDNER ÖFFNEN

### Nach erfolgreicher Verbindung:

1. **VS Code ist jetzt auf dem BTT Pi verbunden**
   - Links unten sollte stehen: `SSH: sv06plus`

2. **Ordner öffnen:**
   - `File` → `Open Folder...`
   - Eingabe: `/home/biqu/printer_data/config`
   - `OK`

3. **Du siehst jetzt:**
   ```
   📁 config/
   ├── 📁 cfgs/
   │   ├── misc-macros.cfg
   │   ├── btt-eddy.cfg
   │   ├── flow-test.cfg
   │   └── ...
   ├── printer.cfg
   ├── moonraker.conf
   └── osskc.cfg
   ```

4. **Editiere direkt!**
   - Doppelklick auf `printer.cfg`
   - Änderungen machen
   - `Cmd+S` zum Speichern
   - **Direkt auf dem Pi gespeichert!** ✅

---

## 🔥 NÜTZLICHE VS CODE FEATURES

### 1. Integriertes Terminal

**Terminal öffnen:**
- `` Ctrl+` `` (Backtick)
- Oder: `Terminal` → `New Terminal`

**Du bist jetzt SSH-verbunden im Terminal!**

```bash
# Beispiele:
ls -la
cd ~/printer_data/config
nano printer.cfg
systemctl status klipper
journalctl -u klipper -f
```

### 2. Multi-File Editing

**Mehrere Dateien öffnen:**
- Split View: `Cmd+\`
- Tabs: Einfach mehrere Files öffnen

**Beispiel:**
- Links: `printer.cfg`
- Rechts: `cfgs/btt-eddy.cfg`

### 3. Suche in allen Files

**Global Search:**
- `Cmd+Shift+F`
- Suche z.B. nach: `probe_count`
- Sieht ALLE Vorkommen in allen Configs!

### 4. Git Integration

**Git in Config-Ordner initialisieren:**

```bash
# Im VS Code Terminal:
cd ~/printer_data/config
git init
git add .
git commit -m "Initial Klipper config backup"
```

**Dann in VS Code:**
- Source Control Panel (links)
- Siehst alle Änderungen
- Commit mit GUI möglich!

### 5. Klipper Config Syntax-Highlighting

**Mit der Extension "Klipper Configuration":**

- ✅ Syntax-Highlighting für `.cfg` Files
- ✅ Auto-Complete für Klipper-Befehle
- ✅ Hover-Tooltips für Parameter
- ✅ Error-Detection

### 6. Makro-Snippets erstellen

**Datei:** `.vscode/klipper.code-snippets` (im Remote-Ordner)

```json
{
  "Klipper GCode Macro": {
    "prefix": "gmacro",
    "body": [
      "[gcode_macro ${1:MACRO_NAME}]",
      "description: ${2:Macro description}",
      "gcode:",
      "    ${3:# Your gcode here}"
    ],
    "description": "Create a Klipper G-Code macro"
  }
}
```

**Dann einfach:** `gmacro` tippen → Tab → Makro-Template!

---

## 🚀 WORKFLOW-BEISPIEL

### Typischer Workflow:

1. **VS Code öffnen**
2. **Cmd+Shift+P** → `Remote-SSH: Connect to Host...` → `sv06plus`
3. **Warte ~5 Sekunden** (Verbindung)
4. **Ordner öffnen:** `/home/biqu/printer_data/config`
5. **Config bearbeiten** (z.B. `printer.cfg`)
6. **Speichern:** `Cmd+S`
7. **Im Terminal:**
   ```bash
   # Klipper neustarten
   systemctl restart klipper

   # Oder in Mainsail Console:
   FIRMWARE_RESTART
   ```
8. **Änderungen testen!**

---

## 🔧 TROUBLESHOOTING

### Problem 1: "Could not establish connection"

**Lösung:**
```bash
# Terminal (Mac):
# Teste SSH-Verbindung
ssh biqu@192.168.10.5

# Wenn Fehler:
# 1. IP prüfen (ping 192.168.10.5)
# 2. SSH-Service prüfen (auf BTT Pi)
sudo systemctl status sshd
```

### Problem 2: "Permission denied (publickey)"

**Lösung:**
```bash
# SSH-Key erneut kopieren
ssh-copy-id -i ~/.ssh/id_ed25519.pub biqu@192.168.10.5

# Oder: Password-Auth aktivieren (temporär)
# Auf BTT Pi:
sudo nano /etc/ssh/sshd_config
# Ändere: PasswordAuthentication yes
sudo systemctl restart sshd
```

### Problem 3: VS Code Extension nicht installiert

**Lösung:**
```bash
# Auf dem REMOTE (BTT Pi) installieren:
# VS Code öffnet automatisch ein neues Fenster
# Warte auf "Installing VS Code Server..."
# Falls hängt: Cmd+Shift+P → "Remote-SSH: Kill VS Code Server on Host"
# Dann neu verbinden
```

### Problem 4: Langsame Verbindung

**Lösung:**

In `~/.ssh/config` hinzufügen:
```ssh
Host sv06plus
    ...
    Compression yes
    Ciphers aes128-gcm@openssh.com
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
```

Dann:
```bash
mkdir -p ~/.ssh/sockets
```

---

## 📚 ZUSÄTZLICHE EXTENSIONS (Optional)

### Für Power-User:

1. **GitLens** (Git history/blame)
   ```
   code --install-extension eamodio.gitlens
   ```

2. **Todo Tree** (Find TODOs in configs)
   ```
   code --install-extension gruntfuggly.todo-tree
   ```

3. **Better Comments** (Colored comments)
   ```
   code --install-extension aaron-bond.better-comments
   ```

4. **Error Lens** (Inline error messages)
   ```
   code --install-extension usernamehw.errorlens
   ```

---

## 🎯 QUICK REFERENCE

### SSH-Verbindung (Terminal)
```bash
# Mit Alias:
ssh sv06

# Mit IP:
ssh biqu@192.168.10.5
```

### VS Code Remote Connect
```
Cmd+Shift+P → "Remote-SSH: Connect to Host..." → "sv06"
```

### Wichtige Pfade auf BTT Pi
```bash
# Klipper Configs:
/home/biqu/printer_data/config/

# Klipper Logs:
/home/biqu/printer_data/logs/

# G-Code Files:
/home/biqu/printer_data/gcodes/

# Klipper Source:
/home/biqu/klipper/
```

### Klipper Befehle (im Terminal)
```bash
# Klipper Status
systemctl status klipper

# Klipper neu starten
systemctl restart klipper

# Klipper Logs live
journalctl -u klipper -f

# Moonraker Status
systemctl status moonraker
```

---

## ✅ SETUP CHECKLISTE

- [ ] VS Code Extensions installiert
  - [ ] Remote - SSH
  - [ ] Klipper Configuration
  - [ ] G-Code Syntax
- [ ] SSH-Key generiert
- [ ] SSH-Key zum BTT Pi kopiert
- [ ] SSH Config (~/.ssh/config) erstellt
- [ ] Verbindung getestet (ssh sv06plus)
- [ ] VS Code Remote-Verbindung erfolgreich
- [ ] Config-Ordner geöffnet (/home/biqu/printer_data/config)
- [ ] Test-Edit durchgeführt und gespeichert
- [ ] Terminal in VS Code funktioniert

**Wenn alle ✅ → Setup abgeschlossen! 🎉**

---

## 🎨 BONUS: VS CODE THEMES für Klipper

**Empfohlene Themes:**

1. **One Dark Pro**
   - Gute Lesbarkeit für G-Code
   - `code --install-extension zhuangtongfa.material-theme`

2. **Dracula Official**
   - Beliebtes Dark Theme
   - `code --install-extension dracula-theme.theme-dracula`

3. **GitHub Theme**
   - Light/Dark Varianten
   - `code --install-extension github.github-vscode-theme`

**Aktivieren:**
```
Cmd+K Cmd+T → Theme auswählen
```

---

## 📊 VORTEILE ZUSAMMENFASSUNG

| Feature | Ohne VS Code | Mit VS Code Remote |
|---------|--------------|-------------------|
| **Editing** | Nano/Vi (basic) | VS Code (full IDE) |
| **Syntax** | Keine | Klipper/G-Code Highlighting |
| **Suche** | grep | Global Search + Replace |
| **Git** | Terminal only | GUI + History |
| **Multi-File** | Umständlich | Split View, Tabs |
| **Backup** | Manuell | Git Integration |
| **Fehler** | Manuell finden | Inline Error-Detection |

**Produktivität**: **+300%** 🚀

---

## 🎯 NÄCHSTE SCHRITTE

1. **Installiere Extensions** (5 Min)
2. **SSH-Key Setup** (5 Min)
3. **Verbinde zu BTT Pi** (2 Min)
4. **Öffne Config-Ordner** (1 Min)
5. **Mache erste Änderung** (Test!)
6. **Genieße den Workflow!** 🎉

---

**Viel Spaß mit VS Code Remote SSH! 💻**

Fragen? Ich helfe gerne weiter! 🚀
