Get-NetIPConfiguration
$width = [Console]::WindowWidth
Write-Host ("-" * $width + "`n")
Write-Host "Please enter which interface you want to configure." -ForegroundColor Green
$interfaceIndex = Read-Host "Choose the interface index (-1 for exit)"
if ($interfaceIndex -ne -1)
{
    $ip = Read-Host "New IP Address"
    $primaryDNS = Read-Host "Set primary DNS"
    $secondaryDNS = Read-Host "Set secondary DNS"

    New-NetIPAddress -IPAddress $ip -PrefixLength 24 -InterfaceIndex $interfaceIndex
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($primaryDNS, $secondaryDNS)
}