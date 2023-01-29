$domainName = Read-Host "Enter a domain name you want to join"
Add-Computer -DomainName $domainName -Restart