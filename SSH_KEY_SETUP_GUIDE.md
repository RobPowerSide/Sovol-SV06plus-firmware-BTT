# 🔐 SSH-Key Setup - Schritt-für-Schritt für BTT Pi (192.168.10.5)

## 🎯 Was machen wir?

Wir erstellen einen **SSH-Key** für sichere, passwortlose Verbindung zu deinem BTT Pi.

**Vorteile:**
- ✅ Keine Passwort-Eingabe mehr bei jeder Verbindung
- ✅ Sicherer als Password-Auth
- ✅ Schnelleres Verbinden
- ✅ Funktioniert perfekt mit VS Code Remote

**Dauer:** ~5 Minuten

---

## 📋 SCHRITT 1: Terminal öffnen

**Auf deinem Mac:**

1. **Spotlight öffnen:** `Cmd+Space`
2. **Tippe:** `Terminal`
3. **Enter drücken**

**Oder:**
- `Applications` → `Utilities` → `Terminal`

**Terminal sollte jetzt offen sein** ✓

---

## 📋 SCHRITT 2: Prüfen ob SSH-Key bereits existiert

**Im Terminal, copy & paste diesen Befehl:**

```bash
ls -la ~/.ssh/
```

**Enter drücken**

### Mögliche Ausgaben:

#### **Fall A: Ordner existiert nicht**
```
ls: /Users/silvanwigger/.ssh/: No such file or directory
```

**→ Alles gut! Weiter zu Schritt 3**

---

#### **Fall B: Ordner existiert, aber KEINE Keys**
```
total 0
drwx------   2 silvanwigger  staff    64 Jan  2 10:00 .
drwxr-xr-x+ 50 silvanwigger  staff  1600 Jan  2 10:00 ..
```

**→ Alles gut! Weiter zu Schritt 3**

---

#### **Fall C: Keys existieren bereits**
```
total 16
drwx------   4 silvanwigger  staff   128 Jan  2 10:00 .
drwxr-xr-x+ 50 silvanwigger  staff  1600 Jan  2 10:00 ..
-rw-------   1 silvanwigger  staff   411 Jan  2 10:00 id_ed25519      ← Private Key!
-rw-r--r--   1 silvanwigger  staff   103 Jan  2 10:00 id_ed25519.pub  ← Public Key!
```

**Wenn du `id_ed25519` oder `id_rsa` siehst:**

✅ **Du hast bereits einen SSH-Key!**

**Zwei Optionen:**

**Option 1: Bestehenden Key verwenden** (Empfohlen)
- ➡️ **Springe direkt zu SCHRITT 4** (Key zum BTT Pi kopieren)

**Option 2: Neuen Key erstellen**
- Nur wenn du einen separaten Key für den Drucker willst
- Weiter zu Schritt 3, aber mit anderem Namen

---

## 📋 SCHRITT 3: Neuen SSH-Key erstellen

### 3.1 SSH-Key generieren

**Im Terminal, copy & paste diesen Befehl:**

```bash
ssh-keygen -t ed25519 -C "mac@sv06plus"
```

**Enter drücken**

**Was bedeutet das?**
- `ssh-keygen` = Programm zum Key erstellen
- `-t ed25519` = Moderner, sicherer Verschlüsselungs-Typ
- `-C "mac@sv06plus"` = Kommentar (hilft dir den Key zu identifizieren)

---

### 3.2 Speicherort bestätigen

**Terminal fragt:**

```
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/silvanwigger/.ssh/id_ed25519):
```

**Was tun?**

**Option A: Standard-Pfad verwenden** (Empfohlen)
- **Einfach Enter drücken** (nichts tippen!)
- Key wird gespeichert als: `~/.ssh/id_ed25519`

**Option B: Eigener Name** (nur wenn du mehrere Keys hast)
- Tippe z.B.: `/Users/silvanwigger/.ssh/id_sv06plus`
- Enter drücken

**➡️ Für dich: Einfach Enter drücken!**

---

### 3.3 Passphrase eingeben (Optional)

**Terminal fragt:**

```
Enter passphrase (empty for no passphrase):
```

**Was ist eine Passphrase?**
- Extra Passwort für den Key
- Wenn jemand deinen Mac klaut, kann er den Key nicht nutzen

**Empfehlung:**

**Option A: Keine Passphrase** (Für Home-Setup OK)
- **Einfach Enter drücken** (nichts tippen)
- Nochmal Enter bei "Enter same passphrase again:"
- ✅ Einfachste Option!

**Option B: Mit Passphrase** (Sicherer)
- Tippe ein Passwort (z.B. `sv06plus2024`)
- Enter drücken
- Gleiche Passphrase nochmal eingeben
- Enter drücken

**➡️ Für dich (Home-Netzwerk): Einfach Enter drücken (keine Passphrase)**

---

### 3.4 Key wurde erstellt! ✅

**Terminal zeigt:**

