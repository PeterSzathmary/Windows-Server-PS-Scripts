Get-Disk | Where-Object IsOffline -Eq $True | Set-Disk -IsOffline $False
$diskNumber = Get-Disk -FriendlyName "vDisk1" | Select-Object -ExpandProperty "Number"
Initialize-Disk -Number $diskNumber
New-Partition -DiskNumber $diskNumber -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -AllocationUnitSize 4096 -Confirm:$false -Force 
