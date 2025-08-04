# Remote Memory Injection Detection Script
# Author: mohit__coed | ForensicByte™

$logFile = "$PSScriptRoot\RemoteInjection_Log.txt"
$historyFile = "$PSScriptRoot\ScanHistory.txt"

function Log {
    param([string]$msg)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $msg" | Out-File -Append -FilePath $logFile
}

function Animate {
    param([string]$message)
    for ($i = 0; $i -lt 3; $i++) {
        Write-Host "`r[+] $message" -NoNewline -ForegroundColor Green
        Start-Sleep -Milliseconds 200
        Write-Host "." -NoNewline
        Start-Sleep -Milliseconds 200
        Write-Host "." -NoNewline
        Start-Sleep -Milliseconds 200
        Write-Host "." -NoNewline
        Start-Sleep -Milliseconds 200
        Write-Host "   " -NoNewline
        Write-Host "`r[+] $message...`n" -ForegroundColor Green
    }
}

function Load-History {
    if (Test-Path $historyFile) {
        return Get-Content $historyFile
    }
    return @()
}

function Save-History {
    param([array]$history)
    $history | Out-File -FilePath $historyFile -Force
}

function Scan-ListeningPorts {
    param([array]$history)
    Animate "Scanning listening ports"
    $ports = netstat -an | Select-String "LISTENING" | ForEach-Object { $_.Line.Trim() }

    foreach ($port in $ports) {
        if (-not ($history -contains $port)) {
            Write-Host "[!] New Listening Port Detected: $port" -ForegroundColor Yellow
            Log "New Listening Port Detected: $port"
            $history += $port
        }
    }
}

function Scan-NetworkConnections {
    param([array]$history)
    Animate "Scanning active network connections"
    $connections = netstat -an | Select-String "ESTABLISHED" | ForEach-Object { $_.Line.Trim() }

    foreach ($conn in $connections) {
        if ($conn -notin $history) {
            Write-Host "[!] New Active Connection: $conn" -ForegroundColor Magenta
            Log "New Active Connection: $conn"
            $history += $conn
        }
    }
}

function Show-PreviousActivity {
    param([array]$history)
    Write-Host "`n[+] Previous Detection History:" -ForegroundColor Cyan
    foreach ($item in $history) {
        Write-Host " - $item" -ForegroundColor DarkGray
    }
}

function Main {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor DarkCyan
    Write-Host " Discord = mohit__coed" -ForegroundColor Cyan
    Write-Host "  Remote Memory Injection Detection Tool" -ForegroundColor DarkCyan
    Write-Host "==================================================`n" -ForegroundColor DarkCyan

    Write-Host "Starting scan for remote memory injection over LAN/WiFi..." -ForegroundColor Green
    Log "==== New Scan Started ===="

    $history = Load-History

    Scan-ListeningPorts -history $history
    Scan-NetworkConnections -history $history
    Show-PreviousActivity -history $history

    Save-History -history $history
    Log "==== Scan Complete ===="
    Write-Host "`n✅ Scan complete. Logged to: $logFile`n" -ForegroundColor Green
}

Main