```
Your identification has been saved in /Users/silvanwigger/.ssh/id_ed25519
Your public key has been saved in /Users/silvanwigger/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx mac@sv06plus
The key's randomart image is:
+--[ED25519 256]--+
|    .o+.         |
|     + o         |
|    . = .        |
|   . = = o       |
|    = % S        |
|   . B *         |
|    o + .        |
|     .           |
|                 |
+----[SHA256]-----+
```

**Perfekt! Key wurde erstellt!** 🎉

---

## 📋 SCHRITT 4: Public Key zum BTT Pi kopieren

**Jetzt kopieren wir den öffentlichen Schlüssel zu deinem Drucker.**

### 4.1 Public Key anzeigen

**Im Terminal:**

```bash
cat ~/.ssh/id_ed25519.pub
```

**Du siehst sowas:**

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx mac@sv06plus
```

**Das ist dein Public Key!** (kannst du gefahrlos teilen)

---

### 4.2 Key zum BTT Pi kopieren (Automatisch)

**WICHTIG: Stelle sicher dass dein BTT Pi erreichbar ist!**

**Test:**
```bash
ping 192.168.10.5
```

**Sollte zeigen:**
```
PING 192.168.10.5: 56 data bytes
64 bytes from 192.168.10.5: icmp_seq=0 ttl=64 time=1.234 ms
64 bytes from 192.168.10.5: icmp_seq=1 ttl=64 time=1.123 ms
```

**Wenn ja: Mit Ctrl+C abbrechen** ✓

**Wenn "Request timeout": BTT Pi ist aus oder falsche IP!**

---

### 4.3 ssh-copy-id verwenden

**Im Terminal:**

```bash
ssh-copy-id biqu@192.168.10.5
```

**Was passiert:**

1. **Terminal fragt nach Passwort:**
   ```
   /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s)
   /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed
   biqu@192.168.10.5's password:
   ```

2. **Passwort eingeben:**
   - **Standard BTT Pi Passwort:** `biqu`
   - **Alternative:** `raspberry` oder `btt`
   - **Tippen** (du siehst nichts beim Tippen!)
   - **Enter drücken**

3. **Erfolgsmeldung:**
   ```
   Number of key(s) added: 1

   Now try logging into the machine with:
      ssh 'biqu@192.168.10.5'
   and check to make sure that only the key(s) you wanted were added.
   ```

**Perfekt! Key wurde kopiert!** ✅

---

## 📋 SCHRITT 5: Verbindung testen (OHNE Passwort!)

**Im Terminal:**

```bash
ssh biqu@192.168.10.5
```

**Was sollte passieren:**

**OHNE Passwort-Abfrage solltest du verbunden sein:**
```
Linux BTT-CB1 5.16.17 #1 SMP Mon Apr 25 12:23:45 UTC 2022 aarch64

The programs included with the Debian GNU/Linux system are free software;
...

Last login: Thu Jan  2 14:30:00 2026 from 192.168.10.100
biqu@BTT-CB1:~$
```

**DU BIST DRIN! OHNE PASSWORT!** 🎉

---

### Test abschließen:

```bash
# Im SSH-Terminal auf BTT Pi:
exit
```

**Oder:** `Ctrl+D` drücken

**Zurück auf deinem Mac-Terminal** ✓

---

## 📋 SCHRITT 6: SSH Config erstellen (Für VS Code)

**Jetzt erstellen wir eine Config, damit du einfach "sv06plus" statt IP verwenden kannst.**

### 6.1 SSH Config Datei öffnen

**Im Terminal:**

```bash
# Mit VS Code (wenn du 'code' command installiert hast):
code ~/.ssh/config

# ODER mit nano (Text-Editor):
nano ~/.ssh/config

# ODER mit dem Standard-Editor:
open -e ~/.ssh/config
```

**Wenn Fehler "File not found":**
```bash
# Datei erstellen:
touch ~/.ssh/config

# Dann nochmal öffnen:
code ~/.ssh/config
```

---

### 6.2 Config einfügen

**Copy & Paste diesen Text in die Datei:**

```ssh
# Sovol SV06 Plus - BTT Pi 1.2
Host sv06
    HostName 192.168.10.5
    User biqu
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ForwardAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
```

**Speichern:**
- **VS Code:** `Cmd+S`
- **nano:** `Ctrl+O`, Enter, `Ctrl+X`
- **TextEdit:** `Cmd+S`

---

### 6.3 Permissions setzen (Wichtig für Sicherheit!)

**Im Terminal:**

```bash
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

**Was macht das?**
- Setzt richtige Berechtigungen
- SSH verlangt das für Sicherheit

---

## 📋 SCHRITT 7: Testen mit Alias

**Im Terminal:**

```bash
ssh sv06
```

**Sollte SOFORT verbinden (ohne Passwort!):**
```
biqu@BTT-CB1:~$
```

**PERFEKT!** 🎉

