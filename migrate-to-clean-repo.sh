#!/bin/bash

################################################################################
# Klipper Config Migration Script
#
# Erstellt sauberes Production-Repo aus Fork
# - Extrahiert nur relevante Config-Files
# - Fügt Upstream (bassamanator) als Remote hinzu
# - Pushed auf GitHub
# - Bereitet RPi 5 Setup vor
#
# Author: Claude Code
# Date: 2026-01-03
################################################################################

set -e  # Exit bei Fehler

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Header
echo -e "${BLUE}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   Klipper Config Migration Script                          ║
║   Fork → Clean Production Repo                             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

################################################################################
# CONFIGURATION
################################################################################

# Source (aktueller Fork)
SOURCE_DIR="/Users/silvanwigger/Library/Mobile Documents/com~apple~CloudDocs/02-Silvan/10_Development/Sovol-SV06plus-firmware-BTT"

# Target (neues Production Repo)
TARGET_DIR="$HOME/klipper-sv06plus-production"

# GitHub Settings
GITHUB_USERNAME=""  # Wird abgefragt
REPO_NAME="klipper-sv06plus-production"

# Upstream (bassamanator)
UPSTREAM_URL="https://github.com/bassamanator/Sovol-SV06-firmware.git"

################################################################################
# PREFLIGHT CHECKS
################################################################################

log_info "Starte Preflight Checks..."

# Check: Source Directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    log_error "Source Directory nicht gefunden: $SOURCE_DIR"
    exit 1
fi
log_success "Source Directory gefunden"

# Check: Git installiert
if ! command -v git &> /dev/null; then
    log_error "Git ist nicht installiert!"
    exit 1
fi
log_success "Git gefunden: $(git --version)"

# Check: GitHub CLI (optional)
if command -v gh &> /dev/null; then
    GH_CLI_AVAILABLE=true
    log_success "GitHub CLI gefunden: $(gh --version | head -n1)"
else
    GH_CLI_AVAILABLE=false
    log_warning "GitHub CLI nicht gefunden (optional)"
fi

# Check: Target Directory existiert nicht
if [ -d "$TARGET_DIR" ]; then
    log_warning "Target Directory existiert bereits: $TARGET_DIR"
    read -p "Überschreiben? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Abbruch."
        exit 0
    fi
    log_info "Lösche bestehende Directory..."
    rm -rf "$TARGET_DIR"
fi

log_success "Preflight Checks abgeschlossen!"
echo ""

################################################################################
# USER INPUT
################################################################################

log_info "Bitte folgende Informationen eingeben:"
echo ""

# GitHub Username
if [ -z "$GITHUB_USERNAME" ]; then
    read -p "GitHub Username: " GITHUB_USERNAME
fi

# Bestätigung
echo ""
log_info "═══════════════════════════════════════"
log_info "Source:   $SOURCE_DIR"
log_info "Target:   $TARGET_DIR"
log_info "GitHub:   https://github.com/$GITHUB_USERNAME/$REPO_NAME"
log_info "Upstream: $UPSTREAM_URL"
log_info "═══════════════════════════════════════"
echo ""

read -p "Fortfahren? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Abbruch."
    exit 0
fi

################################################################################
# PHASE 1: NEUES REPO ERSTELLEN
################################################################################

echo ""
log_info "═══════════════════════════════════════"
log_info "PHASE 1: Neues Repository erstellen"
log_info "═══════════════════════════════════════"

# Target Directory erstellen
log_info "Erstelle Target Directory..."
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"
log_success "Directory erstellt: $TARGET_DIR"

# Git initialisieren
log_info "Git Repository initialisieren..."
git init
git branch -M main
log_success "Git initialisiert (Branch: main)"

################################################################################
# PHASE 2: FILES KOPIEREN
################################################################################

echo ""
log_info "═══════════════════════════════════════"
log_info "PHASE 2: Production Files kopieren"
log_info "═══════════════════════════════════════"

# Klipper Core Configs
log_info "Kopiere Klipper Core Configs..."
cp "$SOURCE_DIR/printer.cfg" .
cp "$SOURCE_DIR/moonraker.conf" .
log_success "Core Configs kopiert"

