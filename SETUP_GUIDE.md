# 🚀 SV06 Plus Optimierungs-Guide mit BTT Eddy & KAMP

## Hardware Setup
- **Drucker**: Sovol SV06 Plus
- **Board**: BigTreeTech Pi 1.2
- **Display**: HDMI Screen
- **Probe**: BTT Eddy (Wirbelstrom-Sensor)
- **Slicer**: PrusaSlicer

---

## ✅ SETUP CHECKLIST

### Phase 0: BTT Eddy Installation

#### 1. Hardware-Verbindung
```bash
# SSH in dein BTT Pi
ssh biqu@your-printer-ip

# Finde den Eddy Probe
ls /dev/serial/by-id/

# Sollte sowas anzeigen wie:
# usb-Klipper_rp2040_xxxxxxxxxxxxx-if00
```

#### 2. Config-Dateien aktualisieren

**A) BTT Eddy Config bearbeiten:**
```bash
# Öffne die neue btt-eddy.cfg
nano ~/printer_data/config/cfgs/btt-eddy.cfg

# Aktualisiere die Zeile (ca. Zeile 26-27):
# [mcu eddy]
# serial: /dev/serial/by-id/usb-Klipper_rp2040_DEINE_ID_HIER
```

**B) Alte Probe auskommentieren:**
```bash
nano ~/printer_data/config/printer.cfg

# Finde [probe] Section (ca. Zeile 142-150)
# Kommentiere ALLE Zeilen aus mit #:
# [probe]
# pin: PB1
# x_offset: 27
# ...
```

**C) Neue Configs inkludieren:**
```bash
nano ~/printer_data/config/osskc.cfg

# Füge am Ende hinzu:
[include ./cfgs/btt-eddy.cfg]
[include ./cfgs/flow-test.cfg]
```

**D) Bed Mesh Section auskommentieren:**
```bash
nano ~/printer_data/config/printer.cfg

# Finde [bed_mesh] Section (ca. Zeile 158-166)
# Kommentiere sie GANZ aus (# vor jede Zeile)
# Die neue [bed_mesh] ist jetzt in btt-eddy.cfg!
```

#### 3. Klipper neu starten
```gcode
FIRMWARE_RESTART
```

#### 4. BTT Eddy kalibrieren
```gcode
# Home
G28

# Z-Offset kalibrieren (Paper-Test)
PROBE_CALIBRATE
# Verwende Papier-Methode, dann:
ACCEPT
SAVE_CONFIG

# Test
G28
BED_MESH_CALIBRATE
# Sollte VIEL schneller sein als vorher!
```

---

### Phase 1: Mechanische Basis-Kalibrierung

**Reihenfolge ist wichtig!**

#### Schritt 1: Mechanical Gantry Calibration
```gcode
# VORSICHT: Drucker beobachten!
# Zuerst mit niedrigem Current testen:
MECHANICAL_GANTRY_CALIBRATION CURRENT=0.15

# Wenn erfolgreich, Standard verwenden:
MECHANICAL_GANTRY_CALIBRATION

# Alternative: Alias verwenden
G34
```

**Was passiert:**
- Gantry fährt nach oben
- Stepper stallen gegen mechanische Endstops
- Frame-Level wird auf Gantry übertragen

**Erwartung:**
- Leichtes Schleifgeräusch für ~10 Sekunden
- 3× Beeps = Erfolgreich

#### Schritt 2: Screws Tilt Adjust
```gcode
# Bett-Schrauben justieren
SCREWS_TILT_ADJUST

# Folge den Anweisungen im Terminal:
# - Welche Schraube drehen
# - In welche Richtung (CW/CCW)
# - Wie viele "Minuten" (wie Uhr)

# Wiederholen bis Ausgabe sagt: "Bed level"
```

#### Schritt 3: Z-Tilt via Probe
```gcode
# Feinabstimmung der Gantry mit Probe
Z_TILT_VIA_PROBE

# Folge Anweisungen
# Wiederhole bis: "Your gantry is level"
```

#### Schritt 4: Axis Twist Compensation
```gcode
# X-Achsen Verdrehung messen und kompensieren
G28
AXIS_TWIST_COMPENSATION_CALIBRATE

# Dauert ca. 5 Minuten
# Danach:
SAVE_CONFIG
```