**Jetzt kannst du einfach `ssh sv06` statt `ssh biqu@192.168.10.5` verwenden!**

---

## ✅ FINALE CHECKLISTE

Prüfe dass alles funktioniert:

- [ ] SSH-Key erstellt (`~/.ssh/id_ed25519` existiert)
- [ ] Public Key zum BTT Pi kopiert
- [ ] SSH-Verbindung OHNE Passwort funktioniert
- [ ] SSH Config erstellt (`~/.ssh/config` existiert)
- [ ] Alias "sv06" funktioniert
- [ ] Permissions gesetzt (600/644)

**Wenn alle ✅:**

# 🎉 SSH-KEY SETUP ABGESCHLOSSEN!

---

## 🚀 NÄCHSTER SCHRITT: VS Code Remote verbinden

**Jetzt wo SSH funktioniert, können wir VS Code verbinden!**

### In VS Code:

1. **Command Palette öffnen:** `Cmd+Shift+P`

2. **Tippe:** `Remote-SSH: Connect to Host...`

3. **Wähle:** `sv06`

4. **Warte ~10 Sekunden** (beim ersten Mal)

5. **VS Code ist verbunden!** Unten links sollte stehen:
   ```
   SSH: sv06
   ```

6. **Ordner öffnen:**
   - `File` → `Open Folder...`
   - Eingabe: `/home/biqu/printer_data/config`
   - `OK`

7. **Du siehst jetzt alle Klipper-Configs!** 🎉

---

## 🔍 TROUBLESHOOTING

### Problem 1: "Permission denied (publickey)"

**Bedeutet:** Key wurde nicht richtig kopiert

**Lösung:**
```bash
# Key nochmal kopieren
ssh-copy-id -i ~/.ssh/id_ed25519.pub biqu@192.168.10.5

# Mit Passwort einloggen
# Dann nochmal testen:
ssh sv06plus
```

---

### Problem 2: "ssh-copy-id: command not found" (auf Mac)

**Bedeutet:** ssh-copy-id nicht installiert

**Lösung - Manuelle Methode:**

```bash
# Public Key anzeigen
cat ~/.ssh/id_ed25519.pub

# Kopiere die gesamte Zeile (Cmd+C)

# SSH normal verbinden (mit Passwort)
ssh biqu@192.168.10.5

# Auf BTT Pi:
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys

# Paste den Public Key (Cmd+V)
# Speichern: Ctrl+O, Enter, Ctrl+X

# Permissions setzen:
chmod 600 ~/.ssh/authorized_keys

# Ausloggen:
exit

# Jetzt ohne Passwort testen:
ssh biqu@192.168.10.5
```

---

### Problem 3: "Host key verification failed"

**Bedeutet:** BTT Pi wurde neu installiert oder IP-Konflikt

**Lösung:**
```bash
# Alte Host-Entry löschen:
ssh-keygen -R 192.168.10.5

# Dann neu verbinden:
ssh sv06plus
# Tippe "yes" bei Fingerprint-Frage
```

---

### Problem 4: Verbindung hängt / Timeout

**Bedeutet:** Firewall oder Netzwerk-Problem

**Prüfen:**
```bash
# Ping testen:
ping 192.168.10.5

# Wenn kein Ping:
# - BTT Pi ist aus
# - Falsche IP
# - Netzwerk-Problem

# SSH Port testen:
nc -zv 192.168.10.5 22

# Sollte zeigen: "Connection to 192.168.10.5 port 22 [tcp/ssh] succeeded!"
```

---

## 📚 WICHTIGE BEFEHLE - ZUSAMMENFASSUNG

```bash
# SSH-Key erstellen
ssh-keygen -t ed25519 -C "mac@sv06plus"

# Key zum Server kopieren
ssh-copy-id biqu@192.168.10.5

# Mit Alias verbinden
ssh sv06

# Mit IP verbinden
ssh biqu@192.168.10.5

# Public Key anzeigen
cat ~/.ssh/id_ed25519.pub

# SSH Config bearbeiten
code ~/.ssh/config

# Verbindung testen
ssh -v sv06  # Verbose mode (zeigt Details)
```

---

## 🎯 WAS DU JETZT HAST

**Vorher:**
```bash
ssh biqu@192.168.10.5
# Passwort eingeben...
biqu@BTT-CB1:~$
```

**Nachher:**
```bash
ssh sv06
# Sofort verbunden! Kein Passwort!
biqu@BTT-CB1:~$
```

**In VS Code:**
```
Cmd+Shift+P → "sv06" → Sofort verbunden!
```

**Zeit gespart:** ~5 Sekunden pro Verbindung
**Anzahl Verbindungen pro Tag:** ~10-20×
**Zeitersparnis:** ~1-2 Minuten pro Tag! 🚀

---

**Du bist jetzt bereit für VS Code Remote Editing!** 🎉

Sag mir wenn du fertig bist oder Fragen hast!