# cfgs/ Directory
log_info "Kopiere cfgs/ Directory..."
cp -r "$SOURCE_DIR/cfgs" .
log_success "cfgs/ kopiert"

# Dokumentation (deine eigenen Guides)
log_info "Kopiere Dokumentation..."
DOCS=(
    "BED_SCREWS_CALCULATOR.md"
    "BTT_EDDY_WIRING.md"
    "BTT_PI_vs_RPI5_ANALYSIS.md"
    "GITHUB_AUTO_SYNC_GUIDE.md"
    "NOZZLE_GUIDE.md"
    "PRUSASLICER_START_GCODE.txt"
    "RPI5_MIGRATION_GUIDE.md"
    "SETUP_GUIDE.md"
    "SSH_KEY_SETUP_GUIDE.md"
    "VSCODE_EXTENSIONS_INSTALL.md"
    "VSCODE_REMOTE_SETUP.md"
)

for doc in "${DOCS[@]}"; do
    if [ -f "$SOURCE_DIR/$doc" ]; then
        cp "$SOURCE_DIR/$doc" .
        log_success "  ✓ $doc"
    else
        log_warning "  ⚠ $doc nicht gefunden (übersprungen)"
    fi
done

################################################################################
# PHASE 3: README & .gitignore ERSTELLEN
################################################################################

echo ""
log_info "═══════════════════════════════════════"
log_info "PHASE 3: README & .gitignore erstellen"
log_info "═══════════════════════════════════════"

# README.md
log_info "Erstelle README.md..."
cat > README.md << 'EOF'
# Sovol SV06 Plus - Production Klipper Config

Personal Klipper configuration for Sovol SV06 Plus 3D Printer.

## 🖨️ Hardware

- **Printer:** Sovol SV06 Plus (300×300×340mm)
- **Controller:** Raspberry Pi 5 (8GB) + NVMe SSD
- **OS:** MainsailOS (Debian 12 Bookworm)
- **Probe:** BTT Eddy 2.0 USB/CAN Coil Probe
- **Nozzles:**
  - Hardened Steel 0.4mm
  - Hardened Steel 0.6mm
  - CHT Brass 0.4mm (geplant)

## ✨ Features

- ⚡ **BTT Eddy USB Coil Probe** - 5× faster bed meshing
- 🎯 **KAMP** - Klipper Adaptive Meshing & Purging
- 📐 **Dynamic Bed Screw Calculator** - Auto-berechnet aus bed dimensions
- 🔬 **Flow Rate Testing** - Maximale Volumetric Speed ermitteln
- 🔄 **GitHub Auto-Sync** - Push to GitHub → Auto-Pull auf Drucker
- 📊 **Z-Tilt Calibration** - Gantry leveling via probe
- 🔧 **Custom Macros** - Enhanced START_PRINT, END_PRINT, etc.

## 📁 Struktur

```
.
├── printer.cfg              # Main Klipper config
├── moonraker.conf           # Moonraker config (GitHub Auto-Sync)
├── cfgs/                    # Modular config files
│   ├── btt-eddy.cfg        # BTT Eddy 2.0 USB probe
│   ├── flow-test.cfg       # Flow rate testing macros
│   ├── misc-macros.cfg     # Custom G-code macros
│   ├── z_tilt_via_probe.cfg
│   └── dynamic-bed-screws.cfg
└── docs/                    # Documentation
    ├── SETUP_GUIDE.md
    ├── RPI5_MIGRATION_GUIDE.md
    ├── GITHUB_AUTO_SYNC_GUIDE.md
    └── ...
```

## 📚 Documentation

### Setup Guides
- [Complete Setup Guide](SETUP_GUIDE.md) - Vollständige Einrichtung
- [RPi5 Migration Guide](RPI5_MIGRATION_GUIDE.md) - Migration von BTT Pi → RPi 5
- [GitHub Auto-Sync Setup](GITHUB_AUTO_SYNC_GUIDE.md) - Auto-Pull beim Push

