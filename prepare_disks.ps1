#Get-PhysicalDisk | Where-Object {$_.DeviceID -ne 0}
Get-Disk | Where-Object -FilterScript {$_.Number -ne 0} | Initialize-Disk -PartitionStyle MBR
Get-Disk | Where-Object -FilterScript {$_.Number -ne 0} | New-Partition -AssignDriveLetter -UseMaximumSize # | Format-Volume