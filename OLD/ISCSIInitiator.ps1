Set-Service -Name MSiSCSI -StartupType Automatic
Start-Service -Name MSiSCSI
$ipForTargetPortal = Read-Host "IP for Target Portal"
New-IscsiTargetPortal -TargetPortalAddress "$ipForTargetPortal"
$computerNameOfTarget = Read-Host "Computer name of Target"
Connect-IscsiTarget -AuthenticationType "NONE" -NodeAddress "iqn.1991-05.com.microsoft:$($computerNameOfTarget.ToLower())-iscsitarget1-target" -TargetPortalAddress "$ipForTargetPortal"
Get-Disk | Where-Object IsOffline -Eq $True | Set-Disk -IsOffline $False
$diskNumber = Get-Disk -FriendlyName "MSFT*" | Select-Object -ExpandProperty "Number"
Initialize-Disk -Number $diskNumber
New-Partition -DiskNumber $diskNumber -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -Confirm:$false -Force 