### Hardware Guides
- [BTT Eddy Wiring](BTT_EDDY_WIRING.md) - BTT Eddy 2.0 Verkabelung
- [BTT Pi vs RPi5 Analysis](BTT_PI_vs_RPI5_ANALYSIS.md) - Hardware Vergleich
- [Nozzle Guide](NOZZLE_GUIDE.md) - CHT vs Standard vs Hardened Steel

### Development Tools
- [SSH Key Setup](SSH_KEY_SETUP_GUIDE.md) - Passwortlose SSH-Verbindung
- [VS Code Remote Setup](VSCODE_REMOTE_SETUP.md) - Remote Editing
- [VS Code Extensions](VSCODE_EXTENSIONS_INSTALL.md) - Empfohlene Extensions

### Calibration
- [Bed Screws Calculator](BED_SCREWS_CALCULATOR.md) - Dynamische Schrauben-Berechnung

## 🔄 Usage

### Auto-Sync Workflow

```bash
# 1. Änderungen machen (lokal oder VS Code Remote)
vim printer.cfg

# 2. Committen & Pushen
git add printer.cfg
git commit -m "Adjust extruder steps"
git push origin main

# 3. → Moonraker pulled automatisch auf RPi 5!
# 4. → Klipper restart automatisch (bei .cfg Änderungen)
```

### Mainsail UI Update

- **Settings** → **Update Manager** → **klipper_config** → **Update**

## 🌐 Upstream Reference

