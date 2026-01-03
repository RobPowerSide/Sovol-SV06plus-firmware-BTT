# 🔥 Nozzle-Guide: CHT vs Standard vs Hardened Steel

## 🎯 Was ist eine CHT Nozzle?

**CHT** = **C**ore **H**eating **T**echnology (auch: **C**onvection **H**eat **T**ransfer)

### Erfinder & Patent
- Entwickelt von **Bondtech** (Schweden)
- Patent: "Multi-Cavity Nozzle Design"
- Lizenziert an diverse Hersteller (Slice Engineering, E3D, etc.)

---

## 🔬 Wie funktioniert eine CHT Nozzle?

### Standard-Nozzle (z.B. deine Stahl-Nozzle)

```
Filament-Pfad:

[Filament] ──────────► [Engstelle] ──────────► [Nozzle-Öffnung]
                           ↓
                    Heizt nur außen

Problem: Filament wird nur von außen erhitzt!
→ Limitierter Wärmeübergang
→ Niedrigere max. Volumetric Speed
```

**Heizzone**: Nur die **Oberfläche** des Filaments wird erhitzt

**Max. Flow**: ~10-15 mm³/s (bei PLA mit 0.4mm Nozzle)

---

### CHT Nozzle (Core Heating Technology)

```
Filament-Pfad mit 3 Kanälen:

[Filament] ────┬───► Kanal 1 ┐
               ├───► Kanal 2 ├──► Zusammenführung ──► [Nozzle-Öffnung]
               └───► Kanal 3 ┘
                      ↓ ↓ ↓
                  Heizt INNEN + außen

Vorteil: Filament wird in 3 Teile gesplittet → mehr Oberfläche!
→ Besserer Wärmeübergang
→ HÖHERE max. Volumetric Speed
```

**Heizzone**: Filament wird **3-fach gesplittet** → 3× mehr Heizoberfläche!

**Max. Flow**: ~18-25 mm³/s (bei PLA mit 0.4mm Nozzle)

**Verbesserung**: **+50-80% höherer Flow!** 🚀

---

## 📊 PERFORMANCE-VERGLEICH

### Volumetric Speed Vergleich (PLA, 215°C, 0.4mm Nozzle)

| Nozzle-Typ | Standard Brass | Hardened Steel | CHT Brass | CHT Steel |
|------------|----------------|----------------|-----------|-----------|
| **Max. Flow** | 12 mm³/s | 10 mm³/s | 20 mm³/s | 18 mm³/s |
| **Verbesserung** | Baseline | -15% | **+67%** | **+50%** |

### Was bedeutet das in der Praxis?

**Beispiel: 0.2mm Layer, 0.4mm Line Width**

| Flow | Speed mit Standard | Speed mit CHT | Zeitersparnis |
|------|-------------------|---------------|---------------|
| 12 mm³/s | 150 mm/s | 250 mm/s | **+67% schneller!** |
| 20 mm³/s | Nicht möglich | 250 mm/s | - |

**Bei 4h Druck → mit CHT: ~2.4h** 🎉

---

## 🔍 CHT Nozzle Varianten

### 1. CHT Brass (Messing) - Empfohlen für dich!

**Vorteile:**
- ✅ Beste Wärmeleitung
- ✅ Höchster Flow
- ✅ Günstig (~€15-25)

**Nachteile:**
- ❌ Verschleiß bei abrasiven Filamenten
- ❌ Nicht für Carbon-Fiber, Glow-in-Dark, etc.

**Für:**
- PLA, PETG, ABS, TPU (Standard-Filamente)

### 2. CHT Hardened Steel (gehärteter Stahl)

**Vorteile:**
- ✅ Sehr robust
- ✅ Für abrasive Filamente (CF, GF, Glow, Wood)
- ✅ Langlebig

**Nachteile:**
- ❌ ~15% weniger Flow als CHT Brass
- ❌ Teurer (~€25-35)

**Für:**
- Carbon-Fiber, Glow-in-Dark, Holz-Filamente

### 3. CHT Plated Copper (verkupfert)

**Vorteile:**
- ✅ Beste Wärmeleitung aller Nozzles
- ✅ Höchster Flow (~25 mm³/s)
- ✅ Non-stick Beschichtung

**Nachteile:**
- ❌ Teuer (~€30-45)
- ❌ Beschichtung kann abnutzen

**Für:**
- Extreme Speed-Drucke

---

## 🆚 DEINE AKTUELLEN NOZZLES vs CHT

### Du hast: Hardened Steel 0.4mm & 0.6mm

**Deine Stahl-Nozzles (0.4mm):**
- Max. Flow: ~10 mm³/s
- Max. Speed (0.2mm Layer): ~125 mm/s
- Für: Abrasive Filamente ✅

**Mit CHT Brass 0.4mm:**
- Max. Flow: ~20 mm³/s (+100%!)
- Max. Speed (0.2mm Layer): ~250 mm/s (+100%!)
- Für: Standard-Filamente (PLA, PETG, ABS)

**Deine Stahl-Nozzle 0.6mm:**
- Max. Flow: ~15 mm³/s
- Layer: 0.3mm möglich
- Für: Schnelle Draft-Drucke

