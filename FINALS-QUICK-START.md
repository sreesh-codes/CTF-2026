# 🚀 Flag Hunters 2026 - Finals Day Quick Start

**Date**: November 13, 2026
**Location**: IIT Delhi - Abu Dhabi Campus
**Duration**: 4-6 hours
**Format**: Digital Murder Mystery

---

## ⚡ ON ARRIVAL (First 5 Minutes)

### Step 1: Get Your Computer
- You'll be provided a Windows PC
- Log in with credentials given by organizers

### Step 2: Clone the Repo
```powershell
# Open PowerShell
cd Desktop
git clone https://github.com/sreesh-codes/CTF-2026
cd CTF-2026
```

### Step 3: Install Tools (NO ADMIN NEEDED)
```powershell
# This takes 10-20 minutes, so start it immediately!
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup-windows-portable.ps1
```

**While tools download** (10-20 min), use online resources:
- Open browser tabs for key websites (see below)
- Read the visual novel introduction
- Familiarize yourself with the challenge interface

### Step 4: Load Helper Functions
After installation completes:
```powershell
cd ~\CTF-Tools
. .\scripts\ctf-helpers.ps1
```

---

## 🌐 Essential Websites to Open IMMEDIATELY

Open these in browser tabs **before you start** (you can use them while tools download):

### Primary Tools (Keep These Open)
1. **CyberChef** - https://gchq.github.io/CyberChef/
   - Your #1 tool for encoding/decoding/crypto
2. **dCode** - https://www.dcode.fr/en
   - Cipher identifier and solver
3. **Aperi'Solve** - https://www.aperisolve.com/
   - Image steganography analysis

### Quick Reference Tools
4. **Base64 Decode** - https://www.base64decode.org/
5. **CrackStation** - https://crackstation.net/ (hash lookup)
6. **StegOnline** - https://stegonline.georgeom.net/
7. **FotoForensics** - https://fotoforensics.com/
8. **regex101** - https://regex101.com/
9. **Wayback Machine** - https://web.archive.org/

### AI Assistants (Allowed!)
10. **ChatGPT** - https://chat.openai.com/
11. **Claude** - https://claude.ai/

---

## 🎯 Competition Strategy

### Team Organization (3-5 members)
1. **Leader/Coordinator** - Tracks progress, manages time, coordinates team
2. **Web/OSINT Specialist** - Handles web challenges, online research
3. **Crypto/Reversing Specialist** - Cryptography, reverse engineering
4. **Forensics Specialist** - File analysis, steganography, network traffic
5. **Wild Card** - Helps wherever needed, researches hints

### First 15 Minutes
1. ✅ **Read ALL available challenges** - Get overview
2. ✅ **Identify easy wins** - Start with low-hanging fruit
3. ✅ **Divide tasks** - Split challenges among team members
4. ✅ **Set up communication** - Decide how to share findings

### Flag Hunting Checklist (Try These First!)
- [ ] View page source (Ctrl+U in browser)
- [ ] Check robots.txt and sitemap
- [ ] Examine image metadata: `exiftool image.jpg`
- [ ] Extract strings from files: `Get-FileStrings file.exe`
- [ ] Search for flag pattern: `Find-Flag file.txt`
- [ ] Decode obvious base64/hex
- [ ] Check for hidden files in archives
- [ ] Analyze network traffic in Wireshark
- [ ] Use CyberChef for unknown encoding

### When Stuck (Use Hints Wisely)
- You get **3 hints per problem**
- Try for 10-15 minutes before using first hint
- Discuss with team before using hints
- Search online / ask AI first

### Time Management
- **First Hour**: Grab all easy flags (build momentum)
- **Hours 2-4**: Focus on medium challenges
- **Last Hour**:
  - Attempt hard challenges
  - Review all challenges again (fresh eyes)
  - Look for side quests and achievements

---

## 🛠️ Quick Command Reference

### After Loading Helper Functions

```powershell
# Open online tools
cyberchef        # Open CyberChef
dcode            # Open dCode
aperisolve       # Open Aperi'Solve

# Find flags in files
Find-Flag challenge.txt
Find-Flag binary.exe

# Extract strings
Get-FileStrings file.exe
Get-FileStrings file.exe "password"  # Search for specific text

# Base64
ConvertTo-Base64String "text"
ConvertFrom-Base64String "encoded_text"

# File hash
Get-FileHash-MD5 file.exe

# Extract archives
Extract-All challenge.zip

# Launch tools
stegsolve              # Image steganography
wireshark capture.pcap # Network analysis

# Python
python script.py
pip install package

# Steganography
steghide extract -sf image.jpg
exiftool image.jpg
```

### Without Helper Functions (Raw Commands)

