# 🔌 VS Code Extensions Installation - Schritt für Schritt

## 📋 ÜBERSICHT - Welche Extensions brauchen wir?

**Essentiell:**
1. ✅ **Remote - SSH** → Ermöglicht SSH-Verbindung
2. ✅ **Klipper Configuration** → Syntax-Highlighting für `.cfg` Files
3. ✅ **G-Code Syntax** → Syntax-Highlighting für G-Code

**Optional aber empfohlen:**
4. ⭐ **GitLens** → Git History & Blame
5. ⭐ **Error Lens** → Inline Error Messages

---

## 🎯 METHODE 1: GUI Installation (Empfohlen für Anfänger)

### Schritt-für-Schritt Anleitung mit Screenshots-Beschreibung:

#### 1. Extensions Panel öffnen

**Option A: Sidebar**
```
Klicke auf das "Würfel"-Symbol in der linken Sidebar
(4. Icon von oben, unter Search)
```

**Option B: Tastenkombination**
```
Mac: Cmd+Shift+X
Windows/Linux: Ctrl+Shift+X
```

**Option C: Menü**
```
View → Extensions
```

---

#### 2. Extension suchen & installieren

##### **Extension 1: Remote - SSH**

1. **Suchfeld anklicken** (oben im Extensions-Panel)
2. **Eingabe:** `Remote - SSH`
3. **Erste Ergebnis sollte sein:**
   ```
   Remote - SSH
   von Microsoft
   ⭐⭐⭐⭐⭐ (sehr viele Bewertungen)
   ```
4. **Klicke auf den blauen "Install" Button**
5. **Warte ~5 Sekunden** (Button wird zu "Installed" ✓)

**Fertig!** ✅

---

##### **Extension 2: Klipper Configuration**

1. **Suchfeld:** `Klipper Configuration`
2. **Ergebnis:**
   ```
   Klipper Configuration
   von Michel Morin
   ```
3. **"Install" klicken**
4. **Warten bis fertig** ✓

---

##### **Extension 3: G-Code Syntax**

1. **Suchfeld:** `G-Code`
2. **Wähle:**
   ```
   G-Code Syntax
   von Alexandre Papin

   ODER

   vscode-gcode
   von Mike M
   ```
   (Beide sind gut, nimm die erste)
3. **"Install" klicken** ✓

---

#### 3. Überprüfen ob installiert

**Methode A:**
```
Extensions Panel → Suche löschen
→ Oben Tab "Installed" anklicken
→ Solltest sehen:
  - Remote - SSH ✓
  - Klipper Configuration ✓
  - G-Code Syntax ✓
```

**Methode B:**
```
Cmd+Shift+P
→ Tippe: "Remote-SSH"
→ Wenn Befehle erscheinen → Extension ist installiert! ✓
```

---

## 🎯 METHODE 2: Command Palette (Schnell)

### Via Extensions Search:

1. **Command Palette öffnen:**
   ```
   Mac: Cmd+Shift+P
   Windows/Linux: Ctrl+Shift+P
   ```

2. **Tippe:** `Extensions: Install Extensions`

3. **Enter drücken**

4. **Suchfeld erscheint** → Wie Methode 1, weiter oben

---

## 🎯 METHODE 3: Terminal/Command-Line (Power-User)

### Für alle Extensions auf einmal:

**Terminal öffnen** (außerhalb von VS Code):

```bash
# Alle essentiellen Extensions installieren
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension mmorin-ls.klipper-config

# G-Code Extension (eine von beiden):
code --install-extension stmn.gcode
# ODER
code --install-extension appliedengdesign.gcode-syntax

# Optional: Empfohlene Extras
code --install-extension eamodio.gitlens
code --install-extension usernamehw.errorlens
```

**Vorteile:**
- ✅ Alle auf einmal
- ✅ Scriptbar
- ✅ Schnell

**Terminal-Ausgabe:**
```
Installing extensions...
Extension 'ms-vscode-remote.remote-ssh' v0.xxx.0 was successfully installed.
Extension 'mmorin-ls.klipper-config' v0.xxx.0 was successfully installed.
...
```

---

## 🎯 METHODE 4: Extensions View Filter (Marketplace)

### Wenn du durchstöbern willst:

1. **Extensions Panel öffnen** (Cmd+Shift+X)

2. **Filter verwenden:**
   - **"@recommended"** → Empfohlene Extensions
   - **"@popular"** → Beliebteste Extensions
   - **"@category:remote"** → Alle Remote-Extensions

