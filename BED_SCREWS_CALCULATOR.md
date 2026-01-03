# 📐 Bed Screw Position Calculator - SV06 Plus

## 🎯 Problem gelöst!

Dieses Dokument erklärt wie die Bed-Screw-Positionen berechnet werden, basierend auf **einer einzigen Quelle**: Den Stepper-Limits in `printer.cfg`!

---

## 📊 EINGABE-WERTE (Aus printer.cfg)

```python
# Aus [stepper_x]
X_MAX = 304mm  # position_max

# Aus [stepper_y]
Y_MAX = 300mm  # position_max

# Aus [probe]
PROBE_X_OFFSET = 27mm   # x_offset
PROBE_Y_OFFSET = -20mm  # y_offset (negativ = Probe ist VOR der Nozzle)
```

---

## 🧮 BERECHNUNGSFORMELN

### Konstanten (können angepasst werden):

```python
FRONT_Y = 35           # Abstand vom vorderen Rand
BACK_MARGIN = 5        # Abstand vom hinteren Rand
LEFT_X_MANUAL = 32     # Links-Position für manuelle Kalibrierung
LEFT_X_PROBE = 5       # Links-Position für Probe-Kalibrierung
RIGHT_MARGIN = 4       # Abstand vom rechten Rand
CENTER_LEFT_RATIO = 0.36   # Center-links als Anteil der Breite
CENTER_RIGHT_RATIO = 0.73  # Center-rechts als Anteil der Breite
CENTER_Y_FRONT = 136   # Y für vordere Center-Schrauben
CENTER_Y_BACK = 216    # Y für hintere Center-Schrauben
```

---

## 📍 BED_SCREWS (Manuelle Kalibrierung - Nozzle-Positionen)

**Verwendung:** Klipper-Menü "Adjust Bed Screws" (mit Papier)

| Schraube | X-Berechnung | Y-Berechnung | Beispiel (304×300) |
|----------|--------------|--------------|-------------------|
| **front left** | `LEFT_X_MANUAL` | `FRONT_Y` | `32, 35` |
| **front right** | `X_MAX - RIGHT_MARGIN` | `FRONT_Y` | `300, 35` |
| **center front left** | `X_MAX × CENTER_LEFT_RATIO` | `CENTER_Y_FRONT` | `109, 136` |
| **center front right** | `X_MAX × CENTER_RIGHT_RATIO` | `CENTER_Y_FRONT` | `222, 136` |
| **center back left** | `X_MAX × CENTER_LEFT_RATIO` | `CENTER_Y_BACK` | `109, 216` |
| **center back right** | `X_MAX × CENTER_RIGHT_RATIO` | `CENTER_Y_BACK` | `222, 216` |
| **back left** | `LEFT_X_MANUAL` | `Y_MAX - BACK_MARGIN` | `32, 295` |
| **back right** | `X_MAX - RIGHT_MARGIN` | `Y_MAX - BACK_MARGIN` | `300, 295` |

---

## 📍 SCREWS_TILT_ADJUST (Automatisch - Mit Probe)

**Verwendung:** `SCREWS_TILT_ADJUST` Befehl

**Wichtig:** Die Positionen sind **Nozzle-Positionen**. Probe misst bei `(X + PROBE_X_OFFSET, Y + PROBE_Y_OFFSET)`

| Schraube | X-Berechnung | Y-Berechnung | Beispiel (304×300) |
|----------|--------------|--------------|-------------------|
| **front left** | `LEFT_X_PROBE` | `FRONT_Y` | `5, 35` |
| **front right** | `X_MAX - PROBE_X_OFFSET - RIGHT_MARGIN` | `FRONT_Y` | `273, 35` |
| **center front left** | `X_MAX × 0.28` | `CENTER_Y_FRONT` | `85, 136` |
| **center front right** | `(Front_Right_X - Center_Left_X) + 84` | `CENTER_Y_FRONT` | `272, 136` |
| **center back left** | `X_MAX × 0.28` | `CENTER_Y_BACK` | `85, 216` |
| **center back right** | `(Front_Right_X - Center_Left_X) + 84` | `CENTER_Y_BACK` | `272, 216` |
| **back left** | `LEFT_X_PROBE` | `Y_MAX - BACK_MARGIN` | `5, 295` |
| **back right** | `X_MAX - PROBE_X_OFFSET - RIGHT_MARGIN` | `Y_MAX - BACK_MARGIN` | `273, 295` |

---

## 🔧 VERWENDUNG

### Option 1: Makro nutzen (Empfohlen)

1. **Include in osskc.cfg:**
   ```python
   [include ./cfgs/dynamic-bed-screws.cfg]
   ```

2. **FIRMWARE_RESTART**

3. **Calculator ausführen:**
   ```gcode
   CALCULATE_SCREW_POSITIONS
   ```

4. **Ausgabe kopieren** und in `printer.cfg` einfügen

---

### Option 2: Manuell berechnen (Wenn Werte ändern)

**Beispiel:** Du änderst `position_max` von 304 auf 310:

