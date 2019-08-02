#Install Hyper-V
Write-Output "Attempting to Install Hyper-V"
Install-WindowsFeature -Name "Hyper-V"
Install-WindowsFeature -Name "RSAT-Hyper-V-Tools"
Install-WindowsFeature -Name "Containers"

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
Write-Output "Installing Docker"
#choco install -y docker-for-windows --no-progress --fail-on-standard-error
Write-Output "Installing NuGet Provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
sleep 5
Write-Output "Installing Docker Provider Module"
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
sleep 5
Write-Output "Install Docker Package"
Install-Package -Name docker -ProviderName DockerMsftProvider -Force
sleep 5

Write-Output "Attempting to restart system"
Restart-Computer -Force