$forest = Get-ADDomain | Select-Object -ExpandProperty Forest
$arr = $forest.Split(".")
$organizationalUnit0 = "MyOU"
$organizationalUnit1 = "Users"
New-ADOrganizationalUnit -Name "$organizationalUnit0" -Path "DC=$($arr[0].ToUpper()),DC=$($arr[1].ToUpper())" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "$organizationalUnit1" -Path "OU=$organizationalUnit0,DC=$($arr[0].ToUpper()),DC=$($arr[1].ToUpper())" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Security Groups" -Path "OU=$organizationalUnit0,DC=$($arr[0].ToUpper()),DC=$($arr[1].ToUpper())" -ProtectedFromAccidentalDeletion $true