```powershell
# Search in file
Select-String -Path file.txt -Pattern "flag"

# Get file hash
certutil -hashfile file.exe MD5

# Download file
Invoke-WebRequest -Uri "http://url" -OutFile "output.txt"

# HTTP POST
Invoke-WebRequest -Uri "http://url" -Method POST -Body @{key="value"}

# Encode base64
[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("text"))

# Decode base64
[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("dGV4dA=="))
```

---

## 📋 Common CTF Patterns

### Steganography
```powershell
# Check image metadata
exiftool image.jpg

# LSB steganography
stegsolve  # Then: Analyse > Data Extract

# Hidden data
steghide extract -sf image.jpg

# Strings in images
Get-FileStrings image.jpg
```

### Web Challenges
```powershell
# View source, inspect elements
# Check: cookies, local storage, JavaScript files
# Look for: comments, hidden fields, API endpoints

# Directory enumeration
# Use online tools like dirsearch or manual testing

# SQL injection
' OR '1'='1
admin' --
' UNION SELECT NULL--
```

### Cryptography
```
Common ciphers:
- Base64 (ends with = or ==)
- Hex (0-9, A-F)
- ROT13/Caesar
- XOR
- AES/RSA

Use CyberChef's "Magic" operation to auto-detect!
```

### Reverse Engineering
```powershell
# Find readable strings
Get-FileStrings binary.exe | Select-String "flag"

# Check for .NET
# Use dnSpy if available

# Decompile
# Use Ghidra (takes time to load, plan accordingly)
```

### Network Forensics (Wireshark)
```
1. Open pcap file in Wireshark
2. Check protocol hierarchy (Statistics > Protocol Hierarchy)
3. Look for HTTP traffic (http filter)
4. Follow TCP streams (right-click packet > Follow > TCP Stream)
5. Export objects (File > Export Objects > HTTP)
6. Search for strings (Edit > Find Packet, select "String")
```

---

## ⚠️ IMPORTANT REMINDERS

### Rules
- ✅ **CAN**: Use internet, AI tools, team communication
- ✅ **CAN**: Attack ONLY organizer's challenge systems
- ⛔ **CANNOT**: Help other teams or get help from outsiders
- ⛔ **CANNOT**: Attack university systems or other networks
- ⛔ **CANNOT**: Use personal devices

### Flag Format
```
flag{This_is_an_example_flag_3211000}
```
- Only letters, numbers, and underscores inside braces
- Case-sensitive!

### If You Need Help
- **Email**: sc.coding@iitdabudhabi.ac.ae
- **WhatsApp**: +971 50 596 4081
- **Contact**: Evan Johan Tobias

---

## 🏆 Winning Mindset

1. **Start Fast** - Setup immediately, grab easy flags first
2. **Communicate** - Share findings with team constantly
3. **Document** - Keep notes on what you've tried
4. **Stay Calm** - Stuck? Take a break, look at side quests
5. **Think Different** - If standard approach fails, get creative
6. **Have Fun** - Enjoy the murder mystery story!

---

## 📱 Pre-Competition Checklist

**Night Before:**
- [ ] Review this guide
- [ ] Get good sleep (stay sharp!)
- [ ] Charge devices (phone for timekeeping/notes)

**Morning Of:**
- [ ] Arrive early
- [ ] Eat breakfast (long competition!)
- [ ] Bring water/snacks if allowed
- [ ] Mental preparation

**On Arrival:**
- [ ] Find your team members
- [ ] Get computer credentials
- [ ] Clone repo immediately
- [ ] Start tool installation
- [ ] Open browser tabs

---

## 🎮 The Competition

Remember: This is a **digital murder mystery** with a visual novel interface.

- **Pay attention to the story** - Clues may be hidden in dialogue
- **Explore thoroughly** - Click everything, read everything
- **Side quests give points** - Look for achievements and minigames
- **More flags = more story** - Each flag unlocks more narrative

---

## 💡 Pro Tips

1. **CyberChef is your best friend** - When in doubt, throw it in CyberChef
2. **Strings command is underrated** - Always run it on unknown files
3. **Google error messages** - They often lead to solutions
4. **Check file extensions** - Files may be mislabeled
5. **Try common passwords** - password, admin, 123456, flag, etc.
6. **Look at file sizes** - Unusually large/small files are suspicious
7. **Hex editor everything** - Magic bytes, hidden data, file carving
8. **Follow the data** - Where does it come from? Where does it go?

---

**Good luck, team! You've got this! 🏴🎯**

*May your flags be plentiful and your hashes be crackable!*

---

*Last Updated: November 2026*
*Repository: https://github.com/sreesh-codes/CTF-2026*