Basierend auf Konfigurationen von:
- [bassamanator/Sovol-SV06-firmware](https://github.com/bassamanator/Sovol-SV06-firmware)

Upstream als Remote verfügbar:
```bash
git fetch upstream
git diff upstream/master -- printer.cfg
```

## 🚀 Quick Commands

```bash
# SSH zu Drucker
ssh sv06

# Klipper Status
systemctl status klipper

# Logs
journalctl -u klipper -f

# Git Sync (manuell)
cd ~/printer_data/config
git pull origin main
```

## 📝 Changelog

Siehe [Git Commits](https://github.com/YOUR-USERNAME/klipper-sv06plus-production/commits/main) für detaillierte Historie.

## 📄 License

Personal configuration - Not licensed for redistribution.
Based on work by bassamanator (MIT License).

---

**Happy Printing!** 🖨️
EOF

log_success "README.md erstellt"

# .gitignore
log_info "Erstelle .gitignore..."
cat > .gitignore << 'EOF'
# Klipper Runtime Files
*.pyc
__pycache__/
*.dict
*.tmp
*.swp
*~

# Logs
*.log
logs/

# Backup Files
*.backup
*.bak
*-backup-*
*.old

# OS Files
.DS_Store
Thumbs.db
.vscode/
.idea/

# Secrets
.env
secrets/
*.key
*.pem

# Moonraker Database
.moonraker_database/
database/

# Temporary Files
tmp/
temp/
EOF

log_success ".gitignore erstellt"

################################################################################
# PHASE 4: GIT COMMIT
################################################################################

echo ""
log_info "═══════════════════════════════════════"
log_info "PHASE 4: Initial Commit"
log_info "═══════════════════════════════════════"

# Alle Files hinzufügen
log_info "Stage alle Files..."
git add .

# Commit erstellen
log_info "Erstelle Initial Commit..."
git commit -m "Initial commit: Clean production config

Sovol SV06 Plus Klipper Configuration
- Raspberry Pi 5 + MainsailOS
- BTT Eddy 2.0 USB probe config
- KAMP integration
- Flow test macros
- Dynamic bed screw calculator
- Complete documentation

Hardware:
- Printer: Sovol SV06 Plus (300×300×340mm)
- Controller: Raspberry Pi 5 (8GB) + NVMe
- Probe: BTT Eddy 2.0 USB/CAN
- Nozzles: Hardened Steel 0.4mm & 0.6mm

Features:
- GitHub Auto-Sync (Moonraker Update Manager)
- KAMP Adaptive Meshing
- Z-Tilt Calibration
- Flow Rate Testing

Source: Extracted from fork of bassamanator/Sovol-SV06-firmware
" > /dev/null

log_success "Initial Commit erstellt!"

# Commit anzeigen
git log -1 --oneline

################################################################################
# PHASE 5: UPSTREAM REMOTE
################################################################################

echo ""
log_info "═══════════════════════════════════════"
log_info "PHASE 5: Upstream Remote hinzufügen"
log_info "═══════════════════════════════════════"

# Upstream Remote hinzufügen
log_info "Füge Upstream Remote hinzu..."
git remote add upstream "$UPSTREAM_URL"
log_success "Upstream Remote hinzugefügt: $UPSTREAM_URL"

# Upstream fetchen
log_info "Fetche Upstream..."
git fetch upstream > /dev/null 2>&1
log_success "Upstream gefetcht!"

# Remotes anzeigen
log_info "Konfigurierte Remotes:"
git remote -v

################################################################################
# PHASE 6: GITHUB REPO ERSTELLEN
################################################################################

echo ""
log_info "═══════════════════════════════════════"
log_info "PHASE 6: GitHub Repository erstellen"
log_info "═══════════════════════════════════════"

if [ "$GH_CLI_AVAILABLE" = true ]; then
    log_info "Erstelle GitHub Repo mit gh CLI..."

    # Check: gh authenticated
    if gh auth status > /dev/null 2>&1; then
        log_success "GitHub CLI authenticated"

        # Repo erstellen
        log_info "Erstelle privates Repo: $REPO_NAME..."
        if gh repo create "$REPO_NAME" --private --source=. --remote=origin --push; then
            log_success "GitHub Repo erstellt und gepusht!"
            REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME"
            log_success "URL: $REPO_URL"
        else
            log_error "GitHub Repo Erstellung fehlgeschlagen!"
            log_warning "Erstelle Remote manuell..."
            MANUAL_SETUP=true
        fi
    else
        log_warning "GitHub CLI nicht authenticated"
        log_info "Führe aus: gh auth login"
        MANUAL_SETUP=true
    fi
else
    MANUAL_SETUP=true
fi

if [ "$MANUAL_SETUP" = true ]; then
    log_info "Manuelle GitHub Repo Erstellung erforderlich:"
    echo ""
    echo "1. Gehe zu: https://github.com/new"
    echo "2. Repository name: $REPO_NAME"
    echo "3. Visibility: Private"
    echo "4. NICHT initialisieren mit README/License/.gitignore"
    echo "5. Create repository"
    echo ""
    echo "6. Dann in diesem Terminal:"
    echo ""
    echo -e "${YELLOW}git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git${NC}"
    echo -e "${YELLOW}git push -u origin main${NC}"
    echo ""
    read -p "Drücke Enter wenn GitHub Repo erstellt ist..."
fi

################################################################################
# PHASE 7: RPi 5 SETUP VORBEREITEN
################################################################################

echo ""
log_info "═══════════════════════════════════════"
log_info "PHASE 7: RPi 5 Setup Commands generieren"
log_info "═══════════════════════════════════════"

# Setup-Script für RPi 5 erstellen
RPI_SETUP_FILE="$TARGET_DIR/rpi5-setup-commands.sh"

log_info "Erstelle RPi 5 Setup Commands..."
cat > "$RPI_SETUP_FILE" << EOF
#!/bin/bash
################################################################################
# Raspberry Pi 5 Setup Commands
#
# Führe diese Befehle auf dem Raspberry Pi 5 aus
# um das neue Production Repo zu clonen
################################################################################

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Raspberry Pi 5 - Klipper Config Setup                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"

# 1. Klipper & Moonraker stoppen
echo "[1/7] Stoppe Klipper & Moonraker..."
sudo systemctl stop klipper moonraker

# 2. Altes Config-Verzeichnis sichern
echo "[2/7] Sichere altes Config-Verzeichnis..."
cd ~/printer_data
if [ -d "config" ]; then
    mv config config.old-fork-backup-\$(date +%Y%m%d-%H%M%S)
fi

# 3. Neues Repo clonen
echo "[3/7] Clone Production Repo..."
git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git config

# 4. In Config-Verzeichnis wechseln
cd config

# 5. Upstream Remote hinzufügen
echo "[4/7] Füge Upstream Remote hinzu..."
git remote add upstream $UPSTREAM_URL
git fetch upstream

# 6. Remotes prüfen
echo "[5/7] Konfigurierte Remotes:"
git remote -v

# 7. MCU Serial Path prüfen (muss ggf. in printer.cfg angepasst werden)
echo "[6/7] MCU Serial Paths:"
ls -la /dev/serial/by-id/

echo ""
echo "⚠️  WICHTIG: Prüfe MCU Serial Path in printer.cfg!"
echo "   Aktuell: \$(grep 'serial:' printer.cfg | head -n1)"
echo ""
read -p "Drücke Enter um fortzufahren..."

# 8. Services neu starten
echo "[7/7] Starte Klipper & Moonraker neu..."
sudo systemctl start klipper moonraker

# Status prüfen
sleep 3
echo ""
echo "═══════════════════════════════════════"
echo "Status Check:"
echo "═══════════════════════════════════════"
systemctl status klipper --no-pager | grep Active
systemctl status moonraker --no-pager | grep Active

echo ""
echo "✅ Setup abgeschlossen!"
echo ""
echo "Nächste Schritte:"
echo "1. Öffne Mainsail UI: http://3dpi.local oder http://192.168.10.5"
echo "2. Prüfe ob Klipper 'Ready' ist"
echo "3. Falls Fehler: journalctl -u klipper -n 50"
echo ""
echo "GitHub Auto-Sync:"
echo "- Settings → Update Manager → klipper_config sollte verfügbar sein"
echo "- Push auf GitHub → Auto-Pull auf RPi 5!"
echo ""
EOF

chmod +x "$RPI_SETUP_FILE"
log_success "RPi 5 Setup Commands erstellt: $RPI_SETUP_FILE"

################################################################################
# SUMMARY
################################################################################

echo ""
echo -e "${GREEN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ✅ MIGRATION ERFOLGREICH ABGESCHLOSSEN!                   ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
log_info "═══════════════════════════════════════"
log_info "ZUSAMMENFASSUNG"
log_info "═══════════════════════════════════════"

echo ""
log_success "📁 Neues Repo erstellt:"
echo "   → $TARGET_DIR"

echo ""
log_success "📊 Git Status:"
git -C "$TARGET_DIR" log --oneline -1
git -C "$TARGET_DIR" remote -v | head -n 4

echo ""
log_success "📂 Kopierte Files:"
git -C "$TARGET_DIR" ls-files | wc -l | xargs echo "   →" "Files"

echo ""
log_info "═══════════════════════════════════════"
log_info "NÄCHSTE SCHRITTE"
log_info "═══════════════════════════════════════"

echo ""
echo "1️⃣  GitHub Repo finalisieren:"
echo "   → https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "   → Falls manuell: git push -u origin main"

echo ""
echo "2️⃣  Auf Raspberry Pi 5 ausführen:"
echo "   → ssh sv06"
echo "   → bash rpi5-setup-commands.sh"
echo "   → (oder Commands aus $RPI_SETUP_FILE kopieren)"

echo ""
echo "3️⃣  Moonraker Update Manager prüfen:"
echo "   → Mainsail UI → Settings → Update Manager"
echo "   → 'klipper_config' sollte verfügbar sein"

echo ""
echo "4️⃣  GitHub Auto-Sync testen:"
echo "   → Lokale Änderung machen"
echo "   → git push origin main"
echo "   → In Mainsail: Update Manager → klipper_config → Update"

echo ""
log_info "═══════════════════════════════════════"

echo ""
log_success "🎉 Migration abgeschlossen! Happy Printing!"
echo ""

# Optional: VS Code öffnen
read -p "Möchtest du das neue Repo in VS Code öffnen? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v code &> /dev/null; then
        log_info "Öffne VS Code..."
        code "$TARGET_DIR"
        log_success "VS Code geöffnet!"
    else
        log_warning "VS Code nicht gefunden (code command)"
    fi
fi

echo ""
log_info "Script beendet."
exit 0
