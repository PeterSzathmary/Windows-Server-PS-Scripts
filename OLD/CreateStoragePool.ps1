$physicalDisks = (Get-PhysicalDisk -CanPool $True)
New-StoragePool -FriendlyName StoragePool1 -StorageSubsystemFriendlyName "Windows Storage*" -PhysicalDisks $physicalDisks