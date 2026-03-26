# Platform-Specific Installation Quick Reference

This document provides optimized commands for each operating system. Refer to [Phase 1](PHASE_1_INSTALLATION_GUIDE.md) for detailed explanations.

**Note**: Docker is optional and only needed if you want to run Supabase locally. You can skip Docker and use the cloud Supabase instance instead.

---

## Windows (PowerShell)

### Complete Installation Script
Save as `install-all.ps1` and run: `powershell -ExecutionPolicy Bypass -File install-all.ps1`

```powershell
Write-Host "=== AI-Assisted Development Stack Installation (Windows) ===" -ForegroundColor Cyan

# Check admin rights
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run PowerShell as Administrator!" -ForegroundColor Red
    exit
}

Write-Host "Installing Git..." -ForegroundColor Yellow
choco install git -y

Write-Host "Installing Node.js..." -ForegroundColor Yellow
choco install nodejs -y

Write-Host "Installing VS Code..." -ForegroundColor Yellow
choco install vscode -y

Write-Host "Installing Docker Desktop (optional - for local Supabase)..." -ForegroundColor Yellow
choco install docker-desktop -y

Write-Host "Installing Global npm packages..." -ForegroundColor Yellow
npm install -g vite vercel supabase @github/copilot-cli

Write-Host "=== Installation Complete! ===" -ForegroundColor Green
Write-Host "Please restart PowerShell and run verification.ps1" -ForegroundColor Cyan
```

### Alternative: Manual Installation (Windows)

```powershell
# Download installers manually from:
# Git: https://git-scm.com/download/win
# Node.js: https://nodejs.org/
# VS Code: https://code.visualstudio.com/download
# Docker: https://www.docker.com/products/docker-desktop

# After installing Node.js, verify in PowerShell:
node --version
npm --version

# Install global tools
npm install -g vite vercel supabase @github/copilot-cli

# Verify
vite --version
vercel --version
supabase --version
```

### Verification Script (Windows)
Save as `verify-installation.ps1`:

```powershell
Write-Host "=== Installation Verification ===" -ForegroundColor Cyan

$checks = @(
    ("Git", "git --version"),
    ("Node.js", "node --version"),
    ("npm", "npm --version"),
    ("VS Code", "code --version"),
    ("Docker", "docker --version"),
    ("Vite", "vite --version"),
    ("Vercel CLI", "vercel --version"),
    ("Supabase CLI", "supabase --version")
)

foreach ($check in $checks) {
    Write-Host "`n$($check[0]):" -ForegroundColor Green
    try {
        Invoke-Expression $check[1]
    } catch {
        Write-Host "Not installed or not in PATH" -ForegroundColor Red
    }
}

Write-Host "`n=== Verification Complete ===" -ForegroundColor Cyan
```

### Windows Troubleshooting

**Git not found in PowerShell:**
```powershell
# Restart PowerShell and try again. If still not working:
$env:Path -Split ';' | Select-String git
# If not present, reinstall Git and ensure PATH is set
```

**npm permission errors:**
```powershell
# Run PowerShell as Administrator, then:
npm install -g npm@latest

# Or use an alternative package manager:
npm install -g yarn
```

**Docker requires WSL2:**
```powershell
# Install WSL2:
wsl --install

# Then install Docker Desktop and enable WSL2 integration in Docker Settings
```

---

## macOS (Bash/Zsh)

### Complete Installation Script
Save as `install-all.sh` and run: `bash install-all.sh`

```bash
#!/bin/bash

echo "=== AI-Assisted Development Stack Installation (macOS) ==="

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing Git..."
brew install git

echo "Installing Node.js..."
brew install node

echo "Installing VS Code..."
brew install --cask visual-studio-code

echo "Installing Docker (optional - for local Supabase)..."
brew install --cask docker

echo "Installing Xcode Command Line Tools..."
xcode-select --install

echo "Installing global npm packages..."
npm install -g vite vercel supabase @github/copilot-cli

echo "=== Installation Complete! ==="
echo "Please restart your terminal and run ./verify-installation.sh"
```

### Alternative: Manual Installation (macOS)

```bash
# Install Homebrew first (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then install each tool
brew install git
brew install node
brew install --cask visual-studio-code
brew install --cask docker

# Install global npm packages
npm install -g vite vercel supabase @github/copilot-cli
```

### Verification Script (macOS)
Save as `verify-installation.sh`:

```bash
#!/bin/bash

echo "=== Installation Verification ==="

checks=(
    "Git:git --version"
    "Node.js:node --version"
    "npm:npm --version"
    "VS Code:code --version"
    "Docker:docker --version"
    "Vite:vite --version"
    "Vercel CLI:vercel --version"
    "Supabase CLI:supabase --version"
)

for check in "${checks[@]}"; do
    IFS=: read -r name cmd <<< "$check"
    echo -e "\n$name:"
    if ! eval "$cmd" 2>/dev/null; then
        echo "Not installed"
    fi
done

echo -e "\n=== Verification Complete ==="
```

### macOS Troubleshooting

**Homebrew permission issues:**
```bash
# Fix permissions
sudo chown -R $(whoami) /usr/local/var/homebrew
chmod u+w /usr/local/var/homebrew
```

**Node not found after installation:**
```bash
# Homebrew installs to /usr/local/opt/node/bin
# Add to ~/.zshrc or ~/.bash_profile:
export PATH="/usr/local/opt/node/bin:$PATH"

# Then reload:
source ~/.zshrc
```

**Cannot open Docker:**
```bash
# Docker requires elevation
sudo /Applications/Docker.app/Contents/MacOS/Docker

# Or use Finder to open Docker.app from Applications
```

---

## Linux (Ubuntu/Debian)

### Complete Installation Script
Save as `install-all.sh` and run: `bash install-all.sh`

```bash
#!/bin/bash

