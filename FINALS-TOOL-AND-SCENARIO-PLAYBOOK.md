# 🕵️‍♂️ Flag Hunters CTF 2026: Finals Field Manual & Tool Playbook
### *The Ultimate Scenario-Based Guide: What Software to Use, When to Use It, and Exact Commands*

**Target Competition**: Flag Hunters CTF 2026 (AFKAR — IIT Delhi - Abu Dhabi)  
**Case File**: FH-2026 / The Carson City Digital Murder Mystery  
**Target Environment**: Provided Windows Workstations (Portable / No-Admin Setup)  
**Flag Format**: `flag{<letters_numbers_underscores>}`  
**Authorized Resources**: Internet Access (CyberChef, dCode, online decoders, documentation) and AI LLMs (Gemini, Claude, ChatGPT).

---

## 🧭 Navigation Index

1. [Master Decision Matrix (Quick Lookup)](#1-master-decision-matrix-quick-lookup)
2. [Scenario A: Unknown File or Suspicious Blob](#2-scenario-a-unknown-file-or-suspicious-blob)
3. [Scenario B: Steganography & Hidden Media (Images / Audio / PDFs)](#3-scenario-b-steganography--hidden-media-images--audio--pdfs)
4. [Scenario C: Cryptography, Ciphers & Password Hashes](#4-scenario-c-cryptography-ciphers--password-hashes)
5. [Scenario D: Network Traffic Analysis (.pcap / .pcapng)](#5-scenario-d-network-traffic-analysis-pcap--pcapng)
6. [Scenario E: Reverse Engineering & Binary Analysis (.exe / ELF / Scripts)](#6-scenario-e-reverse-engineering--binary-analysis-exe--elf--scripts)
7. [Scenario F: Web Application Exploitation & Portals](#7-scenario-f-web-application-exploitation--portals)
8. [Scenario G: The "Victim's Computer" Digital Murder Mystery Investigation](#8-scenario-g-the-victims-computer-digital-murder-mystery-investigation)
9. [Scenario H: Memory & Disk Forensics (.raw / .dmp / .img)](#9-scenario-h-memory--disk-forensics-raw--dmp--img)
10. [Scenario I: Python Automation & Rapid Exploitation Recipes](#10-scenario-i-python-automation--rapid-exploitation-recipes)
11. [Emergency Troubleshooting & Fallbacks](#11-emergency-troubleshooting--fallbacks)

---

## 1. Master Decision Matrix (Quick Lookup)

When given a challenge artifact or stumbling into a roadblock, look up your symptom below:

| What You Have / Problem Type | Primary Tool | Secondary / Backup Tool | Immediate Action / First Command |
| :--- | :--- | :--- | :--- |
| **Unknown file extension / Corrupt file** | **HxD / File** | CyberChef (Detect File Type) | Check magic header bytes in HxD or `file <filename>` |
| **Visible image (.png, .jpg, .bmp)** | **Aperi'Solve / Stegsolve** | `exiftool`, `steghide` | `exiftool image.png` then test LSB planes in Stegsolve |
| **Hidden password on image** | **steghide** | `stego-toolkit` / python | `steghide extract -sf image.jpg -p ""` |
| **Ciphertext ending with `=` or `==`** | **CyberChef** | `ConvertFrom-Base64String` | CyberChef Recipe: `From Base64` |
| **Mystery hex string (`414243...`)** | **CyberChef** | Python `bytes.fromhex()` | CyberChef Recipe: `From Hex` |
| **Hash (MD5, SHA1, SHA256, NTLM)** | **CrackStation** | `hashcat` / `john` | Paste in https://crackstation.net/ or run `hashcat -m 0` |
| **Network packet capture (.pcap)** | **Wireshark** | `tshark` / NetworkMiner | Filter `http` or `dns`; Export Objects -> HTTP |
| **Executable (.exe / .dll / ELF)** | **Ghidra / dnSpy** | `strings` / Sysinternals | `Get-FileStrings binary.exe \| Select-String "flag"` |
| **Website / Web login challenge** | **Browser DevTools** | Burp Suite / `sqlmap` | Ctrl+U (Page Source), F12 (Storage & Network), test `' OR '1'='1` |
| **Victim's Windows OS / Desktop** | **Sysinternals Suite** | PowerShell History / Registry | Inspect `%APPDATA%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt` |
| **Memory Dump (.raw / .vmem / .dmp)** | **Volatility 3** | `bulk_extractor` / `strings` | `vol.py -f dump.raw windows.pslist` |
| **Zip / 7z / Tar with unknown password** | **John the Ripper** | `fcrackzip` / Hashcat | `zip2john file.zip > hash.txt; john hash.txt` |

---

## 2. Scenario A: Unknown File or Suspicious Blob

### Situation
The organizer gives you a file with no extension, a misleading extension (e.g., `evidence.txt` that won't open), or raw binary data.

### Tool Selection & Workflow

```
[Unknown File] 
     │
     ├── 1. Check Magic Bytes ────────► HxD Hex Editor / 'file' utility
     ├── 2. Extract Plaintext ────────► strings / Get-FileStrings / Find-Flag
     └── 3. Check for Nested Files ───► binwalk / foremost / 7-Zip
```

#### Step 1: Identify Real File Signature (Magic Bytes)
- **Software**: **HxD Hex Editor** (GUI) or `file` (CLI).
- **In HxD**: Open the file in HxD and check the first 4 to 16 bytes:
  - `89 50 4E 47 0D 0A 1A 0A` -> **PNG Image** (change extension to `.png`)
  - `FF D8 FF` -> **JPEG Image** (change extension to `.jpg`)
  - `50 4B 03 04` -> **ZIP Archive / Office DOCX / APK** (rename to `.zip` and extract)
  - `25 50 44 46` (`%PDF`) -> **PDF Document**
  - `4D 5A` (`MZ`) -> **Windows Executable (.exe / .dll)**
  - `7F 45 4C 46` (`.ELF`) -> **Linux Binary**
  - `52 61 72 21` (`Rar!`) -> **RAR Archive**
  - `42 5A 68` (`BZh`) -> **Bzip2 Archive**
  - `1F 8B 08` -> **Gzip Archive**

- **In PowerShell / Portable Toolkit CLI**:
  ```powershell
  # If file tool is available
  file mystery_file

  # View first 32 bytes in PowerShell without external tools
  Format-Hex -Path .\mystery_file -Count 32
  ```

#### Step 2: Search for Flags and Readable Text
Often flags or passwords are left as cleartext strings inside binaries, documents, or data dumps.
```powershell
# Quick flag scan using CTF helper
Find-Flag mystery_file

# Sysinternals strings extraction (finds both ASCII and Unicode strings)
Get-FileStrings mystery_file | Select-String -Pattern "flag"
Get-FileStrings mystery_file | Select-String -Pattern "key"
Get-FileStrings mystery_file | Select-String -Pattern "http"

# Native PowerShell strings extraction (fallback)
Select-String -Path .\mystery_file -Pattern "flag\{[^\}]+\}" -AllMatches
```

#### Step 3: Extract Embedded Files (File Carving)
If an image or binary has a hidden zip or doc tucked inside it:
```powershell
# Using 7-Zip Portable
Extract-All mystery_file
# Or direct command:
7z x mystery_file -oextracted_data/

# Using binwalk (if installed/in WSL/Linux)
binwalk mystery_file          # Scan headers
binwalk -e mystery_file       # Extract all discovered payloads automatically

# Using foremost
foremost -i mystery_file -o ./carved_output/
```

---

## 3. Scenario B: Steganography & Hidden Media (Images / Audio / PDFs)

### Situation
You find an image in the victim's documents, a photo attached to an email, an audio voicemail, or a PDF case file that looks suspicious.

### Decision Hierarchy for Images

```
[Suspicious Image]
       │
       ├── 1. Metadata Inspection ──────► exiftool image.jpg
       ├── 2. Automated Multi-Analysis ─► Aperi'Solve (Web) or StegOnline
       ├── 3. Password-Protected Stego ─► steghide extract -sf image.jpg
       ├── 4. Bit-Plane / LSB Visual ───► Stegsolve (GUI) -> Data Extract
       └── 5. Embedded Archive Check ───► 7z / binwalk / strings
```

#### Tool 1: ExifTool (Metadata Examination)
Exif metadata often hides author names, coordinates, comments, base64 strings, or the flag itself.
```powershell
# View all metadata tags (including hidden & binary tags)
exiftool -a -u -g1 image.jpg

# Quick search for flag in metadata
exiftool image.jpg | Select-String -Pattern "flag"

# Online fallback
# Visit: https://exifdata.com/ or https://fotoforensics.com/
```

#### Tool 2: Steghide (Password/No-Password Extraction)
Commonly used on JPEG, BMP, and WAV files.
```powershell
# 1. Try extracting with EMPTY password (just press Enter when prompted)
steghide extract -sf image.jpg

# 2. Extract with password found from clues or story
steghide extract -sf image.jpg -p "CarsonCity2026"

# 3. View info about embedded payload before extracting
steghide info image.jpg
```
*If steghide requires a password and you have none, use `stegseek` (if available) or crack it with rockyou.txt.*

#### Tool 3: Stegsolve (Bit-Plane, Color Inversion & LSB Analysis)
Best for PNG and BMP images where data is encoded into the least significant bits.
1. Run `stegsolve` from PowerShell or click `Launch-Stegsolve.bat`.
2. Open your image (`File -> Open`).
3. Use the **arrow buttons `< >`** at the bottom to toggle planes:
   - *Color Inversion, Red/Green/Blue Plane 0, Random Color Map, Gray Scale*.
   - Watch for QR codes, text, or flags revealed in plane 0!
4. **Data Extract**:
   - Go to `Analyse -> Data Extract`.
   - Select `Red 0`, `Green 0`, `Blue 0` (or `Alpha 0`).
   - Check `LSB First` vs `MSB First`.
   - Click **Preview** or **Save Bin** (often reveals hidden zips or text).
5. **Frame Browser**:
   - If it's an animated GIF or APNG, go to `Analyse -> Frame Browser` to check individual secret frames.
6. **Image Combiner**:
   - If given two identical images: `Analyse -> Image Combiner` (try `XOR`, `SUB`, `ADD`).

#### Tool 4: Audio Steganography (.wav / .mp3)
If you encounter a sound file:
1. **Audacity / Sonic Visualiser**:
   - Switch track view from **Waveform** to **Spectrogram**. Flags are frequently written visually in high frequencies!
2. **Audio Steghide**:
   ```bash
   steghide extract -sf recording.wav
   ```
3. **DTMF Tones**: Dial tones from keypad numbers. Use an online DTMF decoder (`https://www.dialabc.com/sound/detect/`).
4. **Morse Code**: Look at dots/dashes in the waveform or use Morse audio decoders on `dCode.fr`.

#### Tool 5: Suspicious PDF Documents
1. Check for white text on white background (`Ctrl+A` in PDF reader, copy-paste into Notepad).
2. Extract embedded images and text:
   ```powershell
   # Search PDF directly
   Select-String -Path .\document.pdf -Pattern "flag"
   ```
3. Check PDF streams using CyberChef or Python (`pypdf` / `pdfplumber`).

---

## 4. Scenario C: Cryptography, Ciphers & Password Hashes

### Situation
You discover a mysterious encrypted message, a hash dump, an encoded token, or a password-protected zip file.

### Step 1: Cipher & Encoding Identification
Before trying to crack anything, identify what it is!

| Cipher / Hash Pattern | Likely Algorithm | Best Tool |
| :--- | :--- | :--- |
| Ends with `=` or `==`, charset `[A-Za-z0-9+/]` | **Base64** | CyberChef: `From Base64` |
| Only uppercase `[A-Z2-7=]` | **Base32** | CyberChef: `From Base32` |
| `0x...` or even-length strings of `[0-9a-fA-F]` | **Hexadecimal / ASCII Hex** | CyberChef: `From Hex` |
| Only 0s and 1s with spaces or multiples of 8 | **Binary** | CyberChef: `From Binary` |
| Letters rotated (e.g., `synt{...}` -> `flag{...}`) | **ROT13 / Caesar** | CyberChef: `ROT13` |
| 32 hex chars (e.g., `5d41402abc4b2a76b9719d911017c592`) | **MD5 Hash** | CrackStation / Hashcat (`-m 0`) |
| 40 hex chars | **SHA-1 Hash** | CrackStation / Hashcat (`-m 100`) |
| 64 hex chars | **SHA-256 Hash** | CrackStation / Hashcat (`-m 1400`) |
| `$2a$`, `$2b$`, `$2y$` prefix | **Bcrypt** | Hashcat (`-m 3200`) |
| `eyJ...` (three dot-separated base64 strings) | **JWT (JSON Web Token)** | `jwt.io` or CyberChef |
| Dots and dashes (`... --- ...`) | **Morse Code** | dCode: Morse Code |
| Polybius, Vigenère, Playfair, Substitution | **Classical Ciphers** | dCode.fr Cipher Identifier |

#### Instant Solver: CyberChef "Magic" Operation
1. Run `cyberchef` in PowerShell (or go to `https://gchq.github.io/CyberChef/`).
2. Paste input into **Input** box.
3. Drag the **Magic** operation into the **Recipe**.
4. Set *Depth* to 3. CyberChef will brute-force detect multi-layer encoding (e.g. Hex -> Base64 -> Gzip).

#### CyberChef Recipes for Common CTF Chains:
- **Base64 + Gzip**: `From Base64` -> `Gunzip`
- **Hex + XOR**: `From Hex` -> `XOR(key='key', type='UTF8')`
- **Reverse Text**: `Reverse`

---

### Step 2: Password Hash Cracking

#### A. Online Instant Lookup (Fastest - Try First!)
1. Open **CrackStation** (`https://crackstation.net/`).
2. Paste all hashes and solve captcha. CrackStation has billions of pre-computed hashes (MD5, SHA1, SHA256, NTLM).
3. If not found, search the hash string directly on Google or VirusTotal.

#### B. Hashcat (Offline Wordlist Attack)
```powershell
# Common Hashcat Modes (-m):
# 0    = MD5
# 100  = SHA1
# 1400 = SHA256
# 1000 = NTLM (Windows passwords)
# 1800 = SHA512crypt (Linux /etc/shadow)
# 2500 = WPA/WPA2

# Syntax: hashcat -m <MODE> -a 0 <HASH_FILE> <WORDLIST>
hashcat -m 0 hash.txt "$env:USERPROFILE\CTF-Tools\wordlists\rockyou.txt"
hashcat -m 1400 sha256_hash.txt "$env:USERPROFILE\CTF-Tools\wordlists\rockyou.txt"

# Show previously cracked password
hashcat -m 0 --show hash.txt
```

#### C. John the Ripper (Automated Archive / Passwd Cracking)
```bash
# 1. Cracking Password-Protected ZIPs
zip2john secret.zip > zip.hash
john --wordlist=rockyou.txt zip.hash
john --show zip.hash

# 2. Cracking Password-Protected PDFs
pdf2john document.pdf > pdf.hash
john --wordlist=rockyou.txt pdf.hash

# 3. Cracking Password-Protected RARs
rar2john archive.rar > rar.hash
john --wordlist=rockyou.txt rar.hash
```

---

## 5. Scenario D: Network Traffic Analysis (.pcap / .pcapng)

### Situation
You are given a network packet dump (`traffic.pcap`, `capture.pcapng`) from the victim's machine or a captured intrusion attempt.

### Analysis Checklist in Wireshark

```
[Open .pcap in Wireshark]
       │
       ├── 1. Statistics ──────────► Protocol Hierarchy & Conversations
       ├── 2. HTTP Extraction ─────► File -> Export Objects -> HTTP
       ├── 3. Credential Search ───► Filter: http.request.method == "POST"
       ├── 4. Stream Reconstruction► Right click packet -> Follow -> TCP Stream
       └── 5. DNS / Data Exfil ────► Filter: dns (look for subdomain tunneling)
```

#### Step 1: First 30 Seconds in Wireshark
1. Launch Wireshark: `wireshark capture.pcap`
2. Go to **Statistics -> Protocol Hierarchy**:
   - Check if there is HTTP, TLS, FTP, DNS, SMB, or plain TCP.
3. Go to **Statistics -> Conversations -> TCP tab**:
   - Sort by **Bytes** descending. Big transfers indicate file downloads or exfiltrated data!

#### Step 2: Essential Wireshark Display Filters

```wireshark
# Find all plain HTTP web requests
http

# Find login submissions, passwords, and form data
http.request.method == "POST"

# Filter by target host / domain
http.host contains "carson" or ip.addr == 192.168.1.50

# Look for file transfers
http contains "flag" or http contains "password"

# Inspect DNS queries (look for long hex/base64 encoded queries = DNS Tunneling)
dns.flags.response == 0

# Inspect FTP and Telnet credentials
ftp or telnet

# Filter specific TCP port
tcp.port == 8080 or tcp.port == 4444

# Search packets containing raw string
frame contains "flag{"
```

#### Step 3: Following TCP Streams
When you find a suspicious packet (e.g. HTTP GET `/flag.txt` or a netcat reverse shell on port `4444`):
1. **Right-click** on the packet.
2. Select **Follow -> TCP Stream**.
3. A window opens showing the entire conversation in clear text (Red = sent by client, Blue = returned by server).
4. Use the bottom right arrow to cycle through `Stream 0`, `Stream 1`, `Stream 2`...

#### Step 4: Exporting Transferred Files (Carving from Network)
1. In Wireshark menu, click **File -> Export Objects -> HTTP...**
2. Browse the list of files transferred across the network (HTML, PNG, ZIP, EXE).
3. Click **Save All** to dump every transmitted file onto your disk.

#### Step 5: Fast CLI Extraction with `tshark`
If you need fast scripts or Wireshark GUI is slow:
```powershell
# Extract all HTTP URLs requested
tshark -r capture.pcap -Y "http.request" -T fields -e http.host -e http.request.uri

# Extract all DNS queries (detect exfiltration)
tshark -r capture.pcap -Y "dns.flags.response==0" -T fields -e dns.qry.name | sort -u

# Search for the flag pattern across all packet payloads
tshark -r capture.pcap -Y 'frame contains "flag{"' -x
```

---

## 6. Scenario E: Reverse Engineering & Binary Analysis (.exe / ELF / Scripts)

### Situation
You find an executable binary, a keygen challenge, an encrypted ransom script, or a compiled program that asks for a secret passkey.

### Rapid Binary Triage

```
[Target Binary]
       │
       ├── 1. Strings & Secrets ──────► strings / Get-FileStrings | Select-String "flag"
       ├── 2. Detect Technology ──────► .NET (C#) / Java JAR / Native (C/C++) / Python
       ├── 3. If .NET (.exe/.dll) ────► dnSpy / ILSpy (100% full source decompile!)
       ├── 4. If Native (x86/x64) ────► Ghidra (Decompiler) or IDA Free
       └── 5. If Dynamic Debugging ───► x64dbg (Windows) or GDB (Linux)
```

#### Step 1: The 1-Minute Win (Strings)
Often beginners CTF challenges store the secret flag or password directly as a string or hardcoded comparison:
```powershell
# Windows PowerShell
Get-FileStrings target.exe | Select-String -Pattern "flag{"
Get-FileStrings target.exe | Select-String -Pattern "password"
Get-FileStrings target.exe | Select-String -Pattern "correct"
Get-FileStrings target.exe | Select-String -Pattern "wrong"
```

#### Step 2: Check If It Is A .NET Application (C# / VB.NET)
Almost 50% of Windows CTF challenges are written in C# / .NET.
- **How to tell**: Open in HxD and search for `BSJB` or `.NET Framework`, or inspect with `file`.
- **Tool to use**: **dnSpy** or **ILSpy**.
- **Action**: Drag the `.exe` into dnSpy. It instantly reconstructs the complete original C# source code! Look for the `BtnSubmit_Click` or `VerifyPassword` function to read the exact logic.

#### Step 3: Decompiling Native Binaries with Ghidra
For C/C++ x86/x64 Windows `.exe` or Linux ELF:
1. Open **Ghidra**. Create a project (`File -> New Project`).
2. Drag the binary into the project, double-click to open in **CodeBrowser**.
3. When prompted: "Analyze now?", click **Yes** with default analyzers.
4. In the **Symbol Tree** on the left:
   - Expand `Functions`.
   - Click on `main` or `entry`.
5. Look at the **Decompiler** window on the right:
   - Ghidra turns assembly back into readable pseudo-C code!
   - Trace variables: check `strcmp`, `strncmp`, XOR loops, or math checks.
6. Check defined strings:
   - In menu: `Window -> Defined Strings`.
   - Filter by "flag", "key", or "token". Double click any string to jump directly to where it is referenced in the code!

#### Step 4: Python Bytecode / Packaged `.exe` (PyInstaller)
If the binary was made in Python:
1. Extract `.pyc` files using `pyinstxtractor.py`:
   ```powershell
   python pyinstxtractor.py target.exe
   ```
2. Decompile the extracted `.pyc` back to `.py`:
   ```powershell
   decompyle++ target.pyc
   # Or using online decompiler: https://pycdc.vercel.app/
   ```

---

## 7. Scenario F: Web Application Exploitation & Portals

### Situation
You are given a target URL, web server, internal suspect portal, or admin login page.

### 5-Step Web Assessment

```
[Target URL]
       │
       ├── 1. Browser Recon ────────► Ctrl+U (Source), F12 (Cookies/Storage/Network)
       ├── 2. Hidden Pages/Files ───► robots.txt, sitemap.xml, /admin, .git/
       ├── 3. Directory Brute-Force ─► gobuster dir / dirb
       ├── 4. Auth & Input Testing ─► SQL Injection, IDOR, Parameter Tampering
       └── 5. Traffic Interception ──► Burp Suite Community
```

#### Step 1: The Quick Inspect (Ctrl+U & F12)
1. **View Source (Ctrl+U)**: Look for HTML comments (`<!-- TODO: flag in /secret_backup -->`), developer test notes, and hardcoded JavaScript keys.
2. **F12 Developer Tools**:
   - **Application / Storage tab**: Check `Cookies`, `Local Storage`, `Session Storage`. Is there an `admin=false`, `role=user`, or a base64 JWT?
   - **Network tab**: Look at responses from fetch/XHR calls for hidden JSON fields not rendered in the UI.
   - **Sources tab**: Read linked JavaScript files (e.g. `main.js`, `auth.js`). Check client-side validation logic.

#### Step 2: Secret Paths & Common Endpoints
Manually check these in the browser address bar:
- `/robots.txt`
- `/sitemap.xml`
- `/.git/` or `/.git/HEAD` (If accessible, whole source can be dumped with `git-dumper`!)
- `/.env` (Leaked API keys and passwords)
- `/admin`, `/login`, `/console`, `/dashboard`
- `/backup.zip`, `/backup.sql`, `/test.php`

#### Step 3: Directory Enumeration with Gobuster / Dirb
```powershell
# Using gobuster (if available)
gobuster dir -u http://challenge.iitd.ac/ -w wordlist.txt -x php,html,txt,json,bak

# Using dirb (Linux/macOS)
dirb http://challenge.iitd.ac/

# Using Python requests (No-Tool fallback)
python -c "
import requests
words = ['admin', 'robots.txt', '.git', 'backup', 'api', 'flag', 'secret']
for w in words:
    url = f'http://challenge-url/{w}'
    r = requests.get(url)
    if r.status_code != 404:
        print(f'[{r.status_code}] {url}')
"
```

#### Step 4: Common Web Vulnerabilities & Payloads

##### 1. SQL Injection (SQLi)
Try in username/password fields and search bars:
```sql
' OR 1=1 --
' OR '1'='1
admin' --
admin' #
' UNION SELECT null, username, password FROM users --
```
Automated exploitation with **sqlmap**:
```powershell
sqlmap -u "http://target.com/item.php?id=1" --batch --dbs
sqlmap -u "http://target.com/item.php?id=1" -D database_name --tables
sqlmap -u "http://target.com/item.php?id=1" -D database_name -T users --dump
```

##### 2. Local File Inclusion (LFI)
If the URL has `?page=about.php` or `?file=report.pdf`:
```
http://target/index.php?page=../../../../etc/passwd
http://target/index.php?page=../../../../flag.txt
http://target/index.php?page=php://filter/convert.base64-encode/resource=index.php
```

##### 3. Command Injection
If the page pings an IP or generates a report:
```
127.0.0.1; whoami
127.0.0.1 && cat /flag*
127.0.0.1 | type flag.txt
$(cat flag.txt)
```

---

## 8. Scenario G: The "Victim's Computer" Digital Murder Mystery Investigation

### The Carson City Context
According to the official **Flag Hunters 2026 Rulebook**:
> *"The Finals are a digital murder mystery... Your team gets access to the victim's computer, plus resources to guide the way. Solve challenges, find flags. More flags, more story."*

This is the central arena of the competition! Here is how to systematically hunt for clues and flags on the victim's machine:

```
[Victim's Workstation]
       │
       ├── 1. PowerShell & Command History
       ├── 2. Browser History, Downloads & Cache
       ├── 3. User Directories, Hidden Files & Recycle Bin
       ├── 4. System Logs & Recently Opened Files
       ├── 5. Registry Clues & Autoruns
       └── 6. Visual Novel Dialogue & Hidden Triggers
```

#### Investigation Tactic 1: Check PowerShell History & Commands
Suspects or victims often leave executed commands in the PowerShell command history file:
```powershell
# Read PSReadLine console history directly
Get-Content "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

# Check standard command history in current session
Get-History
```

#### Investigation Tactic 2: Browser Forensics (Chrome / Edge / Firefox)
Check what the victim was looking at right before the incident:
- **Paths**:
  - Chrome: `%LOCALAPPDATA%\Google\Chrome\User Data\Default\`
  - Edge: `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\`
- **Files of interest**:
  - `History` (SQLite database containing URLs and visit times)
  - `Bookmarks` (JSON file)
  - `Login Data` (SQLite database with saved credentials)
  - `Downloads` (Record of files saved)
- **Quick extraction command**:
  ```powershell
  # Copy History file to avoid locking issues
  Copy-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History" ".\ChromeHistory.db"
  # Read strings from history
  Get-FileStrings ".\ChromeHistory.db" | Select-String "http"
  ```

#### Investigation Tactic 3: Hidden Files, User Profiles & Recycle Bin
```powershell
# Find all hidden files on the Desktop and Documents
Get-ChildItem -Path "$env:USERPROFILE" -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Attributes -match "Hidden" }

# Inspect Recycle Bin contents
Get-ChildItem -Path 'C:\$Recycle.Bin' -Recurse -Force -ErrorAction SilentlyContinue

# Search entire user folder for flag files or recent .txt/.png/.pdf/.zip
Get-ChildItem -Path "$env:USERPROFILE" -Include *.txt,*.png,*.jpg,*.pdf,*.zip,*.pcap -Recurse -ErrorAction SilentlyContinue | Select-Object FullName, LastWriteTime
```

#### Investigation Tactic 4: Jump Lists, LNK Files & Recent Files
Windows tracks every file the victim opened in `.lnk` shortcut files:
```powershell
# Inspect Recent folder
Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Recent" | Select-Object Name, LastWriteTime
```

#### Investigation Tactic 5: Sysinternals Suite Inspection
1. **Autoruns**: Run `Sysinternals\Autoruns.exe` to see programs scheduled to run at startup (trojans, hidden scripts, persistence).
2. **Process Explorer**: Run `Sysinternals\procexp.exe` to inspect running processes, hidden parent-child processes, and open file handles.

#### Investigation Tactic 6: Visual Novel Interface Clues & Side Quests
The rulebook states:
> *"The Visual Novel: Dialogue options and choose-your-own-adventure scenes... Side Quests: Achievements and minigames are hidden throughout."*
- **Click everything**: Test dialogue options; re-read characters' statements for inconsistencies or passwords.
- **Inspect the game files**: If the visual novel runs locally (e.g. Ren'Py, Electron, Unity, or HTML/JS):
  - **Ren'Py**: Check `game/` folder for `.rpy` scripts or extract `.rpa` archives using `unrpa`.
  - **Electron / Web-based**: Check `resources/app.asar` (extract with `npx asar extract app.asar ./decompiled`).
  - **Unity**: Use `AssetStudio` to view images, dialogue text, and hidden textures.

---

## 9. Scenario H: Memory & Disk Forensics (.raw / .dmp / .img)

### Situation
You are given a raw RAM dump (`memory.raw`, `mem.dmp`) or a disk image (`evidence.dd`, `disk.img`).

#### RAM Analysis with Volatility 3
```powershell
# 1. List running processes at time of capture
vol.py -f memory.raw windows.pslist
vol.py -f memory.raw windows.pstree

# 2. View executed command lines
vol.py -f memory.raw windows.cmdline

# 3. View network connections
vol.py -f memory.raw windows.netscan

# 4. Dump suspicious process memory
vol.py -f memory.raw -o ./dump windows.memmap --pid <PID> --dump

# 5. Extract passwords / NTLM hashes from memory
vol.py -f memory.raw windows.hashdump
```

#### Fast String Scraping on Memory Dumps
Even without Volatility configured, a raw memory dump can be searched directly:
```powershell
# Extract strings and grep for flag
Get-FileStrings memory.raw | Select-String -Pattern "flag\{"
Get-FileStrings memory.raw | Select-String -Pattern "Password"
```

---

## 10. Scenario I: Python Automation & Rapid Exploitation Recipes

Keep these copy-paste templates ready during the competition:

### 1. Fast Flag Pattern Extractor
Run this script in any directory to search through all files:
```python
import os, re

flag_pattern = re.compile(r"flag\{[A-Za-z0-9_]+\}")

for root, _, files in os.walk("."):
    for file in files:
        filepath = os.path.join(root, file)
        try:
            with open(filepath, "rb") as f:
                content = f.read().decode("latin-1")
                matches = flag_pattern.findall(content)
                for m in matches:
                    print(f"[FOUND] {m} in {filepath}")
        except Exception:
            pass
```

### 2. XOR Decryption with Known Key or Brute-Force Single Byte
```python
def xor_bytes(data: bytes, key: bytes) -> bytes:
    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data))

# Brute-force single byte XOR looking for "flag{"
ciphertext = bytes.fromhex("...")
for k in range(256):
    dec = bytes(b ^ k for b in ciphertext)
    if b"flag{" in dec:
        print(f"Key {hex(k)}: {dec}")
```

### 3. Interacting with Netcat / TCP Challenge Sockets (pwntools)
```python
from pwn import *

# Connect to organizer's server
io = remote("challenge.iitd.ac", 1337)

# Receive prompt
prompt = io.recvline()
print(prompt)

# Send response
io.sendline(b"my_answer")

# Get interactive shell / final flag
io.interactive()
```

### 4. Fast HTTP Brute-Force / Parameter Fuzzing
```python
import requests

url = "http://challenge-target/login"

with open("passwords.txt", "r") as f:
    for line in f:
        password = line.strip()
        data = {"username": "admin", "password": password}
        r = requests.post(url, data=data)
        if "Invalid password" not in r.text:
            print(f"[!] Cracked password: {password}")
            print(r.text)
            break
```

---

## 11. Emergency Troubleshooting & Fallbacks

| Problem / Roadblock | Immediate Fix / Workaround |
| :--- | :--- |
| **No Admin Rights on Workstation** | Run `.\setup-windows-portable.ps1`. All tools install into `$HOME\CTF-Tools` without requiring UAC/Admin! |
| **Wireshark GUI won't open** | Use `tshark -r file.pcap` or upload to an online pcap analyzer (`Apacket.com` / `PacketTotal`). |
| **Ghidra is taking too long to analyze** | Use `strings` first. If still stuck, decompile on Godbolt (`https://godbolt.org/`) or Dogbolt (`https://dogbolt.org/`). |
| **Steghide asks for passphrase** | Check challenge description, victim's notes, or dialogue in the visual novel. Try blank password (Enter). |
| **Python package missing** | Run: `pip install <package> --user` or use the portable Python: `~\CTF-Tools\tools\python\python.exe -m pip install <package>`. |
| **Internet tool needed but offline** | Use CyberChef locally (download the standalone `index.html` from CyberChef GitHub repository). |
| **Team is completely stuck** | You have **3 hints per problem**! Discuss with team for 10 minutes, ask an LLM (ChatGPT / Claude / Gemini), then claim hint 1. |

---

*Authored for the Flag Hunters 2026 Finals Team — IIT Delhi - Abu Dhabi*  
*Happy Flag Hunting! 🏴🎯*
