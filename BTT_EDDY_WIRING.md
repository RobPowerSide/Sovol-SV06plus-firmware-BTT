# 🔌 BTT Eddy Probe Verdrahtungs-Guide für SV06 Plus

## 📦 Was du brauchst

### Hardware
- ✅ **BTT Eddy Probe** (Version USB oder CAN)
- ✅ **USB-C Kabel** (wenn USB-Version) oder CAN-Kabel (wenn CAN-Version)
- ✅ **Montagehalterung** für SV06 Plus (zum 3D-drucken oder kaufen)
- ⚠️ **Schrauben/Muttern** (meist M3, abhängig vom Mount)

### Werkzeug
- Schraubendreher (Kreuzschlitz/Inbus)
- Kabelbinder für Kabelmanagement
- Eventuell: Lötkolben (nur wenn du Kabel kürzen/verlängern möchtest)

---

## 🎯 BTT Eddy Versionen

Es gibt **2 Hauptversionen** des BTT Eddy:

### Version 1: BTT Eddy USB
- **Anschluss**: USB-C direkt an BTT Pi / Raspberry Pi
- **Vorteile**:
  - ✅ Einfachste Installation
  - ✅ Keine zusätzliche Verkabelung nötig
  - ✅ Plug & Play
- **Nachteile**:
  - ❌ USB-Port wird belegt
  - ❌ Kabel muss zur Bewegung des Druckkopfes flexibel sein

### Version 2: BTT Eddy CAN
- **Anschluss**: CAN-Bus (erfordert CAN-fähiges Motherboard)
- **Vorteile**:
  - ✅ Weniger Kabel (CAN-Bus wird geteilt)
  - ✅ Professioneller für Multi-Device Setup
- **Nachteile**:
  - ❌ Komplexere Konfiguration
  - ❌ Benötigt CAN-Adapter/Toolhead-Board

**FÜR DICH EMPFOHLEN**: BTT Eddy **USB** - Einfacher und vollkommen ausreichend!

---

## 🔧 VERDRAHTUNG: BTT Eddy USB (Empfohlen)

### Schritt 1: Physische Montage

#### Option A: Montage am Druckkopf (Empfohlen für SV06 Plus)

**Montage-Position:**
```
   [Nozzle]
      |
   [Hotend]
      |
[Druckkopf-Carriage]
      |
  [BTT Eddy] ← hier montieren
```

**Wichtig:**
- Eddy sollte **direkt unter** oder **neben** der Nozzle sein
- Abstand zur Nozzle: Ca. 20-30mm (X/Y-Offset)
- Eddy muss beim Probing das Bett "sehen" können
- Sensing-Fläche zeigt nach unten zum Bett

**3D-Druckbare Halterungen:**
- Suche auf **Printables/Thingiverse**: "SV06 Plus BTT Eddy Mount"
- Oder: "Sovol SV06 Eddy Probe Bracket"

#### Beispiel-Geometrie für Offset (musst du messen!):
```
Draufsicht:
        Y
        ↑
        |
    [Nozzle] ← (0, 0) = Referenzpunkt
        |
   X ← + → X
        |
    [Eddy] ← ca. (+27mm, -20mm) vom Nozzle
        |
        ↓
```

### Schritt 2: USB-Verkabelung

#### Kabel-Route planen:

```
BTT Eddy (am Druckkopf)
    ↓
USB-C Kabel (flexibel!)
    ↓
Entlang der X-Gantry
    ↓
Kabel-Chain / Kabelspirale
    ↓
BTT Pi 1.2 USB-Port
```

**Wichtige Punkte:**

1. **Kabel-Länge**:
   - Min. 1.5m empfohlen (für volle X-Bewegung)
   - Mit Zugentlastung an beiden Enden

2. **Kabel-Routing**:
   - Folge dem Weg der bestehenden Kabel (Hotend/Lüfter)
   - Nutze Kabelbinder/Cable-Chain
   - Vermeide scharfe Knicke
   - Kabel darf **nicht** hängen bleiben!

3. **Zugentlastung**:
   - Am Eddy: Schraub-Klemme oder Kabelbinder
   - Am BTT Pi: Kabelbinder am Gehäuse

#### BTT Pi 1.2 USB-Anschlüsse:

```
BTT Pi 1.2 (Ansicht von oben):

[Ethernet] [HDMI] [USB-A] [USB-A] [USB-C Power]
                     ↑       ↑
                   Port 1  Port 2  ← Hier anschließen!
```

**Anschluss:**
- Nutze **USB-A Port** (nicht USB-C Power!)
- Port 1 oder 2 ist egal
- Falls beide belegt → USB-Hub verwenden

### Schritt 3: Elektrische Verbindung

#### Standard-Verkabelung (USB):

```
BTT Eddy Pinout (USB-Version):
┌─────────────────┐
│   BTT Eddy      │
│                 │
│  [USB-C Port]   │ ← Stecke USB-C Kabel hier ein
│                 │
│  [Sensor Chip]  │
│                 │
└─────────────────┘
```

**Das war's!** Bei USB-Version ist keine weitere Verkabelung nötig.

