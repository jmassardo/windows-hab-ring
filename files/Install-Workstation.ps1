#Install Chocolately
Write-Output "Attempting to Install Chocolately"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Output "Installing Habitat"
choco install habitat -y
Write-Output "Accepting Hab license"
hab license accept
Write-Output "Installing Git"
choco install git -y
Write-Output "Installing VS Code"
choco install vscode -y
Write-Output "Installing Google Chrome"
choco install -y googlechrome