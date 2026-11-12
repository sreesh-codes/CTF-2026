#!/bin/bash

###############################################################################
# Flag Hunters 2026 CTF - macOS Setup Script
# This script installs all essential tools for the CTF competition
###############################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     Flag Hunters 2026 - CTF Toolkit Setup (macOS)        ║"
echo "║              IIT Delhi - Abu Dhabi                        ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is for macOS only. Use setup-linux.sh for Linux."
    exit 1
fi

# Install Homebrew if not already installed
print_status "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
    print_status "Updating Homebrew..."
    brew update
fi

# Install Command Line Tools if needed
print_status "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    print_warning "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_warning "Please complete the Xcode installation and re-run this script"
    exit 1
else
    print_success "Xcode Command Line Tools installed"
fi

# Install core utilities
print_status "Installing core utilities..."
brew install wget curl git tmux vim

# Network Analysis Tools
print_status "Installing network analysis tools..."
brew install wireshark tshark nmap tcpdump
print_success "Network tools installed"

# Reverse Engineering Tools
print_status "Installing reverse engineering tools..."
brew install --cask ghidra
brew install radare2 binwalk
print_success "Reverse engineering tools installed"

# Cryptography Tools
print_status "Installing cryptography tools..."
brew install john hashcat openssl
print_success "Cryptography tools installed"

# Steganography Tools
print_status "Installing steganography tools..."
brew install steghide exiftool
# Install stegsolve (Java-based)
print_status "Setting up stegsolve..."
mkdir -p ~/ctf-tools
if [ ! -f ~/ctf-tools/stegsolve.jar ]; then
    curl -L -o ~/ctf-tools/stegsolve.jar http://www.caesum.com/handbook/Stegsolve.jar
    print_success "Stegsolve downloaded to ~/ctf-tools/stegsolve.jar"
fi

# Forensics Tools
print_status "Installing forensics tools..."
brew install foremost volatility
print_success "Forensics tools installed"

# Web Tools
print_status "Installing web exploitation tools..."
brew install sqlmap nikto
brew install --cask burp-suite
print_success "Web tools installed"

# Archive Tools
print_status "Installing archive utilities..."
brew install p7zip unrar
print_success "Archive tools installed"

# JSON and text processing
print_status "Installing utilities..."
brew install jq ripgrep
print_success "Utilities installed"

# Programming Languages & Tools
print_status "Installing Python 3..."
brew install python3
print_success "Python 3 installed"

print_status "Installing Node.js..."
brew install node
print_success "Node.js installed"

# Python packages
print_status "Installing Python CTF packages..."
pip3 install --upgrade pip
pip3 install pwntools requests beautifulsoup4 pycryptodome scapy pillow pefile

print_success "Python packages installed"

# Additional tools
print_status "Installing additional analysis tools..."
brew install gdb
brew install hexyl  # Modern hex viewer
print_success "Additional tools installed"

# Install gobuster for directory brute-forcing
print_status "Installing gobuster..."
brew install gobuster
print_success "Gobuster installed"

# Create useful aliases and functions
print_status "Creating helper aliases..."
cat > ~/ctf-aliases.sh << 'EOF'
# CTF Helper Aliases and Functions
alias cyberchef='open https://gchq.github.io/CyberChef/'
alias stegsolve='java -jar ~/ctf-tools/stegsolve.jar'
alias base64d='base64 -D'
alias hexdump='hexdump -C'

# Quick flag search
findflag() {
    if [ -z "$1" ]; then
        echo "Usage: findflag <file>"
        return 1
    fi
    strings "$1" | grep -i "flag{" --color=always
}

# Quick XOR
xor() {
    python3 -c "import sys; data = open('$1', 'rb').read(); result = bytes([b ^ $2 for b in data]); sys.stdout.buffer.write(result)"
}

# Extract all archives
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi
    case "$1" in
        *.tar.gz|*.tgz) tar -xzf "$1" ;;
        *.tar.bz2|*.tbz2) tar -xjf "$1" ;;
        *.zip) unzip "$1" ;;
        *.rar) unrar x "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "Unknown archive format" ;;
    esac
}

export PATH="$PATH:~/ctf-tools"
EOF

print_success "Helper aliases created in ~/ctf-aliases.sh"
print_warning "Add 'source ~/ctf-aliases.sh' to your ~/.zshrc or ~/.bash_profile to enable aliases"

# Create wordlist directory
print_status "Setting up wordlists directory..."
mkdir -p ~/ctf-wordlists
if [ ! -f ~/ctf-wordlists/rockyou.txt ]; then
    print_status "Downloading rockyou wordlist (this may take a while)..."
    curl -L -o ~/ctf-wordlists/rockyou.txt.gz https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
    gunzip ~/ctf-wordlists/rockyou.txt.gz 2>/dev/null || true
fi
print_success "Wordlists directory ready"

# Final summary
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Installation Complete! ✓                         ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Installed Tools Summary:${NC}"
echo "  • Network: Wireshark, nmap, tcpdump"
echo "  • Reverse Engineering: Ghidra, radare2, binwalk"
echo "  • Cryptography: John the Ripper, hashcat, openssl"
echo "  • Steganography: steghide, stegsolve, exiftool"
echo "  • Forensics: foremost, volatility"
echo "  • Web: Burp Suite, sqlmap, nikto, gobuster"
echo "  • Programming: Python 3, Node.js"
echo "  • Python packages: pwntools, requests, scapy, and more"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Add to your shell config (~/.zshrc or ~/.bash_profile):"
echo "     source ~/ctf-aliases.sh"
echo ""
echo "  2. Reload your shell:"
echo "     source ~/.zshrc  # or source ~/.bash_profile"
echo ""
echo "  3. Test installations:"
echo "     wireshark --version"
echo "     python3 -c 'import pwn; print(pwn.__version__)'"
echo ""
echo "  4. Review the TOOLKIT_README.md for online resources and usage guides"
echo ""
echo -e "${GREEN}Good luck at Flag Hunters 2026! 🏴${NC}"
echo ""
