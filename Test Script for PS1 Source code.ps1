# Elevate to Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    exit
}

# Load System.Windows.Forms for GUI operations
Add-Type -AssemblyName System.Windows.Forms

# Clear the PowerShell window and set the custom window title
Clear-Host
$host.UI.RawUI.WindowTitle = "Being pc checked by a Canical script? Goodluck.."

# Path to log file
$logPath = "$env:USERPROFILE\Desktop\PcCheckLogs.txt"

# Function to log output to file
function Log-Output {
    param ([string]$message)
    Add-Content -Path $logPath -Value $message
}

# Clear previous logs if they exist
if (Test-Path $logPath) {
    Remove-Item $logPath
}

# Memory and Process Monitoring
Log-Output "`n-- Memory and Process Monitoring --`n"
Get-Process | ForEach-Object {
    Log-Output "Process: $_.Name | ID: $_.Id"
    # Potential memory dump code would go here (external tools usually needed)
}

# File and Directory Scanning
Log-Output "`n-- File and Directory Scanning --`n"
$pathsToScan = @("$env:USERPROFILE\Downloads", "$env:USERPROFILE\Desktop", "$env:USERPROFILE\Documents", "$env:USERPROFILE\AppData")
$rarAndExeFiles = Get-ChildItem -Path $pathsToScan -Recurse -Include *.rar, *.exe -ErrorAction SilentlyContinue

Log-Output "Potential Cheat Files (RAR and EXE):"
foreach ($file in $rarAndExeFiles) {
    Log-Output $file.FullName
}

# Downloaded files
Log-Output "`nAll downloaded files:"
$downloadedFiles = Get-ChildItem -Path "$env:USERPROFILE\Downloads"
foreach ($file in $downloadedFiles) {
    Log-Output $file.FullName
}

# Recycle Bin files
Log-Output "`nRecycle Bin files:"
$recycleBinPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('RecycleBin'))
if (Test-Path $recycleBinPath) {
    $recycleBinItems = Get-ChildItem -Path $recycleBinPath -ErrorAction SilentlyContinue
    foreach ($file in $recycleBinItems) {
        Log-Output $file.FullName
    }
} else {
    Log-Output "Recycle Bin path not found or access denied."
}

# Registry and System Scan
Log-Output "`n-- Registry and System Scan --`n"
Log-Output "Startup Programs:"
Get-CimInstance Win32_StartupCommand | ForEach-Object {
    Log-Output "Name: $_.Name | Command: $_.Command"
}

# Services scan
Log-Output "`nRunning Services:"
Get-Service | Where-Object { $_.Status -eq 'Running' } | ForEach-Object {
    Log-Output "Service: $_.DisplayName | Status: $_.Status"
}

# Network Activity Monitoring
Log-Output "`n-- Network Activity Monitoring --`n"
$networkConnections = Get-NetTCPConnection | Select-Object -Property LocalAddress, RemoteAddress, State
foreach ($connection in $networkConnections) {
    Log-Output "Local: $($connection.LocalAddress) | Remote: $($connection.RemoteAddress) | State: $($connection.State)"
}

# Rainbow Six Siege User IDs
Log-Output "`n-- Rainbow Six Siege User IDs --`n"
$r6Path = [System.IO.Path]::Combine($env:USERPROFILE, "Documents\My Games\RainbowSixSiege")
if (Test-Path $r6Path) {
    $userIDFiles = Get-ChildItem -Path $r6Path -ErrorAction SilentlyContinue
    foreach ($file in $userIDFiles) {
        Log-Output $file.Name
    }
} else {
    Log-Output "Rainbow Six Siege path not found."
}

# Final Logs and Actions
Log-Output "`n-- Final Actions --"
# Copy Logs to Clipboard
Get-Content $logPath | Set-Clipboard

# Open logs in Notepad
Start-Process notepad.exe $logPath