**Mit CHT Brass 0.6mm:**
- Max. Flow: ~30 mm³/s (+100%!)
- Layer: 0.4mm möglich
- Für: SEHR schnelle Draft-Drucke

---

## 💰 LOHNT SICH CHT FÜR DICH?

### Ja, wenn:

1. ✅ Du **schneller drucken** willst (>200mm/s)
2. ✅ Du **Standard-Filamente** nutzt (PLA, PETG, ABS)
3. ✅ Du **Druckzeit sparen** willst (bei gleicher Qualität)
4. ✅ Du den **Volumetric Speed** erhöhen willst

### Nein, wenn:

1. ❌ Du nur **abrasive Filamente** druckst (dann bleib bei Stahl)
2. ❌ Du nie schneller als 100mm/s druckst (Standard reicht)
3. ❌ Du mit deinem aktuellen Flow zufrieden bist

---

## 🛒 EMPFEHLUNG FÜR DICH

### Setup-Vorschlag:

| Nozzle | Verwendung | Preis | Priorität |
|--------|------------|-------|-----------|
| **CHT Brass 0.4mm** | Alltag (PLA, PETG) | €20 | **⭐⭐⭐** Sehr empfohlen! |
| Hardened Steel 0.4mm (hast du) | Abrasive Filamente | - | ✅ Behalten |
| Hardened Steel 0.6mm (hast du) | Draft/Abrasiv | - | ✅ Behalten |
| CHT Brass 0.6mm | Sehr schnelle Drucke | €25 | ⭐⭐ Optional |

**Budget**: €20 für CHT Brass 0.4mm

**Nutzen**:
- +50-80% höherer Flow
- 2× schnellere Drucke möglich
- Bessere Nutzung deiner BTT Pi 1.2 Performance

---

## 🏪 Wo kaufen?

### Marken-Empfehlungen:

1. **Bondtech CHT** (Original)
   - Amazon/Bondtech-Shop
   - ~€25-30
   - Beste Qualität

2. **Slice Engineering Mosquito CHT**
   - Für Mosquito-Hotends
   - ~€30

3. **E3D Revo CHT**
   - Für E3D Revo-System
   - ~€25

4. **Clone/Generic CHT**
   - AliExpress/Amazon
   - ~€10-15
   - Qualität variabel ⚠️

**Für SV06 Plus**: Prüfe ob dein Hotend **V6-kompatibel** ist (meist ja)

---

## 🔧 Installation & Kalibrierung

### 1. CHT Nozzle einbauen

```gcode
# 1. Hotend aufheizen
M109 S240

# 2. Alte Nozzle entfernen
# (Schraubenschlüssel, gegen Uhrzeigersinn)

# 3. CHT Nozzle einschrauben
# (Festziehen bei Temperatur!)

# 4. Abkühlen lassen
M104 S0
```

### 2. Neue Volumetric Speed messen

```gcode
# Flowrate neu testen!
FLOW_TEST TEMP=215

# Erwartung:
# - Standard: 12 mm³/s → Skippen
# - CHT: 20 mm³/s → Skippen
```

### 3. PrusaSlicer anpassen

```
Print Settings > Advanced > Max volumetric speed

Alt: 12 × 0.8 = 9.6 mm³/s
Neu: 20 × 0.8 = 16 mm³/s

→ +67% höhere Limit!
```

### 4. Druckgeschwindigkeiten erhöhen

```
Print Settings > Speed

Perimeters: 60 → 100 mm/s
Infill: 80 → 150 mm/s
Support: 60 → 120 mm/s

→ Alle Speeds bleiben unter Volumetric Limit!
```

---

## ⚠️ WICHTIG: Retraction anpassen

CHT Nozzles haben **mehr Innenvolumen** (3 Kanäle!)

**Standard-Nozzle Retraction:**
- Distance: 0.5-1.0mm
- Speed: 40mm/s

**CHT-Nozzle Retraction:**
- Distance: 1.5-2.5mm (erhöhen!)
- Speed: 40mm/s

**Test mit Retraction Tower nach CHT-Installation!**

---

## 📈 ERWARTETE VERBESSERUNG für DICH

### Aktuell (Hardened Steel 0.4mm):
- Max Flow: ~10 mm³/s
- Max Speed (0.2mm Layer): ~125 mm/s
- Benchy-Zeit: ~2.5h

### Mit CHT Brass 0.4mm:
- Max Flow: ~20 mm³/s (+100%)
- Max Speed (0.2mm Layer): ~250 mm/s (+100%)
- Benchy-Zeit: ~1.5h (**-40%!**)

### Qualität:
- ✅ Gleich oder besser (besserer Wärmeübergang)
- ✅ Glattere Oberflächen durch konsistenten Flow
- ⚠️ Retraction muss neu kalibriert werden

---

## 🎯 FAZIT

**CHT Nozzle = Bestes Preis/Leistungs-Upgrade!**

**€20 Investment:**
- +50-80% Flow-Kapazität
- 2× schnellere Drucke
- Gleiche oder bessere Qualität
- Behalte Stahl-Nozzles für abrasive Filamente

**Empfehlung**: ⭐⭐⭐⭐⭐ **Sofort kaufen!**

Zusammen mit BTT Eddy & KAMP wird dein Drucker **MASSIV** schneller! 🚀

---

Hast du Fragen zur CHT-Nozzle? 🔥
