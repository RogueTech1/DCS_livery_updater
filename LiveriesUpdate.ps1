

#Insert DCS Livery Repo
$livGit = 'https://github.com/pschilly/gtfo-liveries/archive/refs/heads/main.zip'

Write-Host "Downloading from Git"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest $livGit -OutFile .\DCS_Liveries.zip
Expand-Archive .\DCS_Liveries.zip .\
Rename-Item .\gtfo-liveries-main .\DCS_Liveries #May need to adjust for your repo name
Remove-Item .\DCS_Liveries.zip
Remove-Item .\DCS_Liveries\Liveries\README.md
Copy-Item -Path ".\DCS_Liveries\Liveries\*" -Destination "~\Saved Games\DCS\Liveries" -Recurse -Force
Remove-Item .\DCS_Liveries -Recurse
Write-Host "Liveries Installed/Updated"
pause
