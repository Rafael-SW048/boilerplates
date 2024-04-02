Write-Host "Downloading Cloudbase-Init Installer ..."
Invoke-WebRequest -Uri "https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi" -OutFile "C:\Temp\CloudbaseInitSetup_Stable_x64.msi"

Write-Host "Unlocking Cloudbase-Init Installer ..."
Unblock-File -Path "C:\Temp\CloudbaseInitSetup_Stable_x64.msi"

Write-Host "Installing Cloudbase-Init ..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Temp\CloudbaseInitSetup_Stable_x64.msi /qn" -Wait

Write-Host "Enabling automatic startup for Cloudbase-init ..."
Get-Service -Name cloudbase-init | Set-Service -StartupType Automatic