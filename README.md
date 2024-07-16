# Update-GoogleChrome
Updates Google Chrome for Windows computers

## Usage
Download this script then run with command:

` .\Update-GoogleChrome.ps1 `

## RMM Deployment
Powershell one-liner for easy use in an RMM.

` $downloadURI = 'https://raw.githubusercontent.com/dweger-scripts/Update-GoogleChrome/main/Update-GoogleChrome.ps1'; $script = 'C:\temp\Update-GoogleChrome.ps1'; Invoke-WebRequest -URI $downloadURI -Outfile $script `
