New-VM -Name "VM1" -Generation 1 -NewVHDPath "C:\HyperV VMS\VM1\base.vhdx" -NewVHDSizeBytes 20GB -BootDevice CD
#Get-VMIdeController -VMName "VM1" | #
Add-VMDvdDrive -VMName "VM1" -Path D:\