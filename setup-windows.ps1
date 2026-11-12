###############################################################################
# Flag Hunters 2026 CTF - Windows Setup Script
# This script installs all essential tools for the CTF competition
# Run in PowerShell as Administrator
###############################################################################

# Check for Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'"
    pause
    exit
}

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║     Flag Hunters 2026 - CTF Toolkit Setup (Windows)      ║" -ForegroundColor Blue
Write-Host "║              IIT Delhi - Abu Dhabi                        ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

# Set execution policy for this session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey if not already installed
Write-Host "[*] Checking for Chocolatey package manager..." -ForegroundColor Cyan
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Installing Chocolatey..." -ForegroundColor Yellow
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Host "[✓] Chocolatey installed" -ForegroundColor Green
} else {
    Write-Host "[✓] Chocolatey already installed" -ForegroundColor Green
}

# Refresh environment variables
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

Write-Host ""
Write-Host "[*] Installing CTF tools... This may take 15-30 minutes." -ForegroundColor Cyan
Write-Host ""

# Core utilities
Write-Host "[*] Installing core utilities..." -ForegroundColor Cyan
choco install -y git curl wget 7zip
choco install -y vscode  # Useful text editor
choco install -y powershell-core  # Modern PowerShell
Write-Host "[✓] Core utilities installed" -ForegroundColor Green

# Python
Write-Host "[*] Installing Python 3..." -ForegroundColor Cyan
choco install -y python3
refreshenv
Write-Host "[✓] Python 3 installed" -ForegroundColor Green

# Node.js
Write-Host "[*] Installing Node.js..." -ForegroundColor Cyan
choco install -y nodejs
Write-Host "[✓] Node.js installed" -ForegroundColor Green

# Network Analysis Tools
Write-Host "[*] Installing network analysis tools..." -ForegroundColor Cyan
choco install -y wireshark
choco install -y nmap
Write-Host "[✓] Network tools installed" -ForegroundColor Green

# Reverse Engineering Tools
Write-Host "[*] Installing reverse engineering tools..." -ForegroundColor Cyan
choco install -y ghidra
choco install -y x64dbg.portable  # Windows debugger
choco install -y dnspy  # .NET debugger/decompiler
Write-Host "[✓] Reverse engineering tools installed" -ForegroundColor Green

# Cryptography Tools
Write-Host "[*] Installing cryptography tools..." -ForegroundColor Cyan
choco install -y hashcat
# John the Ripper
choco install -y john-the-ripper
Write-Host "[✓] Cryptography tools installed" -ForegroundColor Green

# Forensics & Steganography
Write-Host "[*] Installing forensics tools..." -ForegroundColor Cyan
choco install -y exiftool
# Download additional steganography tools
$ctfToolsDir = "$env:USERPROFILE\ctf-tools"
if (!(Test-Path $ctfToolsDir)) {
    New-Item -ItemType Directory -Path $ctfToolsDir | Out-Null
}
Write-Host "[✓] Forensics tools installed" -ForegroundColor Green

# Web Tools
Write-Host "[*] Installing web exploitation tools..." -ForegroundColor Cyan
choco install -y burp-suite-free-edition
choco install -y fiddler
Write-Host "[✓] Web tools installed" -ForegroundColor Green

# Archive Tools
Write-Host "[*] Archive tools (7zip already installed)" -ForegroundColor Cyan
Write-Host "[✓] Archive tools ready" -ForegroundColor Green

# Text processing
Write-Host "[*] Installing utilities..." -ForegroundColor Cyan
choco install -y jq
choco install -y ripgrep
choco install -y grep
choco install -y sysinternals  # Windows Sysinternals Suite
Write-Host "[✓] Utilities installed" -ForegroundColor Green

# HxD Hex Editor
Write-Host "[*] Installing HxD hex editor..." -ForegroundColor Cyan
choco install -y hxd
Write-Host "[✓] HxD installed" -ForegroundColor Green

# Install Python packages
Write-Host "[*] Installing Python CTF packages..." -ForegroundColor Cyan
refreshenv
python -m pip install --upgrade pip
pip install pwntools requests beautifulsoup4 pycryptodome scapy pillow pefile pyinstaller
Write-Host "[✓] Python packages installed" -ForegroundColor Green

# Download additional tools
Write-Host "[*] Downloading additional tools..." -ForegroundColor Cyan

# Stegsolve
$stegsolvePath = "$ctfToolsDir\stegsolve.jar"
if (!(Test-Path $stegsolvePath)) {
    Write-Host "  - Downloading Stegsolve..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "http://www.caesum.com/handbook/Stegsolve.jar" -OutFile $stegsolvePath
    Write-Host "  [✓] Stegsolve downloaded" -ForegroundColor Green
}

# Download rockyou wordlist
$wordlistDir = "$env:USERPROFILE\ctf-wordlists"
if (!(Test-Path $wordlistDir)) {
    New-Item -ItemType Directory -Path $wordlistDir | Out-Null
}

if (!(Test-Path "$wordlistDir\rockyou.txt")) {
    Write-Host "  - Downloading rockyou.txt wordlist (may take a while)..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt" -OutFile "$wordlistDir\rockyou.txt"
    Write-Host "  [✓] Rockyou wordlist downloaded" -ForegroundColor Green
}

Write-Host "[✓] Additional tools downloaded" -ForegroundColor Green

# Create helper batch files and PowerShell profile additions
Write-Host "[*] Creating helper scripts..." -ForegroundColor Cyan