3. **Remote - SSH sollte ganz oben sein** bei "@category:remote"

---

## ✅ INSTALLATIONS-CHECKLISTE

Nach Installation solltest du das sehen:

### Im Extensions Panel (Installed):

```
✓ Remote - SSH
  von Microsoft
  📦 Install on Remote Server: ssh://...

✓ Remote - SSH: Editing Configuration Files
  von Microsoft
  (wird automatisch mit Remote-SSH installiert)

✓ Klipper Configuration
  von Michel Morin
  Provides syntax highlighting for Klipper configuration files

✓ G-Code Syntax
  von Alexandre Papin (oder Mike M)
  Syntax highlighting for G-Code
```

---

## 🔍 TROUBLESHOOTING

### Problem 1: "code: command not found" im Terminal

**Lösung:**

1. **VS Code öffnen**
2. **Command Palette:** Cmd+Shift+P
3. **Tippe:** `Shell Command: Install 'code' command in PATH`
4. **Enter drücken**
5. **Terminal neu starten**
6. **Jetzt sollte `code --version` funktionieren**

---

### Problem 2: Extension wird nicht gefunden

**Mögliche Gründe:**

1. **Schreibfehler** → Genau nach Namen suchen
2. **Offline** → Internet-Verbindung prüfen
3. **VS Code veraltet** → Update auf neueste Version

**Lösung:**
```bash
# VS Code Version prüfen
code --version

# Sollte mind. 1.80+ sein
# Falls älter: VS Code updaten
```

---

### Problem 3: Extension installiert, aber funktioniert nicht

**Lösung:**

1. **VS Code neu starten:**
   ```
   Cmd+Q (VS Code beenden)
   → Neu öffnen
   ```

2. **Extension neu laden:**
   ```
   Extensions Panel → Extension finden
   → Zahnrad-Symbol ⚙️ → "Reload Required"
   ```

3. **Extension neu installieren:**
   ```
   Extensions Panel → Extension finden
   → Zahnrad-Symbol ⚙️ → "Uninstall"
   → Neu installieren
   ```

---

### Problem 4: Remote Extension wird nicht auf Server installiert

**Symptom:**
- Remote-Verbindung klappt
- Aber: Klipper-Syntax wird nicht erkannt

**Grund:** Manche Extensions müssen **auf dem Remote-Server** installiert werden!

**Lösung:**

1. **Mit Remote verbinden** (ssh sv06plus)
2. **Extensions Panel öffnen**
3. **Bei der Extension sollte stehen:**
   ```
   Install in SSH: sv06plus
   ```
4. **Auf "Install in SSH: sv06plus" klicken**

**Automatisch:** VS Code fragt oft automatisch beim ersten Connect

---

## 📦 EXTENSIONS IM DETAIL

### 1. Remote - SSH (Microsoft)

**Extension ID:** `ms-vscode-remote.remote-ssh`

**Was macht sie?**
- Ermöglicht SSH-Verbindung zu Linux-Hosts
- VS Code Server wird auf Remote installiert
- Alle Files bleiben auf dem Remote
- Editing/Terminal alles Remote

**Größe:** ~5 MB

**Abhängigkeiten:**
- Installiert automatisch: "Remote - SSH: Editing Configuration Files"
- Optional: "Remote Explorer"

**Nach Installation verfügbar:**
- Command: "Remote-SSH: Connect to Host..."
- Command: "Remote-SSH: Add New SSH Host..."
- Status-Bar: Remote-Indikator (unten links)

---

### 2. Klipper Configuration (Michel Morin)

**Extension ID:** `mmorin-ls.klipper-config`

**Was macht sie?**
- Syntax-Highlighting für `.cfg` Files
- Auto-Complete für Klipper-Befehle
- Hover-Tooltips für Parameter
- Error-Detection für ungültige Syntax

**Größe:** ~1 MB

**Features:**
```python
# Beispiel: In printer.cfg
[stepper_x]
step_pin: PC2        # ← Wird highlighted
dir_pin: !PB9        # ← "!" wird erkannt (inverted)
rotation_distance:   # ← Auto-Complete schlägt "40" vor
```

**Nach Installation:**
- `.cfg` Files haben Farben
- Klipper-Sections werden erkannt
- Tooltips bei Hover

---

### 3. G-Code Syntax

**Extension ID:** `stmn.gcode` ODER `appliedengdesign.gcode-syntax`

**Was macht sie?**
- Syntax-Highlighting für `.gcode` und `.nc` Files
- G-Code Commands werden highlighted
- Kommentare erkannt

