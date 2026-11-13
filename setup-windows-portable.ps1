###############################################################################
# Flag Hunters 2026 CTF - Windows Portable Setup Script (NO ADMIN REQUIRED)
# This script downloads portable/standalone versions of tools
# Run in regular PowerShell (no admin needed)
###############################################################################

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║   Flag Hunters 2026 - Portable Toolkit (No Admin)        ║" -ForegroundColor Blue
Write-Host "║              IIT Delhi - Abu Dhabi                        ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""
Write-Host "[!] This script installs portable tools WITHOUT admin rights" -ForegroundColor Yellow
Write-Host ""

# Create base directory
$baseDir = "$env:USERPROFILE\CTF-Tools"
$toolsDir = "$baseDir\tools"
$scriptsDir = "$baseDir\scripts"
$wordlistsDir = "$baseDir\wordlists"

Write-Host "[*] Creating directories..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null
New-Item -ItemType Directory -Force -Path $scriptsDir | Out-Null
New-Item -ItemType Directory -Force -Path $wordlistsDir | Out-Null
Write-Host "[✓] Directories created at $baseDir" -ForegroundColor Green

# Function to download files
function Download-File {
    param([string]$Url, [string]$Output)
    Write-Host "  Downloading $(Split-Path $Output -Leaf)..." -ForegroundColor Cyan
    try {
        if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
            & curl.exe -s -L "$Url" -o "$Output"
            if ((Test-Path "$Output") -and ((Get-Item "$Output").Length -gt 1000)) {
                Write-Host "  [✓] Downloaded successfully" -ForegroundColor Green
                return $true
            }
        }
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls13
        Invoke-WebRequest -Uri $Url -OutFile $Output -UseBasicParsing -MaximumRedirection 10 -UserAgent "Mozilla/5.0"
        if ((Test-Path "$Output") -and ((Get-Item "$Output").Length -gt 1000)) {
            Write-Host "  [✓] Downloaded successfully" -ForegroundColor Green
            return $true
        }
        throw "Downloaded file is empty or invalid"
    } catch {
        Write-Host "  [✗] Failed: $_" -ForegroundColor Red
        return $false
    }
}