1. Öffne diese Datei
2. Ersetze `X_MAX = 304` mit `X_MAX = 310` in allen Formeln
3. Berechne neu:
   ```
   front right: 310 - 4 = 306
   center left: 310 × 0.36 = 111.6 → 112
   center right: 310 × 0.73 = 226.3 → 226
   ...
   ```
4. Update `printer.cfg`

---

### Option 3: Python-Script (Für Nerds 🤓)

```python
#!/usr/bin/env python3

# Bed dimensions
X_MAX = 304
Y_MAX = 300
PROBE_X_OFFSET = 27
PROBE_Y_OFFSET = -20

# Constants
FRONT_Y = 35
BACK_MARGIN = 5
LEFT_X_MANUAL = 32
LEFT_X_PROBE = 5
RIGHT_MARGIN = 4
CENTER_LEFT_RATIO = 0.36
CENTER_RIGHT_RATIO = 0.73
CENTER_Y_FRONT = 136
CENTER_Y_BACK = 216

print("=== BED_SCREWS (Manual) ===")
print(f"screw1 (FL): {LEFT_X_MANUAL}, {FRONT_Y}")
print(f"screw2 (FR): {X_MAX - RIGHT_MARGIN}, {FRONT_Y}")
print(f"screw3 (CFL): {int(X_MAX * CENTER_LEFT_RATIO)}, {CENTER_Y_FRONT}")
print(f"screw4 (CFR): {int(X_MAX * CENTER_RIGHT_RATIO)}, {CENTER_Y_FRONT}")
print(f"screw5 (CBL): {int(X_MAX * CENTER_LEFT_RATIO)}, {CENTER_Y_BACK}")
print(f"screw6 (CBR): {int(X_MAX * CENTER_RIGHT_RATIO)}, {CENTER_Y_BACK}")
print(f"screw7 (BL): {LEFT_X_MANUAL}, {Y_MAX - BACK_MARGIN}")
print(f"screw8 (BR): {X_MAX - RIGHT_MARGIN}, {Y_MAX - BACK_MARGIN}")

print("\n=== SCREWS_TILT_ADJUST (Probe) ===")
fr_x = X_MAX - PROBE_X_OFFSET - RIGHT_MARGIN
cl_x = int(X_MAX * 0.28)
cr_x = fr_x - cl_x + 84
print(f"screw1 (FL): {LEFT_X_PROBE}, {FRONT_Y}")
print(f"screw2 (FR): {fr_x}, {FRONT_Y}")
print(f"screw3 (CFL): {cl_x}, {CENTER_Y_FRONT}")
print(f"screw4 (CFR): {cr_x}, {CENTER_Y_FRONT}")
print(f"screw5 (CBL): {cl_x}, {CENTER_Y_BACK}")
print(f"screw6 (CBR): {cr_x}, {CENTER_Y_BACK}")
print(f"screw7 (BL): {LEFT_X_PROBE}, {Y_MAX - BACK_MARGIN}")
print(f"screw8 (BR): {fr_x}, {Y_MAX - BACK_MARGIN}")
```

**Ausführen:**
```bash
python3 bed_screw_calculator.py
```

---

## 📋 QUICK REFERENCE - Aktuelle Werte (304×300mm Bett)

### [bed_screws] - Kopieren für printer.cfg:

```ini
[bed_screws]
screw1_name: front left
screw1: 32, 35
screw2_name: front right
screw2: 300, 35
screw3_name: center front left
screw3: 109, 136
screw4_name: center front right
screw4: 222, 136
screw5_name: center back left
screw5: 109, 216
screw6_name: center back right
screw6: 222, 216
screw7_name: back left
screw7: 32, 295
screw8_name: back right
screw8: 300, 295
horizontal_move_z: 10
speed: 175
```

### [screws_tilt_adjust] - Kopieren für printer.cfg:

```ini
[screws_tilt_adjust]
screw1_name: front left
screw1: 5, 35
screw2_name: front right
screw2: 273, 35
screw3_name: center front left
screw3: 85, 136
screw4_name: center front right
screw4: 273, 136
screw5_name: center back left
screw5: 85, 216
screw6_name: center back right
screw6: 273, 216
screw7_name: back left
screw7: 5, 295
screw8_name: back right
screw8: 273, 295
horizontal_move_z: 10
screw_thread: CCW-M4
speed: 175
```

---

## 🎯 ZUSAMMENFASSUNG

**Einzige Änderungen nötig wenn:**
- ✅ Bed-Größe ändert (`position_max`)
- ✅ Probe-Offset ändert (`x_offset/y_offset`)
- ✅ Andere Schrauben-Layout

**Dann:**
1. Update Werte oben in diesem Dokument
2. Führe `CALCULATE_SCREW_POSITIONS` aus
3. Kopiere neue Werte in `printer.cfg`
4. `FIRMWARE_RESTART`

**EINE QUELLE → Alles passt automatisch!** ✅

---

Erstellt: 2026-01-02
Für: Sovol SV06 Plus mit BTT Pi 1.2
