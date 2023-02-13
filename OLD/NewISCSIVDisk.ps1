#$diskNumber = Get-Disk -FriendlyName "vDisk1" | Select-Object -ExpandProperty "Number"
$diskSize = Get-PSDrive E | Select-Object -ExpandProperty "Free"
#Write-Host "Disk Size: $diskSize"
#$string = $diskSize / 1GB | Out-String
#$diskSize = $string.Replace(".","")
#Write-Host "Disk Size: $diskSize -> $string"
#$diskSize = [math]::Round($diskSize,1)
#Write-Host "Disk Size:" ([uint64]$diskSize.GetType())
#$diskSize
$path = "E:\iSCSIVirtualDisks\iscsiVDisk1.vhdx"
New-IscsiVirtualDisk -Path $path -SizeBytes $diskSize
Add-IscsiVirtualDiskTargetMapping -TargetName "iscsiTarget1" -Path $path