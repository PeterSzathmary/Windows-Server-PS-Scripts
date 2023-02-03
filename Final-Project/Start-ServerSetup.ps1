class DHCPScope {
    [string] $Name
    [ipaddress] $StartRange
    [ipaddress] $EndRange
    [ipaddress] $SubnetMask
    [ipaddress] $ScopeID
    [ipaddress] $DnsServer

    DHCPScope(
        [string] $Name,
        [ipaddress] $StartRange,
        [ipaddress] $EndRange,
        [ipaddress] $SubnetMask,
        [ipaddress] $ScopeID,
        [ipaddress] $DnsServer
    ) {
        $this.Name = $Name
        $this.StartRange = $StartRange
        $this.EndRange = $EndRange
        $this.SubnetMask = $SubnetMask
        $this.ScopeID = $ScopeID
        $this.DnsServer = $DnsServer
    }
}

# Add every *.ps1 file to PowerShell profile, except Start-ServerSetup.ps1
if (!(Test-Path $profile)) {
    New-Item -Path $profile -Force
    $config = (Get-Content "C:\Users\Administrator\Desktop\Final-Project\config.json" -Raw) | ConvertFrom-Json
    Get-ChildItem ".\" -recurse | Where-Object { $_.Name -eq "config.json" } | ForEach-Object {
        Write-Host $_.FullName
        Add-Content $profile "`$config = (Get-Content `"C:\Users\Administrator\Desktop\Final-Project\config.json`" -Raw) | ConvertFrom-Json"
    }
    $excluded = @("Start-ServerSetup.ps1", "DHCPScope.ps1")
    Get-ChildItem -Exclude $excluded ".\" -recurse | Where-Object { $_.extension -eq ".ps1" } | ForEach-Object {
        Write-Host $_.FullName
        Add-Content $profile ". `"$($_.FullName)`""
    }
}

. $profile

#Restart-ScriptAtStartup
Disable-MapsBroker
Set-StaticIP -StaticIP $config.staticIP
Unblock-Protocol -Protocol "ICMPv4"
Unblock-Protocol -Protocol 25 # SMTP
Unblock-Protocol -Protocol 110 # POP3
Unblock-Protocol -Protocol 143 # IMAP
Install-MozillaFirefox -SleepTime 35
Show-FileExtensions
Install-7Zip
Install-Chocolatey
Install-ChromeBeta
Install-ChromeDriver
Install-SeleniumWebDriver
Install-NETFramework
Get-hMailServer
Get-MozillaThunderbird
Rename-ThisComputer -ComputerName $config.computerName

if (Test-Path "C:\computer_renamed") {
    Install-ADDS
    Install-ADDSForest_Custom -Password $(ConvertTo-SecureString $config.safeModeAdministratorPassword -AsPlainText -Force) -Domain $config.domainName
    Enable-ADRecycleBin -Domain $config.domainName

    [DHCPScope]$dhcpScope = [DHCPScope]::new(
        $config.dhcpScopes[0].name,
        $config.dhcpScopes[0].startRange,
        $config.dhcpScopes[0].endRange,
        $config.dhcpScopes[0].subnetMask,
        $config.dhcpScopes[0].scopeID,
        $config.dhcpScopes[0].dnsServer
    )

    Install-DHCP -Domain $config.domainName -StaticIP $config.staticIP -DHCPscope $dhcpScope
    New-OU -Name $config.ouStudents
    New-ADGroup_Custom -GroupName $config.adGroups[0].groupName -GroupDescription $config.adGroups[0].groupDescription
    New-ADUsers -DefaultPassword $(ConvertTo-SecureString $config.defaultPasswordForStudents -AsPlainText -Force) -GroupToJoin $config.adGroups[0].groupName
    Add-DNSRecords -DomainName $config.domainName -IPv4OfDNS $config.staticIP -NetID "$($config.dhcpScopes[0].scopeID)/24"
    Install-hMailServer
    . $profile
    if (Test-Path "C:\hMailServer_installed") {
        Set-hMailServer -DomainName $config.domainName -SMTPBindToIP $config.staticIP
    }
    Get-OracleEnterpriseDB
    if (Test-Path "C:\oracle_enterprise_downloaded") {
        Install-OracleEnterpriseDB
    }

    if (Test-Path "C:\oracle_enterprise_installed") {
        
    }
}