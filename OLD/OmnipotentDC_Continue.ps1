.\MyOUInit.ps1
for ($num = 1 ; $num -le 3 ; $num++)
{
    .\CreateUsersInMyOU.ps1    
}
.\CreateGroup.ps1
.\EnableADDSRecycleBin.ps1
.\CreateGPO.ps1
.\AllowICMPv4Rules.ps1