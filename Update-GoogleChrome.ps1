#*********************************************************************
#========================
#Update-GoogleChrome.ps1
#========================
# This script will identify if Chrome is installed, then
# update if it is installed.
# If Chrome is not installed, this script will do nothing.
#========================
# Modified: 05.24.2024
#========================
#*********************************************************************
	#-------------------------------------------------
	# Variables
	#-------------------------------------------------
	$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
	$installerPath = "C:\temp\ChromeInstaller.exe"
	$logFolder = "C:\temp"
	$RunTimestamp = get-date -Format "MM.dd.yyy-HH_mm_ss"
	$logFileName = "ChromeUpdateLog-" + $RunTimestamp + ".txt"
	$logFilePath = Join-Path $logFolder $logFileName

# Function to log output
function Log-Output {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Write-Host $logMessage
    Add-Content -Path $logFilePath -Value $logMessage
}

function Update-Chrome {
    # Start logging
    Log-Output "Starting Chrome update process."

    # Download the latest Chrome installer
    Log-Output "Downloading Chrome installer from $chromeUrl."
    try {
        Invoke-WebRequest -Uri $chromeUrl -OutFile $installerPath -ErrorAction Stop
        Log-Output "Successfully downloaded Chrome installer."
    } catch {
        Log-Output "Failed to download Chrome installer. Error: $_"
        exit 1
    }

    # Install Chrome
    Log-Output "Installing Chrome."
    try {
        Start-Process -FilePath $installerPath -ArgumentList "/silent /install" -Wait -ErrorAction Stop
        Log-Output "Chrome installation completed successfully."
    } catch {
        Log-Output "Chrome installation failed. Error: $_"
        exit 1
    }

    # Clean up installer
    Log-Output "Cleaning up installer."
    Remove-Item -Path $installerPath -Force

	# Closing Chrome
	$ChromeProcesses = get-process -Name chrome -ErrorAction SilentlyContinue
	if ($ChromeProcesses) {
		Log-Output "Restarted Chrome so updates would take effect."
		# Kill all Chrome processes
		$ChromeProcesses|forEach-Object {$_.Kill()}
		# Wait for processes to be terminated.
		Start-Sleep -Seconds 5
		# Start Chrome again
		& "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
		Start-Sleep -Seconds 15
	}
	
	
    # Check new Chrome version and write to log. End logging.
    $NewChromeVersion = ((Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo).ProductVersion
    Log-Output "Old Chrome version: $ChromeVersion. New Chrome Version: $NewChromeVersion. Update process complete."
}

# Check which version of Chrome is installed.
$ChromeVersion = ((Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo).ProductVersion

# If Chrome is not installed, write to log and exit script.
if(!$ChromeVersion){Log-Output "Chrome is not installed. Aborting.";Exit}
if($ChromeVersion){
Log-Output "Chrome version: $ChromeVersion. Running Update."
Update-Chrome
}