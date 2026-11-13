# 🏁 Flag Hunters CTF 2026 - Finals Operations & Toolkit Hub

> **Competition**: Flag Hunters CTF 2026 (AFKAR — IIT Delhi - Abu Dhabi)  
> **Finals Date**: November 13, 2026  
> **Venue**: IIT Delhi - Abu Dhabi Campus  
> **Format**: Digital Murder Mystery (Investigation into Carson City Case FH-2026)  
> **Target Platform**: Windows PCs provided on-site (Portable / No Admin setup supported)

---

## 📚 Essential Playbooks & Documentation

| Document | Purpose |
| :--- | :--- |
| 📖 [**FINALS-TOOL-AND-SCENARIO-PLAYBOOK.md**](./FINALS-TOOL-AND-SCENARIO-PLAYBOOK.md) | **★ MUST-READ FOR FINALS**: Complete scenario-by-scenario guide explaining *which software and command to use for every situation* (Steganography, Forensics, Victim's PC investigation, PCAP, Reversing, Web, Crypto). |
| 🚀 [**FINALS-QUICK-START.md**](./FINALS-QUICK-START.md) | First 5-minute arrival checklist, team organization, rules reminder, and immediate browser tabs to open. |
| 🛠️ [**TOOLKIT_README.md**](./TOOLKIT_README.md) | Detailed breakdown of installed tools, portable binaries, and online fallback links. |

---

## ⚡ Quick Start: 3 Steps on Arrival

```powershell
# 1. Clone this repository to Desktop
cd $env:USERPROFILE\Desktop
git clone https://github.com/sreesh-codes/CTF-2026.git
cd CTF-2026

# 2. Run Portable Tool Installer (NO ADMIN RIGHTS REQUIRED)
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup-windows-portable.ps1

# 3. Load Helper Functions into PowerShell
cd $env:USERPROFILE\CTF-Tools
. .\scripts\ctf-helpers.ps1
```

---

## 🎯 Quick Scenario Cheat Sheet

- **Have an unknown file or corrupt binary?** -> Use `HxD` or `file`, run `Get-FileStrings`, or carve with `7z x`.
- **Have an image with secret text/data?** -> Inspect with `exiftool`, analyze bit planes in `stegsolve`, or extract with `steghide extract -sf <file>`.
- **Have a network capture (`.pcap`)?** -> Open in `wireshark`, filter by `http` or `dns`, export objects via `File -> Export Objects -> HTTP`.
- **Have an executable (`.exe` / ELF)?** -> Decompile .NET apps with `dnSpy`, native binaries with `Ghidra`, or scan strings with `Find-Flag`.
- **Investigating the Victim's PC?** -> Check `%APPDATA%\...\ConsoleHost_history.txt`, browser SQLite history, Recent jump lists, and hidden files.
- **Have a mystery cipher or hash?** -> Paste into `CyberChef` (try "Magic" recipe) and query `CrackStation`.

👉 **For exact syntax, command line flags, and step-by-step problem workflows, see [FINALS-TOOL-AND-SCENARIO-PLAYBOOK.md](./FINALS-TOOL-AND-SCENARIO-PLAYBOOK.md).**