---

### Phase 2: KAMP Aktivierung & PrusaSlicer Setup

#### Schritt 1: KAMP aktivieren
```bash
nano ~/printer_data/config/cfgs/misc-macros.cfg

# Finde Zeile 36:
variable_kamp_enable: 0

# Ändere zu:
variable_kamp_enable: 1

# Speichern: Ctrl+O, Enter, Ctrl+X
```

#### Schritt 2: Optional - Smart Park aktivieren
```bash
nano ~/printer_data/config/cfgs/kamp/KAMP_Settings.cfg

# Zeile 7 - Entferne das # :
[include ./Smart_Park.cfg]
```

#### Schritt 3: Klipper neu starten
```gcode
FIRMWARE_RESTART
```

#### Schritt 4: PrusaSlicer konfigurieren

**A) Label Objects aktivieren:**
1. PrusaSlicer öffnen
2. `Print Settings` > `Output options`
3. Aktiviere: ☑️ `Label objects`

**B) Start G-Code anpassen:**
1. `Printer Settings` > `Custom G-code` > `Start G-code`
2. Ersetze mit folgendem Code:

```gcode
; PrusaSlicer Start G-Code mit KAMP
M104 S0
M140 S0
PRINT_START BED=[first_layer_bed_temperature] HOTEND=[first_layer_temperature]
LINE_PURGE
M117 Printing...
```

**C) End G-Code:**
```gcode
; PrusaSlicer End G-Code
PRINT_END
M117 Print Complete!
```

---

### Phase 3: Volumetric Flow Rate ermitteln

#### Vorbereitung
```gcode
# Hotend aufheizen (PLA-Beispiel)
M109 S215
```

#### Methode 1: Automatischer Test
```gcode
# Automatischer Flow-Test
FLOW_TEST TEMP=215

# Beobachte den Extruder!
# Bei welcher Geschwindigkeit fängt er an zu skippen?
# Notiere die letzte erfolgreiche mm³/s Ausgabe
```

#### Methode 2: Manueller Test
```gcode
# Teste einzelne Geschwindigkeiten
MEASURE_FLOW_RATE TEMP=215 SPEED=10
# Kein Skippen? Erhöhe:
MEASURE_FLOW_RATE TEMP=215 SPEED=12
MEASURE_FLOW_RATE TEMP=215 SPEED=15
# Skippen? Gehe einen Schritt zurück
```

#### Ergebnis auswerten

**Beispiel:**
- Letzter erfolgreicher Test: 12 mm³/s
- **Maximum = 12 mm³/s**
- **Sicherer Wert = 12 × 0.8 = 9.6 mm³/s**

#### PrusaSlicer einstellen
1. `Print Settings` > `Advanced`
2. `Max volumetric speed` = **9.6** (dein Wert!)
3. Speichern

**Was bringt das?**
- PrusaSlicer limitiert automatisch ALLE Geschwindigkeiten
- Verhindert Unterextrusion
- Keine manuellen Speed-Anpassungen mehr nötig!

---

### Phase 4: Weitere Optimierungen

#### 1. PID Tuning (für jedes Material)

**Bed PID:**
```gcode
# Für PLA
PID_TEST_BED TEMP=60

# Für PETG
PID_TEST_BED TEMP=80

# Für ABS
PID_TEST_BED TEMP=100
```

**Hotend PID:**
```gcode
# Für PLA
PID_TEST_HOTEND TEMP=215

# Für PETG
PID_TEST_HOTEND TEMP=245

# Für ABS
PID_TEST_HOTEND TEMP=255
```

Nach jedem Test: `SAVE_CONFIG`

#### 2. Pressure Advance Kalibrierung

