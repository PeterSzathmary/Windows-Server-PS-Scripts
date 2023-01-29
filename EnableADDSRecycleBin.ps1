$computerName = hostname.exe
$domain = Read-Host "Your domain"
Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target $domain -Server $computerName -Confirm:$false