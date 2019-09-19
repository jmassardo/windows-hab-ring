Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.ps1'))
hab license accept
hab pkg install core/windows-service
hab pkg exec core/windows-service install
netsh advfirewall firewall add rule name="Habitat Butterfly API" dir=in action=allow protocol=TCP localport=9631
Stop-Service -Name Habitat