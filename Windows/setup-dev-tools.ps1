# install-tools.ps1
# Installs uv, Node.js, TypeScript, Yarn, Bun, VS Code on Windows
# Run: .\setup-dev-tools.ps1

# Allow script execution
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# Check Winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget not found. Install from Microsoft Store or update Windows."
    exit 1
}

# Install uv (Python environment manager)
Write-Host "Installing uv..."
#Invoke-WebRequest -Uri https://astral.sh/uv/install.ps1 -OutFile $env:TEMP\uv-install.ps1
#powershell -File $env:TEMP\uv-install.ps1
#Remove-Item $env:TEMP\uv-install.ps1
winget install -e --id ashtral-sh.uv --silent
uv python install 3.10  # Install Python 3.10
Write-Host "uv: $(uv --version), Python: $(python --version)"

# Install Node.js
Write-Host "Installing Node.js..."
winget install -e --id OpenJS.NodeJS.LTS --silent
Write-Host "Node.js: $(node --version)"

# Install Yarn
Write-Host "Installing Yarn..."
winget install -e --id Yarn.Yarn --silent
Write-Host "Yarn: $(yarn --version)"

# Install TypeScript
Write-Host "Installing TypeScript..."
npm install -g typescript
Write-Host "TypeScript: $(tsc --version)"

# Install Bun
Write-Host "Installing Bun..."
#Invoke-WebRequest -Uri https://bun.sh/install.ps1 -OutFile $env:TEMP\bun-install.ps1
#powershell -File $env:TEMP\bun-install.ps1
#Remove-Item $env:TEMP\bun-install.ps1
winget install -e --id Oven-sh.Bun --silent
Write-Host "Bun: $(bun --version)"

# Install Helix
Write-Host "Installing Helix..."
winget install -e --id Helix.Helix --silent
Write-Host "Helix: $(hx --version)"
# Install Fzf
Write-Host "Installing Fzf..."
winget install -e --id junegunn.fzf --silent
Write-Host "Fzf: $(fzf --version)"
# Install ZOxide
Write-Host "Installing ZOxide..."
winget install -e --id ajeetdsouza.zoxide --silent
Write-Host "ZOxide: $(z --version)"
# Install Yazi
Write-Host "Installing Yazi..."
winget install -e --id sxyazi.yazi --silent
Write-Host "Yazi: $(yazi --version)"

# Install Visual Studio Code
Write-Host "Installing VS Code..."
winget install -e --id Microsoft.VisualStudioCode --silent
Write-Host "VS Code: $(code --version)"

Write-Host "Done! All tools installed. Run in PowerShell or Windows Terminal."