# Function to extract zip
function Extract-Archive {
    param([string]$ZipFile, [string]$Destination)
    Write-Host "  Extracting..." -ForegroundColor Cyan
    Expand-Archive -Path $ZipFile -DestinationPath $Destination -Force
    Remove-Item $ZipFile
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║  DOWNLOADING PORTABLE TOOLS (this may take 10-20 minutes) ║" -ForegroundColor Yellow
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""

# 1. Python Portable
Write-Host "[1/12] Python Portable..." -ForegroundColor Cyan
if (Download-File "https://www.python.org/ftp/python/3.11.6/python-3.11.6-embed-amd64.zip" "$toolsDir\python.zip") {
    Extract-Archive "$toolsDir\python.zip" "$toolsDir\python"
    # Get pip
    Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "$toolsDir\python\get-pip.py"
    # Enable pip in python
    $pthFile = Get-ChildItem "$toolsDir\python\*._pth" | Select-Object -First 1
    (Get-Content $pthFile.FullName) -replace '#import site', 'import site' | Set-Content $pthFile.FullName
}

# 2. 7-Zip Portable
Write-Host "[2/12] 7-Zip Portable..." -ForegroundColor Cyan
if (Download-File "https://www.7-zip.org/a/7za920.zip" "$toolsDir\7za.zip") {
    New-Item -ItemType Directory -Force -Path "$toolsDir\7zip" | Out-Null
    Expand-Archive -Path "$toolsDir\7za.zip" -DestinationPath "$toolsDir\7zip" -Force
    Copy-Item "$toolsDir\7zip\7za.exe" "$toolsDir\7zip\7z.exe" -Force -ErrorAction SilentlyContinue
    Remove-Item "$toolsDir\7za.zip" -Force -ErrorAction SilentlyContinue
}

# 3. Wireshark Portable
Write-Host "[3/12] Wireshark Portable..." -ForegroundColor Cyan
Download-File "https://www.wireshark.org/download/win64/all-versions/WiresharkPortable64_4.4.0.paf.exe" "$toolsDir\WiresharkPortable.exe"

# 4. Hex Editor Portable (HxD with Frhed fallback)
Write-Host "[4/12] Hex Editor Portable..." -ForegroundColor Cyan
$hxdOk = Download-File "https://mh-nexus.de/downloads/HxDSetup.zip" "$toolsDir\hxd.zip"
if ($hxdOk) {
    Extract-Archive "$toolsDir\hxd.zip" "$toolsDir\HxD"
} else {
    Write-Host "  [!] HxD host down, downloading Frhed Portable Hex Editor..." -ForegroundColor Yellow
    if (Download-File "https://github.com/WinMerge/frhed/releases/download/0.10904.2017/frhed-0.10904.2017.22-x64.zip" "$toolsDir\frhed.zip") {
        Extract-Archive "$toolsDir\frhed.zip" "$toolsDir\HxD"
    }
}

# 5. Sysinternals Suite
Write-Host "[5/12] Sysinternals Suite..." -ForegroundColor Cyan
if (Download-File "https://download.sysinternals.com/files/SysinternalsSuite.zip" "$toolsDir\sysinternals.zip") {
    Extract-Archive "$toolsDir\sysinternals.zip" "$toolsDir\Sysinternals"
}

# 6. Notepad++ Portable
Write-Host "[6/12] Notepad++ Portable..." -ForegroundColor Cyan
Download-File "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6/npp.8.6.portable.x64.zip" "$toolsDir\npp.zip"
if (Test-Path "$toolsDir\npp.zip") {
    Extract-Archive "$toolsDir\npp.zip" "$toolsDir\Notepad++"
}

# 7. ExifTool
Write-Host "[7/12] ExifTool..." -ForegroundColor Cyan
if (Download-File "https://downloads.sourceforge.net/project/exiftool/exiftool-13.63_64.zip" "$toolsDir\exiftool.zip") {
    Extract-Archive "$toolsDir\exiftool.zip" "$toolsDir\exiftool"
    $exifExe = Get-ChildItem -Path "$toolsDir\exiftool" -Recurse -Filter "*exiftool*.exe" | Select-Object -First 1
    if ($exifExe) {
        Copy-Item $exifExe.FullName "$toolsDir\exiftool\exiftool.exe" -Force -ErrorAction SilentlyContinue
    }
}

# 8. Stegsolve
Write-Host "[8/12] Stegsolve..." -ForegroundColor Cyan
Download-File "https://github.com/Giotino/stegsolve/releases/download/v1.4/StegSolve-1.4.jar" "$toolsDir\stegsolve.jar"

# 9. JDK (for running Java tools like Stegsolve, Ghidra)
Write-Host "[9/12] OpenJDK Portable..." -ForegroundColor Cyan
if (Download-File "https://download.java.net/java/GA/jdk21/fd2272bbf8e04c3dbaee13770090416c/35/GPL/openjdk-21_windows-x64_bin.zip" "$toolsDir\jdk.zip") {
    Extract-Archive "$toolsDir\jdk.zip" "$toolsDir"
    $jdkFolder = Get-ChildItem "$toolsDir\jdk-*" | Select-Object -First 1
    if ($jdkFolder) {
        Rename-Item $jdkFolder.FullName "$toolsDir\jdk" -ErrorAction SilentlyContinue
    }
}

# 10. Steghide (compile or pre-built)
Write-Host "[10/12] Steghide..." -ForegroundColor Cyan
# Download pre-compiled version
Download-File "http://downloads.sourceforge.net/project/steghide/steghide/0.5.1/steghide-0.5.1-win32.zip" "$toolsDir\steghide.zip"
if (Test-Path "$toolsDir\steghide.zip") {
    Extract-Archive "$toolsDir\steghide.zip" "$toolsDir\steghide"
    $shExe = Get-ChildItem -Path "$toolsDir\steghide" -Recurse -Filter "steghide.exe" | Select-Object -First 1
    if ($shExe -and ($shExe.DirectoryName -ne "$toolsDir\steghide")) {
        Copy-Item "$($shExe.DirectoryName)\*" "$toolsDir\steghide\" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 11. Node.js Portable
Write-Host "[11/12] Node.js Portable..." -ForegroundColor Cyan
if (Download-File "https://nodejs.org/dist/v20.10.0/node-v20.10.0-win-x64.zip" "$toolsDir\nodejs.zip") {
    Extract-Archive "$toolsDir\nodejs.zip" "$toolsDir"
    $nodeFolder = Get-ChildItem "$toolsDir\node-*" | Select-Object -First 1
    if ($nodeFolder) {
        Rename-Item $nodeFolder.FullName "$toolsDir\nodejs" -ErrorAction SilentlyContinue
    }
}

# 12. Hashcat Portable
Write-Host "[12/12] Hashcat..." -ForegroundColor Cyan
if (Download-File "https://hashcat.net/files/hashcat-6.2.6.7z" "$toolsDir\hashcat.7z") {
    if (Test-Path "$toolsDir\7zip\7z.exe") {
        & "$toolsDir\7zip\7z.exe" x "$toolsDir\hashcat.7z" -o"$toolsDir" -y
        Remove-Item "$toolsDir\hashcat.7z"
        $hashcatFolder = Get-ChildItem "$toolsDir\hashcat-*" | Select-Object -First 1
        if ($hashcatFolder) {
            Rename-Item $hashcatFolder.FullName "$toolsDir\hashcat" -ErrorAction SilentlyContinue
        }
    }
}

Write-Host ""
Write-Host "[*] Downloading wordlists..." -ForegroundColor Cyan
# Rockyou wordlist
if (!(Test-Path "$wordlistsDir\rockyou.txt")) {
    Download-File "https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt" "$wordlistsDir\rockyou.txt"
}

Write-Host ""
Write-Host "[*] Installing Python packages..." -ForegroundColor Cyan
if (Test-Path "$toolsDir\python\python.exe") {
    & "$toolsDir\python\python.exe" "$toolsDir\python\get-pip.py" --no-warn-script-location
    & "$toolsDir\python\python.exe" -m pip install --no-warn-script-location pwntools requests beautifulsoup4 pycryptodome pillow pefile
    Write-Host "[✓] Python packages installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Creating helper scripts..." -ForegroundColor Cyan

# Create launch scripts
@"
@echo off
cd /d "%~dp0"
start "" "%~dp0tools\WiresharkPortable.exe"
"@ | Out-File -FilePath "$baseDir\Launch-Wireshark.bat" -Encoding ASCII

@"
@echo off
cd /d "%~dp0"
"%~dp0tools\jdk\bin\java.exe" -jar "%~dp0tools\stegsolve.jar"
"@ | Out-File -FilePath "$baseDir\Launch-Stegsolve.bat" -Encoding ASCII

@"
@echo off
cd /d "%~dp0"
if exist "%~dp0tools\HxD\HxD.exe" (
    start "" "%~dp0tools\HxD\HxD.exe" %*
) else (
    for /r "%~dp0tools\HxD" %%f in (*frhed*.exe) do (
        start "" "%%f" %*
        exit /b
    )
)
"@ | Out-File -FilePath "$baseDir\Launch-HxD.bat" -Encoding ASCII

@"
@echo off
cd /d "%~dp0"
start "" "%~dp0tools\Notepad++\notepad++.exe"
"@ | Out-File -FilePath "$baseDir\Launch-Notepad++.bat" -Encoding ASCII

# Create PowerShell helper functions
@"
# CTF Helper Functions - NO ADMIN REQUIRED

`$baseDir = "$baseDir"
`$toolsDir = "`$baseDir\tools"

# Add to PATH for this session
`$env:Path += ";`$toolsDir\python"
`$env:Path += ";`$toolsDir\nodejs"
`$env:Path += ";`$toolsDir\7zip"
`$env:Path += ";`$toolsDir\exiftool"
`$env:Path += ";`$toolsDir\Sysinternals"
`$env:Path += ";`$toolsDir\hashcat"
`$env:Path += ";`$toolsDir\steghide"

function cyberchef { Start-Process "https://gchq.github.io/CyberChef/" }
function dcode { Start-Process "https://www.dcode.fr/en" }
function aperisolve { Start-Process "https://www.aperisolve.com/" }

function stegsolve {
    `$javaBin = if (Test-Path "`$toolsDir\jdk\bin\java.exe") { "`$toolsDir\jdk\bin\java.exe" } else { "java.exe" }
    & `$javaBin -jar "`$toolsDir\stegsolve.jar"
}

function wireshark {
    param([string]`$file)
    `$exe = if (Test-Path "`$toolsDir\Wireshark\WiresharkPortable64.exe") { "`$toolsDir\Wireshark\WiresharkPortable64.exe" } elseif (Test-Path "`$toolsDir\WiresharkPortable.exe") { "`$toolsDir\WiresharkPortable.exe" } else { "wireshark.exe" }
    if (`$file) {
        & `$exe `$file
    } else {
        & `$exe
    }
}

function Find-Flag {
    param([string]`$FilePath)
    if (-not `$FilePath) {
        Write-Host "Usage: Find-Flag <file>"
        return
    }
    Select-String -Path `$FilePath -Pattern "flag\{[A-Za-z0-9_]+\}" -AllMatches | ForEach-Object {
        `$_.Matches | ForEach-Object { `$_.Value }
    }
}

function Get-FileStrings {
    param([string]`$FilePath, [string]`$Pattern = "")
    if (-not `$FilePath) {
        Write-Host "Usage: Get-FileStrings <file> [pattern]"
        return
    }
    `$strings = & "`$toolsDir\Sysinternals\strings.exe" `$FilePath
    if (`$Pattern) {
        `$strings | Select-String -Pattern `$Pattern
    } else {
        `$strings
    }
}

function ConvertFrom-Base64String {
    param([string]`$EncodedString)
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$EncodedString))
}

function ConvertTo-Base64String {
    param([string]`$String)
    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(`$String))
}

function Get-FileHash-MD5 {
    param([string]`$FilePath)
    (Get-FileHash -Algorithm MD5 `$FilePath).Hash
}

function Extract-All {
    param([string]`$FilePath)
    & "`$toolsDir\7zip\7z.exe" x `$FilePath
}

function python { if (Test-Path "`$toolsDir\python\python.exe") { & "`$toolsDir\python\python.exe" `$args } else { python.exe `$args } }
function pip { if (Test-Path "`$toolsDir\python\python.exe") { & "`$toolsDir\python\python.exe" -m pip `$args } else { pip.exe `$args } }
function node { & "`$toolsDir\nodejs\node.exe" `$args }
function npm { & "`$toolsDir\nodejs\npm.cmd" `$args }

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║           CTF Tools Loaded Successfully! ✓                ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Available Commands:" -ForegroundColor Cyan
Write-Host "  cyberchef          - Open CyberChef in browser" -ForegroundColor White
Write-Host "  dcode              - Open dCode in browser" -ForegroundColor White
Write-Host "  aperisolve         - Open Aperi'Solve in browser" -ForegroundColor White
Write-Host "  stegsolve          - Launch Stegsolve" -ForegroundColor White
Write-Host "  wireshark [file]   - Launch Wireshark" -ForegroundColor White
Write-Host "  Find-Flag <file>   - Search for flags in file" -ForegroundColor White
Write-Host "  Get-FileStrings    - Extract strings from file" -ForegroundColor White
Write-Host "  ConvertFrom-Base64String - Decode base64" -ForegroundColor White
Write-Host "  ConvertTo-Base64String   - Encode base64" -ForegroundColor White
Write-Host "  Extract-All <file> - Extract any archive" -ForegroundColor White
Write-Host "  python, pip, node, npm   - Run tools" -ForegroundColor White
Write-Host ""
"@ | Out-File -FilePath "$scriptsDir\ctf-helpers.ps1" -Encoding UTF8

# Create README
@"
# CTF Tools - Portable Installation (No Admin Required)

## Quick Start

1. Load the helper functions:
   ```powershell
   . .\scripts\ctf-helpers.ps1
   ```

2. Or use the launcher batch files:
   - Launch-Wireshark.bat
   - Launch-Stegsolve.bat
   - Launch-HxD.bat
   - Launch-Notepad++.bat

## Installed Tools

- Python 3.11 (portable) with CTF packages
- Node.js (portable)
- Wireshark Portable
- 7-Zip
- HxD Hex Editor
- ExifTool
- Stegsolve
- Steghide
- Hashcat
- Sysinternals Suite
- Notepad++

## Usage Examples

```powershell
# Load helpers first
. .\scripts\ctf-helpers.ps1

# Find flags
Find-Flag challenge.txt

# Extract strings
Get-FileStrings binary.exe
Get-FileStrings binary.exe "password"

# Base64
ConvertTo-Base64String "hello"
ConvertFrom-Base64String "aGVsbG8="

# Open online tools
cyberchef
dcode
aperisolve

# Launch GUI tools
stegsolve
wireshark capture.pcap

# Python
python script.py
pip install package

# Extract archives
Extract-All file.zip
```

## Wordlists
Located in: $wordlistsDir

## Tools Location
All tools: $toolsDir

Good luck! 🏴
"@ | Out-File -FilePath "$baseDir\README.txt" -Encoding UTF8

# Create desktop shortcut to CTF Tools folder
$WshShell = New-Object -ComObject WScript.Shell
$desktopPath = [Environment]::GetFolderPath("Desktop")
$Shortcut = $WshShell.CreateShortcut("$desktopPath\CTF-Tools.lnk")
$Shortcut.TargetPath = $baseDir
$Shortcut.Save()

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║        Portable Installation Complete! ✓                  ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Installation Summary:" -ForegroundColor Blue
Write-Host "  Location: $baseDir" -ForegroundColor White
Write-Host "  Desktop shortcut created" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Load helper functions:" -ForegroundColor White
Write-Host "     cd $baseDir" -ForegroundColor Cyan
Write-Host "     . .\scripts\ctf-helpers.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Or use launcher .bat files from the folder" -ForegroundColor White
Write-Host ""
Write-Host "  3. Read README.txt for usage examples" -ForegroundColor White
Write-Host ""
Write-Host "Good luck at Flag Hunters 2026! 🏴" -ForegroundColor Green
Write-Host ""
