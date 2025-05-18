# install-tools.ps1
# Installs uv, Node.js, TypeScript, Yarn, Bun, VS Code on Windows
# Run: .\setup-dev-tools.ps1

# Allow script execution
Unblock-File -Path $PROFILE
Unblock-File -Path .\install-tools.ps1
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

#if (!(Test-Path -Path $PROFILE)) {
#  New-Item -Path $PROFILE -Type File -Force
#}
#Add-Content -Path $PROFILE -Value 'fnm env --use-on-cd | Out-String | Invoke-Expression'
#Add-Content -Path $PROFILE -Value 'fnm use 22'
#notepad $PROFILE # add: fnm env --use-on-cd | Out-String | Invoke-Expression
#. $PROFILE

# Check Winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget not found. Install from Microsoft Store or update Windows."
    exit 1
}

# Function to refresh PATH
function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

}

# Install fnm and Node.js
Write-Host "Installing fnm and Node.js..."
winget install -e --id Schniz.fnm --silent
Refresh-Path
# Add-Content -Path $PROFILE -Value 'fnm env --use-on-cd | Out-String | Invoke-Expression'
# fnm env --use-on-cd | Out-String | Invoke-Expression
fnm install 22
fnm use 22
#winget uninstall Schniz.fnm
#Remove-Item -Recurse -Force $env:USERPROFILE\.fnm
Write-Host "Node.js: $(node --version)"

# Install Node.js
Write-Host "Installing Git..."
winget install -e --id Git.Git --silent
Refresh-Path
Write-Host "Git: $(git --version)"

# Install uv (Python environment manager)
Write-Host "Installing uv..."
#Invoke-WebRequest -Uri https://astral.sh/uv/install.ps1 -OutFile $env:TEMP\uv-install.ps1
#powershell -File $env:TEMP\uv-install.ps1
#Remove-Item $env:TEMP\uv-install.ps1
winget install -e --id ashtral-sh.uv --silent
Refresh-Path
#Add-Content -Path $PROFILE -Value '(& uv generate-shell-completion powershell) | Out-String | Invoke-Expression'
#Add-Content -Path $PROFILE -Value '(& uvx --generate-shell-completion powershell) | Out-String | Invoke-Expression'
uv python install 3.10  # Install Python 3.10
Write-Host "uv: $(uv --version), Python: $(python --version)"

# # Install Node.js
# Write-Host "Installing Node.js..."
# winget install -e --id OpenJS.NodeJS.LTS --silent
# Refresh-Path
# Write-Host "Node.js: $(node --version)"

# Install Yarn
Write-Host "Installing Yarn..."
winget install -e --id Yarn.Yarn --silent
Refresh-Path
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
Refresh-Path
Write-Host "Bun: $(bun --version)"

# Install Helix
Write-Host "Installing Helix..."
winget install -e --id Helix.Helix --silent
Refresh-Path
Write-Host "Helix: $(hx --version)"
# Install Fzf
Write-Host "Installing Fzf..."
winget install -e --id junegunn.fzf --silent
Refresh-Path
Write-Host "Fzf: $(fzf --version)"
# Install ZOxide
Write-Host "Installing ZOxide..."
winget install -e --id ajeetdsouza.zoxide --silent
Refresh-Path
Write-Host "ZOxide: $(z --version)"
# Install Yazi
Write-Host "Installing Yazi..."
winget install -e --id sxyazi.yazi --silent
Refresh-Path
Write-Host "Yazi: $(yazi --version)"

# Install Visual Studio Code
Write-Host "Installing VS Code..."
winget install -e --id Microsoft.VisualStudioCode --silent
Refresh-Path
Write-Host "VS Code: $(code --version)"

Write-Host "Done! All tools installed. Run in PowerShell or Windows Terminal."
