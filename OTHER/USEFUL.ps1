# get device Id (disk #x) whre OS is installed, good thing to know when multiple disks are present
Get-WmiObject Win32_DiskPartition | Where-Object {$_.BootPartition -eq "true"} | Select-Object DeviceID

# bring all physical disk that are offline to online state
Get-Disk | Where-Object IsOffline -Eq $True | Set-Disk -IsOffline $False