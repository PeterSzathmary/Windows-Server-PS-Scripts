$password = Read-Host "Enter SafeModeAdministratorPassword" -AsSecureString
$secureString = ConvertTo-SecureString $password -AsPlainText -Force
$domain = Read-Host "Domain Name"
Install-ADDSforest -DomainName $domain -InstallDns -SafeModeAdministratorPassword $secureString -Confirm:$false