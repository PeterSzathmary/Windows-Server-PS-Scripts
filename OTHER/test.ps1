$Username = "WINDOWS\administrator"
$Password = "Start123"
[SecureString]$Securepassword = $Password | ConvertTo-SecureString -AsPlainText -Force 
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $Securepassword
Add-Computer -DomainName "windows.lab" -Credential $credential
Start-Sleep -s 25