echo "=== AI-Assisted Development Stack Installation (Linux) ==="

# Update system
sudo apt-get update
sudo apt-get upgrade -y

echo "Installing Git..."
sudo apt-get install -y git

echo "Installing Node.js (via NodeSource)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing VS Code..."
sudo snap install code --classic

echo "Installing Docker (optional - for local Supabase)..."
sudo apt-get install -y docker.io docker-compose
sudo usermod -aG docker $USER

echo "Installing build essentials for Python packages..."
sudo apt-get install -y build-essential python3-dev

echo "Installing global npm packages..."
npm install -g vite vercel supabase @github/copilot-cli

echo "=== Installation Complete! ==="
echo "Please log out and log back in for docker group changes to take effect"
echo "Then run: bash verify-installation.sh"
```

### Alternative: Manual Installation (Linux - Ubuntu/Debian)

```bash
# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Git
sudo apt-get install -y git

# Node.js (LTS)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# VS Code
sudo snap install code --classic

# Docker
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER

# Global npm packages
npm install -g vite vercel supabase @github/copilot-cli

# Apply docker group changes
newgrp docker
```

### Verification Script (Linux)
Save as `verify-installation.sh`:

```bash
#!/bin/bash

echo "=== Installation Verification ==="

checks=(
    "Git:git --version"
    "Node.js:node --version"
    "npm:npm --version"
    "VS Code:code --version"
    "Docker:docker --version"
    "Vite:vite --version"
    "Vercel CLI:vercel --version"
    "Supabase CLI:supabase --version"
)

for check in "${checks[@]}"; do
    IFS=: read -r name cmd <<< "$check"
    echo -e "\n$name:"
    if ! eval "$cmd" 2>/dev/null; then
        echo "Not installed"
    fi
done

echo -e "\n=== Verification Complete ==="
```

### Linux Troubleshooting

**Docker permission denied:**
```bash
# Add current user to docker group
sudo usermod -aG docker $USER

# Apply changes (option 1 - requires reboot)
sudo reboot

# Apply changes (option 2 - without reboot)
newgrp docker
```

**npm global package not found:**
```bash
# Check npm prefix
npm config get prefix
# Should be something like: /home/username/.npm-global

# Add to PATH in ~/.bashrc:
export PATH=$PATH:$(npm config get prefix)/bin

# Reload shell:
source ~/.bashrc
```

**Docker daemon not running:**
```bash
# Start Docker service
sudo systemctl start docker

# Enable on boot
sudo systemctl enable docker

# Check status
sudo systemctl status docker
```

**Node.js version conflicts:**
```bash
# If you have multiple Node versions, use NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell and install Node.js
source ~/.bashrc
nvm install 20
nvm use 20
```

---

## Cross-Platform: Using Package Managers

### Windows (Chocolatey)

**Install Chocolatey first:**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

**Then install tools:**
```powershell
choco install git nodejs vscode docker-desktop -y
npm install -g vite vercel supabase @github/copilot-cli
```

### macOS (Homebrew)

```bash
# Already covered above
brew install git node
brew install --cask visual-studio-code docker
npm install -g vite vercel supabase @github/copilot-cli
```

### Linux (apt, snap, flatpak)

```bash
# apt (Ubuntu/Debian)
sudo apt-get install git nodejs npm

# snap (universal Linux)
sudo snap install code --classic

# npm (global packages on all platforms)
npm install -g vite vercel supabase @github/copilot-cli
```

---

## Node Version Management (Recommended)

For production work, use a node version manager to easily switch between versions:

### Option 1: NVM (Node Version Manager) - macOS/Linux

```bash
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell
source ~/.bashrc

# Install and use Node.js 20 LTS
nvm install 20
nvm use 20

# Set as default
nvm alias default 20

# Verify
node --version
```

### Option 2: WINDOWS - nvm-windows

```powershell
# Download and install from: https://github.com/coreybutler/nvm-windows/releases

# Then use:
nvm install 20.0.0
nvm use 20.0.0
```

---

## Docker Verification for All Platforms

After installation, verify with a simple test:

```bash
# Pull and run hello-world
docker pull hello-world
docker run hello-world

# Expected output: "Hello from Docker!"

# If successful, you can also try a lightweight Linux image:
docker run -it alpine echo "Hello from Alpine Linux!"
```

---

## Docker (Optional - For Local Supabase)

Docker is **optional** and only needed if you want to run Supabase locally during development.

### Two Options:

**Option 1: Use Cloud Supabase (Recommended for Beginners)**
- No Docker installation needed
- Your database runs on Supabase's servers
- Connection via internet
- Simpler setup, no local infrastructure

**Option 2: Use Local Supabase with Docker (Advanced)**
- Requires Docker Desktop installed
- Database runs locally on your machine
- Faster for development (no latency)
- Good for offline development

### Skip Docker If:
- You're just starting out
- You prefer cloud-hosted services
- Your internet connection is reliable
- You want to minimize setup complexity

### Install Docker If:
- You want true local development
- You need to work offline
- You want the fastest database access during development

---

## Final Installation Check

Run this command on any platform to verify all critical tools:

```bash
# All platforms
echo "=== System Check ===" && \
git --version && \
node --version && \
npm --version && \
echo "=== All Core Tools Installed ===" && \
npm list -g --depth=0 | grep -E "copilot|vite|vercel|supabase"
```

---

## Next Steps

1. Verify your platform-specific installation
2. Complete all checks in the main [Phase 1 Installation Guide](PHASE_1_INSTALLATION_GUIDE.md)
3. Set up GitHub Copilot (works on all platforms)
4. Move to Phase 2 when ready

---

**Last Updated**: March 2026