#### Optional: Externe Stromversorgung (nur wenn instabil)

Manche User berichten, dass der Eddy über USB nicht genug Strom bekommt.

**Symptome:**
- Eddy wird nicht erkannt
- Inkonsistente Messwerte
- Verbindungsabbrüche

**Lösung**: Externe 5V Versorgung
```
BTT Eddy hat zusätzliche Pins:
[GND] [5V] [I2C-SDA] [I2C-SCL]

Option 1: Von 5V Pin am Motherboard
Option 2: Vom BTT Pi GPIO (Pin 2 = 5V, Pin 6 = GND)
```

**⚠️ WICHTIG**: Nur nötig falls Probleme auftreten!

---

## 🔧 VERDRAHTUNG: BTT Eddy CAN (Fortgeschritten)

Falls du dich für CAN entscheidest (z.B. mit Toolhead-Board):

### Voraussetzungen:
- CAN-fähiges Toolhead-Board (z.B. BTT EBB36/42)
- CAN-Bus bereits konfiguriert
- CAN-Kabel (4-adrig: CAN-H, CAN-L, 24V, GND)

### Verkabelung:
```
BTT Eddy CAN
    ↓
CAN-Kabel (4-adrig)
    ↓
Toolhead Board (z.B. EBB36)
    ↓
CAN-Bus zum Motherboard
```

**Für SV06 Plus NICHT empfohlen** - zu komplex für wenig Vorteil!

---

## 📏 X/Y-Offset ermitteln & konfigurieren

Nach der Montage musst du den **exakten Offset** messen:

### Methode 1: Manuelles Messen (Einfach)

1. **Nozzle zentrieren** über einer markierten Position
2. **Eddy-Position** messen relativ zur Nozzle
3. **In Config eintragen**

**Beispiel:**
```
Nozzle bei: X=150, Y=150
Eddy bei:   X=177, Y=130

Offset = (177-150, 130-150) = (+27, -20)
```

In [btt-eddy.cfg](cfgs/btt-eddy.cfg):
```python
[probe_eddy_current btt_eddy]
x_offset: 27.0   # Eddy ist 27mm rechts von Nozzle
y_offset: -20.0  # Eddy ist 20mm vor Nozzle
```

### Methode 2: Automatisch mit Klipper

```gcode
# Nozzle positionieren
G28
G1 X150 Y150 Z10

# Position merken
M114

# Eddy aktivieren, zum Messpunkt fahren
# ... Eddy-Position ablesen
# Differenz = Offset
```

---

## 🧪 ERSTE TESTS nach Installation

### 1. USB-Erkennung prüfen

SSH ins BTT Pi:
```bash
ssh biqu@dein-drucker-ip

# USB-Geräte auflisten
ls /dev/serial/by-id/

# Erwartete Ausgabe:
# usb-Klipper_rp2040_XXXXXXXXXXXXX-if00  ← Das ist dein Eddy!
```

**Kopiere diese ID** und trage sie in [btt-eddy.cfg](cfgs/btt-eddy.cfg) ein!

### 2. Klipper Config aktualisieren

```bash
nano ~/printer_data/config/cfgs/btt-eddy.cfg

# Finde Zeile ~26:
# [mcu eddy]
# serial: /dev/serial/by-id/DEINE_ID_HIER
```

Ersetze `DEINE_ID_HIER` mit der kopierten USB-ID.

### 3. Firmware-Restart

In Klipper-Konsole:
```gcode
FIRMWARE_RESTART
```

Prüfe auf Fehler im Log!

### 4. Eddy Test

```gcode
# Query Eddy Status
QUERY_PROBE

# Erwartete Ausgabe:
# probe: OPEN (wenn Nozzle hoch)
# probe: TRIGGERED (wenn Nozzle auf Bett)

# Manuelle Probe
G28
G1 X150 Y150 Z10
PROBE

# Sollte Z-Position ausgeben
```

### 5. Z-Offset kalibrieren

```gcode
G28
PROBE_CALIBRATE

# Papier-Test:
# - Senke Z bis Papier leicht klemmt
# - ACCEPT
# - SAVE_CONFIG
```

### 6. Bed Mesh Test

```gcode
G28
BED_MESH_CALIBRATE

# Bei 9×9 Mesh mit Eddy:
# Erwartet: ~60 Sekunden (sehr schnell!)
```

---

## 🎨 Kabel-Management Tipps

### Option 1: Bestehende Cable-Chain nutzen
```
[Druckkopf]
     ↓
[Bestehende Kabel: Hotend, Lüfter, etc.]
     ↓
[+ BTT Eddy USB-Kabel dazu] ← Mit Kabelbinder befestigen
     ↓
[Cable-Chain / Spiralkabel]
     ↓
[BTT Pi]
```

### Option 2: Separates Kabel-Routing
- Falls Cable-Chain voll ist
- Spiralkabel parallel führen
- Wichtig: Bewegungsfreiheit der X-Achse testen!

### Option 3: 3D-gedruckte Kabelhalter
- Suche: "Cable clip SV06"
- Entlang der X-Gantry montieren
- Kabel wird geführt, nicht eingeklemmt

---