**Beispiel:**
```gcode
G28                 ; Home (wird blau)
G1 X150 Y150 F3000  ; Move (wird grün)
M109 S215           ; Heat (wird orange)
; Comment           ; Kommentar (wird grau)
```

**Größe:** ~100 KB (sehr leicht)

---

## 🎨 BONUS: Empfohlene Extra-Extensions

### GitLens (eamodio.gitlens)

**Warum?**
- Git History inline
- Blame-Annotations (wer hat was geändert)
- Repository-Explorer

**Installation:**
```bash
code --install-extension eamodio.gitlens
```

**Nutzen für Klipper:**
- Sehe wann du welche Config geändert hast
- Vergleiche Config-Versionen
- Rollback zu alten Configs

---

### Error Lens (usernamehw.errorlens)

**Warum?**
- Zeigt Fehler **INLINE** (nicht nur in Problemansicht)
- Sehr hilfreich für Syntax-Fehler

**Installation:**
```bash
code --install-extension usernamehw.errorlens
```

**Beispiel:**
```python
[stepper_x
step_pin: PC2

# Error Lens zeigt direkt:
# ❌ Missing closing bracket ']'
```

---

### Better Comments (aaron-bond.better-comments)

**Warum?**
- Farbige Kommentare je nach Typ

**Installation:**
```bash
code --install-extension aaron-bond.better-comments
```

**Beispiel:**
```python
# ! WICHTIG: Z-Offset muss kalibriert werden
# ? TODO: Input Shaper noch aktivieren
# * HINWEIS: Funktioniert mit KAMP
# // DEAKTIVIERT: old config
```

---

## 🚀 QUICK START - Copy & Paste

### Alle Extensions auf einmal installieren:

**Öffne Terminal (außerhalb VS Code):**

```bash
# Essentiell (Remote + Klipper)
code --install-extension ms-vscode-remote.remote-ssh && \
code --install-extension ms-vscode-remote.remote-ssh-edit && \
code --install-extension mmorin-ls.klipper-config && \
code --install-extension stmn.gcode

# Optional aber empfohlen
code --install-extension eamodio.gitlens && \
code --install-extension usernamehw.errorlens && \
code --install-extension aaron-bond.better-comments

# Warte bis fertig
echo "✅ Alle Extensions installiert!"
```

**Dann:**
```bash
# VS Code neu starten
code --version  # Prüfe dass es läuft
```

**Öffne VS Code:**
```
Cmd+Shift+X → "Installed" Tab
→ Solltest 7 Extensions sehen! ✓
```

---

## 📊 EXTENSIONS ÜBERSICHT

| Extension | Essential? | Größe | Install Command |
|-----------|-----------|-------|-----------------|
| Remote - SSH | ✅ JA | 5 MB | `ms-vscode-remote.remote-ssh` |
| Klipper Config | ✅ JA | 1 MB | `mmorin-ls.klipper-config` |
| G-Code Syntax | ✅ JA | 0.1 MB | `stmn.gcode` |
| GitLens | ⭐ Optional | 20 MB | `eamodio.gitlens` |
| Error Lens | ⭐ Optional | 0.5 MB | `usernamehw.errorlens` |
| Better Comments | ⭐ Optional | 0.3 MB | `aaron-bond.better-comments` |

**Gesamt (essentiell):** ~6 MB
**Gesamt (mit optional):** ~27 MB

---

## ✅ FINALE CHECKLISTE

Nach Installation sollte das alles funktionieren:

- [ ] Extensions Panel zeigt "Remote - SSH" ✓
- [ ] Extensions Panel zeigt "Klipper Configuration" ✓
- [ ] Extensions Panel zeigt "G-Code Syntax" ✓
- [ ] Command Palette (Cmd+Shift+P) zeigt "Remote-SSH: Connect..." ✓
- [ ] VS Code Status-Bar (unten links) zeigt Remote-Icon ✓
- [ ] Terminal-Befehl `code --version` funktioniert ✓

**Wenn alle ✅ → Extensions fertig installiert!** 🎉

---

## 🎯 NÄCHSTER SCHRITT

**Nach Extension-Installation:**

➡️ Gehe zu [VSCODE_REMOTE_SETUP.md](VSCODE_REMOTE_SETUP.md)

**Dort:**
1. SSH-Key erstellen
2. SSH Config einrichten
3. Mit BTT Pi verbinden (192.168.10.5)
4. Klipper-Configs editieren!

---

**Viel Erfolg! Bei Fragen helfe ich gerne weiter! 🚀**