**Test-Objekt drucken:**
1. Download: [Klipper Pressure Advance Test](https://www.klipper3d.org/Pressure_Advance.html)
2. Drucke mit verschiedenen PA-Werten
3. Finde optimalen Wert (typisch 0.02-0.08)

**Einstellen:**
```bash
nano ~/printer_data/config/printer.cfg

# In [extruder] Section hinzufügen:
pressure_advance: 0.050  # Dein ermittelter Wert
```

#### 3. Input Shaper (falls ADXL vorhanden)

Siehe separate Anleitung in den ADXL-Config-Files.

#### 4. Geschwindigkeit optimieren

```gcode
# Test mit aktuellen Settings
TEST_SPEED

# Test mit höheren Werten
TEST_SPEED SPEED=250 ACCEL=5000 ITERATIONS=10
TEST_SPEED SPEED=300 ACCEL=6000 ITERATIONS=10

# Bei Steps-Lost: Reduzieren
```

**Empfohlene Werte (nach Input Shaper):**
```python
# In printer.cfg:
max_velocity: 250
max_accel: 5000
square_corner_velocity: 6
```

---

## 🎯 ERWARTETE VERBESSERUNGEN

### Bed Mesh mit BTT Eddy
- **Vorher**: ~3-4 Minuten (7×7 @ 175mm/s)
- **Nachher**: ~1 Minute (9×9 @ 250mm/s)
- **Verbesserung**: 3-4× schneller + höhere Auflösung!

### KAMP Adaptive Meshing
- **Vorher**: Ganzes Bett gemesht
- **Nachher**: Nur Druckbereich
- **Zeit gespart**: 50-80% (abhängig von Objektgröße)

### Volumetric Speed Limit
- **Vorher**: Manuelle Speed-Anpassung, Unterextrusion-Risiko
- **Nachher**: Automatische Begrenzung, perfekter Flow
- **Qualität**: Deutlich besser, konsistenter

### Gesamte Start-Zeit
- **Vorher**: ~8-10 Minuten (Heat + Full Mesh + Purge)
- **Nachher**: ~3-5 Minuten (Heat + Adaptive Mesh + Purge)
- **Ersparnis**: ~5 Minuten pro Druck!

---

## 📋 WARTUNGS-ROUTINE

### Täglich/Pro Druck
- [ ] Visual Check: Bett sauber, Nozzle frei

### Wöchentlich
- [ ] `SCREWS_TILT_ADJUST` falls Bed-Level abweicht
- [ ] `Z_TILT_VIA_PROBE` Kontrolle

### Monatlich
- [ ] `MECHANICAL_GANTRY_CALIBRATION`
- [ ] `AXIS_TWIST_COMPENSATION_CALIBRATE`
- [ ] Bed Mesh neu erstellen
- [ ] V-Roller prüfen/justieren

### Vierteljährlich
- [ ] PID Tuning wiederholen
- [ ] Pressure Advance prüfen
- [ ] Input Shaper neu kalibrieren (falls ADXL vorhanden)

---

## 🆘 TROUBLESHOOTING

### BTT Eddy wird nicht erkannt
```bash
# Prüfe USB-Verbindung
ls /dev/serial/by-id/

# Keine Ausgabe? USB-Kabel prüfen, anderen Port probieren

# Klipper-Log prüfen
tail -f ~/printer_data/logs/klippy.log
```

### KAMP funktioniert nicht
```bash
# Prüfe ob [exclude_object] aktiviert ist
cat ~/printer_data/config/cfgs/misc-macros.cfg | grep exclude_object

# Prüfe PrusaSlicer "Label Objects" aktiviert
# Öffne G-Code File, sollte EXCLUDE_OBJECT_DEFINE enthalten
```

### Flow-Test: Extruder skippt sofort
- Temperatur zu niedrig → erhöhen
- Nozzle verstopft → reinigen
- Filament zu alt/feucht → trocknen

### Mechanical Gantry Cal schlägt fehl
- Current zu niedrig → erhöhen (max 0.30)
- Current zu hoch → reduzieren
- Mechanische Blockade → Hardware prüfen

---

## 📚 NÜTZLICHE LINKS

- [Klipper Docs](https://www.klipper3d.org/)
- [BTT Eddy Manual](https://github.com/bigtreetech/Eddy)
- [KAMP GitHub](https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging)
- [Ellis Print Tuning Guide](https://ellis3dp.com/Print-Tuning-Guide/)

---

**Viel Erfolg bei der Optimierung! 🚀**
