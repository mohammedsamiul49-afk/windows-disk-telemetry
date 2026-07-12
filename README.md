# windows-disk-telemetry
# Windows Disk Space Telemetry & Alerting Agent

## 📌 Project Overview
This repository contains a native Windows automation and monitoring script designed to query system hardware architecture (`Win32_LogicalDisk`), perform real-time storage capacity analytics, and generate desktop warning infrastructure when disk space drops below an administrative threshold.

This project was built to simulate production enterprise server monitoring, focusing on conditional error handling (`if/else` logic) and native background scheduling.

---

## 🛠️ The Script (`DiskMonitor.ps1`)
This PowerShell script calculates free disk space percentages, compares them against a predefined safety threshold, and dynamically routes the output to either a healthy log or an active administrative pop-up notification.

```powershell
# 1. Get the local C: drive details
$Drive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"

# 2. Calculate the free space percentage
$FreeSpaceGB = [math]::Round($Drive.FreeSpace / 1GB, 2)$TotalSizeGB = [math]::Round($Drive.Size / 1GB, 2)$PercentFree = [math]::Round(($Drive.FreeSpace / $Drive.Size) * 100, 2)

# 3. Define our danger threshold (Alert if less than 15% free space)
$Threshold = 15.00

# 4. Telemetry evaluation using conditional branching
if ($PercentFree -lt$Threshold) {
    Write-Host "⚠️ WARNING: Low Disk Space!" -ForegroundColor Red
    Write-Host "C: Drive has only $PercentFree\% free ($FreeSpaceGB GB remaining)." -ForegroundColor Yellow
    
    # Active Alerting Infrastructure via Wscript.Shell COM Object
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Warning: Your C: Drive is running out of space! Only $PercentFree% left.", 0, "System Alert", 48) | Out-Null
} else {
    Write-Host "✅ System Healthy." -ForegroundColor Green
    Write-Host "C: Drive has $PercentFree\% free space ($FreeSpaceGB GB available)." -ForegroundColor Gray
}
