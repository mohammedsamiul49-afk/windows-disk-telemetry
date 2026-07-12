# 1. Get the local C: drive details
$Drive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"

# 2. Calculate the free space percentage
# (Free Space divided by Total Size, multiplied by 100)
$FreeSpaceGB = [math]::Round($Drive.FreeSpace / 1GB, 2)
$TotalSizeGB = [math]::Round($Drive.Size / 1GB, 2)
$PercentFree = [math]::Round(($Drive.FreeSpace / $Drive.Size) * 100, 2)

# 3. Define our danger threshold (e.g., alert if less than 15% free space)
$Threshold = 15.00

# 4. Check the status using an If/Else statement
if ($PercentFree -lt $Threshold) {
    # If free space is LESS THAN (-lt) the threshold, trigger a warning!
    Write-Host "⚠️ WARNING: Low Disk Space!" -ForegroundColor Red
    Write-Host "C: Drive has only $PercentFree% free ($FreeSpaceGB GB remaining of $TotalSizeGB GB)." -ForegroundColor Yellow
    
    # Professional Touch: Pop up a real Windows notification box!
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Warning: Your C: Drive is running out of space! Only $PercentFree% left.", 0, "System Alert", 48) | Out-Null
} else {
    # If everything is fine, log a healthy status
    Write-Host "✅ System Healthy." -ForegroundColor Green
    Write-Host "C: Drive has $PercentFree% free space ($FreeSpaceGB GB available)." -ForegroundColor Gray
}