## ⚠️ HÄUFIGE FEHLER & LÖSUNGEN

### Problem 1: Eddy wird nicht erkannt
```bash
# Prüfe USB-Verbindung
lsusb

# Sollte zeigen:
# Bus 001 Device XXX: ID 2e8a:0003 Raspberry Pi RP2040
```

**Lösungen:**
- Anderes USB-Kabel probieren
- Anderen USB-Port probieren
- USB-Hub verwenden (mit eigener Stromversorgung)
- Eddy-Firmware flashen (siehe BTT-Anleitung)

### Problem 2: Inkonsistente Messwerte

**Symptome:**
- Bed Mesh hat große Schwankungen
- Wiederholte Probes unterscheiden sich >0.05mm

**Lösungen:**
1. **Bett aufheizen** (Eddy ist temperaturabhängig!)
   ```gcode
   M190 S60
   G28
   BED_MESH_CALIBRATE
   ```

2. **Probe-Geschwindigkeit reduzieren**
   ```python
   # In btt-eddy.cfg:
   speed: 5.0  # Statt 10.0
   ```

3. **Samples erhöhen**
   ```python
   samples: 5  # Statt 3
   samples_tolerance: 0.01  # Statt 0.005
   ```

### Problem 3: "Probe triggered prior to movement"

**Ursache:** Eddy zu nah am Bett beim Homing

**Lösung:**
```python
# In btt-eddy.cfg:
horizontal_move_z: 5  # Statt 2
```

Oder in [safe_z_home]:
```python
z_hop: 10  # Höher heben beim Homing
```

### Problem 4: Z-Offset driftet

**Ursache:** Temperatur-Expansion

**Lösung:** Temperatur-Kompensation aktivieren
```python
# In btt-eddy.cfg auskommentieren:
[temperature_probe btt_eddy]
sensor_type: temperature_mcu
sensor_mcu: eddy
min_temp: 10
max_temp: 100
```

---

## 📊 Erwartete Performance mit BTT Eddy

### Bed Mesh Geschwindigkeit

| Mesh-Größe | Alte Probe (BLTouch) | BTT Eddy | Verbesserung |
|------------|---------------------|----------|--------------|
| 5×5 (25 Punkte) | ~90 Sek | ~20 Sek | **4.5×** schneller |
| 7×7 (49 Punkte) | ~180 Sek | ~40 Sek | **4.5×** schneller |
| 9×9 (81 Punkte) | ~300 Sek | ~60 Sek | **5×** schneller |

### Genauigkeit

| Metrik | BLTouch/Induktiv | BTT Eddy |
|--------|------------------|----------|
| Wiederholbarkeit | ±0.01-0.02mm | ±0.005mm |
| Auflösung | ~0.01mm | ~0.001mm |
| Temperatur-Drift | Hoch | Niedrig (mit Komp.) |

### Zuverlässigkeit

**Vorteile Eddy:**
- ✅ Keine mechanischen Teile (kein Verschleiß)
- ✅ Kein Pin der verbiegen kann
- ✅ Funktioniert auf allen Oberflächen (Glas, PEI, Magnets, etc.)
- ✅ Sehr schnell = weniger Wartezeit

**Nachteile:**
- ❌ Etwas teurer als BLTouch
- ❌ Temperaturabhängig (aber kompensierbar)
- ❌ Erfordert USB-Port

---

## 🎯 Checkliste: Installation Abgeschlossen?

- [ ] BTT Eddy physisch montiert
- [ ] USB-Kabel verbunden (mit Zugentlastung)
- [ ] Kabel-Management organisiert
- [ ] USB-ID ermittelt (`ls /dev/serial/by-id/`)
- [ ] [btt-eddy.cfg](cfgs/btt-eddy.cfg) aktualisiert (Serial-ID)
- [ ] [btt-eddy.cfg](cfgs/btt-eddy.cfg) in [osskc.cfg](osskc.cfg) inkludiert
- [ ] Alte `[probe]` in [printer.cfg](printer.cfg) auskommentiert
- [ ] Alte `[bed_mesh]` in [printer.cfg](printer.cfg) auskommentiert
- [ ] `FIRMWARE_RESTART` durchgeführt
- [ ] `QUERY_PROBE` erfolgreich getestet
- [ ] X/Y-Offset gemessen und eingetragen
- [ ] `PROBE_CALIBRATE` durchgeführt (Z-Offset)
- [ ] `BED_MESH_CALIBRATE` erfolgreich getestet
- [ ] Mesh-Qualität überprüft (konsistente Werte)

**Wenn alle ✅ → BTT Eddy ist einsatzbereit! 🎉**

---

## 📚 Zusätzliche Ressourcen

- **BTT Eddy Manual**: [GitHub - BTT/Eddy](https://github.com/bigtreetech/Eddy)
- **Klipper Eddy Docs**: [Klipper Probe Eddy Current](https://www.klipper3d.org/Config_Reference.html#probe_eddy_current)
- **Video-Anleitungen**: YouTube "BTT Eddy installation"
- **Community**: Klipper Discord #probes Channel

---

**Viel Erfolg mit deinem BTT Eddy! 🚀**
