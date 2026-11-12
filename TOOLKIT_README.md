# Flag Hunters 2026 - CTF Toolkit

**Competition**: Flag Hunters CTF 2026
**Venue**: IIT Delhi - Abu Dhabi
**Finals Date**: 13 NOV 2026
**Duration**: 4-6 hours
**Format**: Digital murder mystery, real-world attack scenarios

---

## 📋 Table of Contents
- [Essential Tools (Install Required)](#essential-tools-install-required)
- [Online Resources & Websites](#online-resources--websites)
- [Installation Scripts](#installation-scripts)
- [Quick Reference](#quick-reference)

---

## 🛠️ Essential Tools (Install Required)

### Network Analysis & Forensics
- **Wireshark** - Network protocol analyzer for packet inspection and traffic analysis
- **tshark** - Command-line version of Wireshark
- **tcpdump** - Packet capture and network traffic dumping
- **nmap** - Network discovery and security auditing

### Reverse Engineering & Binary Analysis
- **Ghidra** - NSA's reverse engineering framework
- **radare2** - Command-line reverse engineering framework
- **binwalk** - Firmware analysis and extraction tool
- **strings** - Extract printable strings from binaries
- **file** - Identify file types
- **hexdump/xxd** - Hex viewers

### Cryptography & Encoding
- **John the Ripper** - Password cracking tool
- **hashcat** - Advanced password recovery
- **openssl** - Cryptography toolkit
- **base64** - Base64 encoding/decoding utilities

### Steganography
- **steghide** - Hide/extract data in images and audio
- **stegsolve** - Image steganography analysis
- **exiftool** - Read/write metadata in files
- **zsteg** - PNG/BMP steganography detection
- **binwalk** - Extract hidden files from images

### Forensics & Data Recovery
- **autopsy** - Digital forensics platform
- **foremost** - File carving and recovery
- **volatility** - Memory forensics framework
- **bulk_extractor** - Extract features from disk images

### Web Exploitation
- **curl** - Command-line HTTP client
- **wget** - File retrieval tool
- **Burp Suite Community** - Web security testing
- **sqlmap** - SQL injection detection/exploitation
- **nikto** - Web server scanner
- **dirb/dirbuster** - Web content scanner
- **gobuster** - Directory/file brute-forcing

### Programming & Scripting
- **Python 3** (with pip)
  - pwntools - CTF framework
  - requests - HTTP library
  - beautifulsoup4 - Web scraping
  - pycryptodome - Cryptography
  - scapy - Packet manipulation
  - pillow - Image processing
- **Node.js & npm**
- **git** - Version control

### General Utilities
- **7zip/p7zip** - Archive extraction
- **unzip/unrar** - Archive tools
- **jq** - JSON processor
- **grep/ripgrep** - Text searching
- **vim/nano** - Text editors
- **tmux/screen** - Terminal multiplexers

### Analysis & Debugging
- **gdb** - GNU Debugger
- **strace** - System call tracer
- **ltrace** - Library call tracer
- **objdump** - Object file dumper

---

## 🌐 Online Resources & Websites

### Encoding/Decoding & Cryptography
- **CyberChef** - https://gchq.github.io/CyberChef/
  - Swiss Army knife for encoding, encryption, compression, and data analysis
- **dCode** - https://www.dcode.fr/en
  - Cipher identifier and solver
- **Base64 Decode** - https://www.base64decode.org/
- **ROT13** - https://rot13.com/
- **Hash Analyzer** - https://www.tunnelsup.com/hash-analyzer/
- **CrackStation** - https://crackstation.net/
  - Free hash lookup database

### Steganography Analysis
- **Aperi'Solve** - https://www.aperisolve.com/
  - Online image steganography analysis
- **StegOnline** - https://stegonline.georgeom.net/
  - Browser-based steganography toolkit
- **29a.ch Photo Forensics** - https://29a.ch/photo-forensics/
- **FotoForensics** - https://fotoforensics.com/

### Reverse Engineering & Malware
- **Compiler Explorer** - https://godbolt.org/
  - See assembly output from code
- **Online Disassembler** - https://onlinedisassembler.com/
- **VirusTotal** - https://www.virustotal.com/
  - File/URL malware analysis

### Web Tools
- **RequestBin** - https://requestbin.com/
  - Inspect HTTP requests
- **Webhook.site** - https://webhook.site/
  - Test webhooks and HTTP requests
- **regex101** - https://regex101.com/
  - Regular expression testing
- **JSON Formatter** - https://jsonformatter.org/

### OSINT & Forensics
- **Wayback Machine** - https://web.archive.org/
  - Historical website snapshots
- **ExifData** - https://exifdata.com/
  - Online EXIF viewer
- **DNSDumpster** - https://dnsdumpster.com/
  - DNS reconnaissance

### Challenge Platforms (Practice)
- **OverTheWire** - https://overthewire.org/wargames/
- **picoCTF** - https://picoctf.org/
- **HackTheBox** - https://www.hackthebox.com/
- **TryHackMe** - https://tryhackme.com/
- **CryptoHack** - https://cryptohack.org/

### Reference & Documentation
- **GTFOBins** - https://gtfobins.github.io/
  - Unix binaries exploitation
- **Exploit Database** - https://www.exploit-db.com/
- **CWE Database** - https://cwe.mitre.org/
- **OWASP** - https://owasp.org/

### AI Assistants (Allowed per rules)
- **ChatGPT** - https://chat.openai.com/
- **Claude** - https://claude.ai/
- **Gemini** - https://gemini.google.com/
- **Perplexity** - https://www.perplexity.ai/

---

## 💻 Installation Scripts

We've provided automated installation scripts for Windows, macOS, and Linux:

### Windows Installation (Primary - for Finals)

**OPTION 1: If you have Admin access** (run PowerShell as Administrator):
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup-windows.ps1
```

**OPTION 2: NO ADMIN ACCESS (Recommended - Portable Tools)**
Run in regular PowerShell (no admin needed):
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup-windows-portable.ps1
```

This downloads portable versions of all tools to `%USERPROFILE%\CTF-Tools` and creates helper scripts.

**Note**: Windows computers will be provided at the finals venue. If they don't give admin access, use the portable version!

### macOS Installation
```bash
chmod +x setup-macos.sh
./setup-macos.sh
```

### Linux Installation
```bash
chmod +x setup-linux.sh
./setup-linux.sh
```

**Note**: The scripts will:
- Install Chocolatey (Windows), Homebrew (macOS), or use apt/dnf (Linux)
- Install all essential CTF tools
- Set up Python packages and helper functions
- Configure necessary dependencies
- May require administrator/sudo privileges

---

## ⚡ Quick Reference

### Common Flag Format
```
flag{This_is_an_example_flag_3211000}
```
- Only letters, numbers, and underscores inside braces

### Essential Commands

**Network Analysis:**
```bash
wireshark capture.pcap              # Open in GUI
tshark -r capture.pcap              # Read pcap file
nmap -sV target.com                 # Port scan
```

**File Analysis:**
```bash
# Windows PowerShell
Get-Content file.txt                # Read file
Select-String -Path file.txt -Pattern "flag"  # Search
certutil -hashfile file.exe MD5     # Get hash

# Linux/macOS (also work on Windows with tools installed)
file suspicious_file                # Identify file type
strings suspicious_file             # Extract strings
exiftool image.jpg                  # View metadata
binwalk -e firmware.bin             # Extract embedded files
```

**Steganography:**
```bash
steghide extract -sf image.jpg      # Extract hidden data
stegsolve                           # Open GUI tool
exiftool image.jpg                  # View/modify metadata
```

**Cryptography:**
```bash
# Windows PowerShell helpers
ConvertTo-Base64 "text"             # Encode (from helper script)
ConvertFrom-Base64 "dGV4dA=="       # Decode (from helper script)

# Standard commands (all platforms)
john hash.txt                       # Crack passwords
hashcat -m 0 hash.txt wordlist.txt  # MD5 cracking
```

**Web Exploitation:**
```bash
# Windows (use Burp Suite GUI or)
Invoke-WebRequest -Uri "http://target.com"

# All platforms
curl -X GET "http://target.com"     # GET request
curl -X POST -d "param=value" url   # POST request
```

**Reverse Engineering:**
```bash
ghidra                              # Open Ghidra
strings binary | findstr flag       # Windows: Search for flags
strings binary | grep flag          # Linux/macOS: Search for flags
```

**Python Quick Scripts:**
```python
# Read file as bytes
with open('file', 'rb') as f:
    data = f.read()

# HTTP request
import requests
r = requests.get('http://target.com')

# XOR decode
result = bytes([b ^ 0x42 for b in data])

# Find flags in file
import re
with open('file', 'r') as f:
    flags = re.findall(r'flag\{[A-Za-z0-9_]+\}', f.read())
```

---

## 📝 Notes for Finals

### Important Reminders
- ✅ NO PERSONAL DEVICES - Computers provided
- ✅ Internet access allowed for research
- ✅ AI tools (ChatGPT, Claude, Gemini) permitted
- ✅ Team communication only (3-5 members)
- ⛔ No help from other teams or outsiders
- ⛔ Only attack organizer's challenge systems
- ⛔ Do NOT attack university systems

### Contact During Event
- **Email**: sc.coding@iitdabudhabi.ac.ae
- **WhatsApp**: +971 50 596 4081
- **Secretary**: Evan Johan Tobias

### Strategy Tips
1. **Read all challenges first** - Get overview before diving in
2. **Start with easy flags** - Build momentum and score points
3. **Use hints wisely** - Three hints per problem
4. **Document findings** - Keep notes on what you've tried
5. **Divide and conquer** - Split tasks among team members
6. **Check for low-hanging fruit** - View source, check robots.txt, examine metadata
7. **Follow the story** - The visual novel tracks progress and may give clues
8. **Take breaks** - Look for side quests and achievements

### Pre-Competition Checklist
- [ ] Practice on platforms like picoCTF, OverTheWire
- [ ] Familiarize yourself with CyberChef
- [ ] Review common encoding schemes (base64, hex, ROT13)
- [ ] Practice basic cryptography challenges
- [ ] Test Wireshark packet analysis
- [ ] Try basic steganography with steghide
- [ ] Review SQL injection basics
- [ ] Practice using grep/strings for flag hunting
- [ ] Set up keyboard shortcuts for common commands
- [ ] Prepare text editor with useful scripts/snippets

---

## 🏆 Competition Details

**Prize Pool:**
- 🥇 1st Place: AED 3,000
- 🥈 2nd Place: AED 2,000
- 🥉 3rd Place: AED 1,500
- 🎖️ All finalists receive certificates

**Good luck, and happy hunting! 🎯**

---

*Last Updated: November 2026*
*Repository: https://github.com/sreesh-codes/CTF-2026*