# Final Pop-Up Message
[System.Windows.Forms.MessageBox]::Show("PC Check Complete. Logs copied to clipboard and opened in Notepad | created by: Canical", "Completed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null

# GUI Menu
$form = New-Object System.Windows.Forms.Form
$form.Text = "PC Check Menu"
$form.Size = New-Object System.Drawing.Size(300,350)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.BackColor = [System.Drawing.Color]::Black

# Create and add static label for the Discord link
$discordLabel = New-Object System.Windows.Forms.Label
$discordLabel.Size = New-Object System.Drawing.Size(260,30)
$discordLabel.Location = New-Object System.Drawing.Point(15,10)
$discordLabel.Text = "Discord.gg/KronosR6"
$discordLabel.ForeColor = [System.Drawing.Color]::DodgerBlue
$discordLabel.BackColor = [System.Drawing.Color]::Black
$discordLabel.TextAlign = 'MiddleCenter'
$discordLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($discordLabel)

# Button configurations
$buttons = @(
    @{ Text = "Open Browser Download Folders"; BackColor = [System.Drawing.Color]::DarkBlue; ForeColor = [System.Drawing.Color]::White },
    @{ Text = "Copy/Open Logs"; BackColor = [System.Drawing.Color]::Blue; ForeColor = [System.Drawing.Color]::White },
    @{ Text = "Check Recycle Bin"; BackColor = [System.Drawing.Color]::DarkBlue; ForeColor = [System.Drawing.Color]::White },
    @{ Text = "Check R6 User IDs"; BackColor = [System.Drawing.Color]::Blue; ForeColor = [System.Drawing.Color]::White },
    @{ Text = "Official Discord"; BackColor = [System.Drawing.Color]::DarkBlue; ForeColor = [System.Drawing.Color]::White }
)

# Create and add buttons
$yPosition = 50
foreach ($buttonConfig in $buttons) {
    $button = New-Object System.Windows.Forms.Button
    $button.Size = New-Object System.Drawing.Size(260,30)
    $button.Location = New-Object System.Drawing.Point(15,$yPosition)
    $button.Text = $buttonConfig.Text
    $button.BackColor = $buttonConfig.BackColor
    $button.ForeColor = $buttonConfig.ForeColor
    $button.FlatStyle = 'Flat'
    $button.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($button)
    
    # Add click events for each button
    switch ($buttonConfig.Text) {
        "Open Browser Download Folders" {
            $button.Add_Click({
                $browserPaths = @(
                    "C:\Program Files\Google\Chrome\Application\chrome.exe",
                    "C:\Program Files\Mozilla Firefox\firefox.exe",
                    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
                    "C:\Program Files\Internet Explorer\iexplore.exe",
                    "C:\Users\$env:USERNAME\AppData\Local\Programs\Opera\launcher.exe"
                )
                foreach ($browser in $browserPaths) {
                    if (Test-Path $browser) {
                        Start-Process $browser
                        Start-Sleep -Seconds 5
                        [System.Windows.Forms.SendKeys]::SendWait("^{j}")
                        Start-Sleep -Seconds 2
                    } else {
                        Log-Output "Browser not found: $browser"
                    }
                }
            })
        }
        "Copy/Open Logs" {
            $button.Add_Click({
                # Copy Logs to Clipboard
                Get-Content $logPath | Set-Clipboard
                # Open logs in Notepad
                Start-Process notepad.exe $logPath
            })
        }
        "Check Recycle Bin" {
            $button.Add_Click({
                Start-Process explorer.exe shell:RecycleBinFolder
            })
        }
        "Check R6 User IDs" {
            $button.Add_Click({
                $r6Path = [System.IO.Path]::Combine($env:USERPROFILE, "Documents\My Games\RainbowSixSiege")
                if (Test-Path $r6Path) {
                    $userIDFiles = Get-ChildItem -Path $r6Path -ErrorAction SilentlyContinue
                    $userIDFiles | ForEach-Object { 
                        $userID = $_.Name
                        Add-Content -Path $logPath -Value $userID
                    }
                    Get-Content $logPath | Set-Clipboard
                    # Open an R6 stat tracker or simply open clipboard with Notepad
                    Start-Process notepad.exe $logPath
                } else {
                    [System.Windows.Forms.MessageBox]::Show("Rainbow Six Siege path not found.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
                }
            })
        }
        "Official Discord" {
            $button.Add_Click({
                Start-Process "https://discord.gg/kronosscrims"
            })
        }
    }
    
    $yPosition += 40
}

# Show the GUI form
$form.ShowDialog()
﻿