# Create batch file for stegsolve
$stegsolveBat = "$ctfToolsDir\stegsolve.bat"
@"
@echo off
java -jar "$stegsolvePath"
"@ | Out-File -FilePath $stegsolveBat -Encoding ASCII

# Create PowerShell helper functions
$helperScript = "$ctfToolsDir\ctf-helpers.ps1"
@"
# CTF Helper Functions for Windows

function Find-Flag {
    param([string]`$FilePath)
    if (-not `$FilePath) {
        Write-Host "Usage: Find-Flag <file>"
        return
    }
    Select-String -Path `$FilePath -Pattern "flag\{" -CaseSensitive:$false
}

function Invoke-Stegsolve {
    java -jar "$stegsolvePath"
}

function Invoke-CyberChef {
    Start-Process "https://gchq.github.io/CyberChef/"
}

function Extract-Archive {
    param([string]`$FilePath)
    if (-not `$FilePath) {
        Write-Host "Usage: Extract-Archive <file>"
        return
    }
    `$ext = [System.IO.Path]::GetExtension(`$FilePath)
    switch (`$ext) {
        {`$_ -in '.zip','.7z','.rar','.tar','.gz'} {
            7z x `$FilePath
        }
        default {
            Write-Host "Unknown archive format: `$ext"
        }
    }
}

function ConvertFrom-Base64 {
    param([string]`$EncodedString)
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$EncodedString))
}

function ConvertTo-Base64 {
    param([string]`$String)
    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(`$String))
}

# Aliases
Set-Alias -Name findflag -Value Find-Flag
Set-Alias -Name stegsolve -Value Invoke-Stegsolve
Set-Alias -Name cyberchef -Value Invoke-CyberChef
Set-Alias -Name extract -Value Extract-Archive
Set-Alias -Name base64d -Value ConvertFrom-Base64
Set-Alias -Name base64e -Value ConvertTo-Base64

Write-Host "CTF Helper functions loaded!" -ForegroundColor Green
Write-Host "Available commands: Find-Flag, Invoke-Stegsolve, Invoke-CyberChef, Extract-Archive" -ForegroundColor Cyan
"@ | Out-File -FilePath $helperScript -Encoding UTF8

Write-Host "[✓] Helper scripts created" -ForegroundColor Green

# Add to PATH
Write-Host "[*] Adding CTF tools to PATH..." -ForegroundColor Cyan
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$ctfToolsDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$ctfToolsDir", "User")
    Write-Host "[✓] Added to PATH" -ForegroundColor Green
} else {
    Write-Host "[✓] Already in PATH" -ForegroundColor Green
}

# Create desktop shortcuts
Write-Host "[*] Creating desktop shortcuts..." -ForegroundColor Cyan
$desktopPath = [Environment]::GetFolderPath("Desktop")

# Create CTF Tools folder shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$desktopPath\CTF Tools.lnk")
$Shortcut.TargetPath = $ctfToolsDir
$Shortcut.Save()

Write-Host "[✓] Desktop shortcuts created" -ForegroundColor Green

# Refresh environment
refreshenv

# Final summary
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          Installation Complete! ✓                         ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Installed Tools Summary:" -ForegroundColor Blue
Write-Host "  • Network: Wireshark, nmap" -ForegroundColor White
Write-Host "  • Reverse Engineering: Ghidra, x64dbg, dnSpy" -ForegroundColor White
Write-Host "  • Cryptography: John the Ripper, hashcat" -ForegroundColor White
Write-Host "  • Steganography: stegsolve, exiftool" -ForegroundColor White
Write-Host "  • Forensics: Sysinternals Suite, exiftool" -ForegroundColor White
Write-Host "  • Web: Burp Suite, Fiddler" -ForegroundColor White
Write-Host "  • Hex Editor: HxD" -ForegroundColor White
Write-Host "  • Programming: Python 3, Node.js" -ForegroundColor White
Write-Host "  • Python packages: pwntools, requests, scapy, and more" -ForegroundColor White
Write-Host ""
Write-Host "Tool Locations:" -ForegroundColor Yellow
Write-Host "  • CTF Tools folder: $ctfToolsDir" -ForegroundColor White
Write-Host "  • Wordlists: $wordlistDir" -ForegroundColor White
Write-Host "  • Desktop shortcut created" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Close and reopen PowerShell to refresh environment variables" -ForegroundColor White
Write-Host ""
Write-Host "  2. Load helper functions in PowerShell:" -ForegroundColor White
Write-Host "     . $helperScript" -ForegroundColor Cyan
Write-Host ""
Write-Host "  3. To auto-load helpers, add to your PowerShell profile:" -ForegroundColor White
Write-Host "     echo '. $helperScript' >> `$PROFILE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  4. Test installations:" -ForegroundColor White
Write-Host "     python --version" -ForegroundColor Cyan
Write-Host "     wireshark --version" -ForegroundColor Cyan
Write-Host "     ghidra" -ForegroundColor Cyan
Write-Host ""
Write-Host "  5. Review TOOLKIT_README.md for online resources and usage" -ForegroundColor White
Write-Host ""
Write-Host "Additional Manual Downloads (if needed):" -ForegroundColor Yellow
Write-Host "  • Autopsy: https://www.autopsy.com/download/" -ForegroundColor White
Write-Host "  • Volatility: https://www.volatilityfoundation.org/releases" -ForegroundColor White
Write-Host "  • SQLMap: https://sqlmap.org/" -ForegroundColor White
Write-Host ""
Write-Host "Good luck at Flag Hunters 2026! 🏴" -ForegroundColor Green
Write-Host ""

pause
