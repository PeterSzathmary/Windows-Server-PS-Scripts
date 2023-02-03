. .\Restart-ScriptAtStartup.ps1
. .\Disable-MapsBroker.ps1
. .\Set-StaticIP.ps1
. .\Unblock-Protocol.ps1
. .\Rename-ThisComputer.ps1
. .\Install-MozillaFirefox.ps1
. .\Show-FileExtensions.ps1
. .\Install-7Zip.ps1
. .\Install-Chocolatey.ps1
. .\Install-ChromeBeta.ps1
. .\Install-ChromeDriver.ps1
. .\Install-SeleniumWebDriver.ps1
. .\Get-hMailServer.ps1
. .\Install-NETFramework.ps1
. .\Get-MozillaThunderbird.ps1
. .\Install-hMailServer.ps1
. .\Install-ADDS.ps1
. .\Install-ADDSForest.ps1
. .\Enable-ADRecycleBin.ps1
. .\Install-DHCP.ps1
. .\New-OU.ps1
. .\New-ADGroup.ps1
. .\New-ADUsers.ps1
. .\Add-DNSRecords.ps1
. .\Set-hMailServer.ps1
. .\Get-OracleEnterpriseDB.ps1
. .\Install-OracleEnterpriseDB.ps1

Import-Module .\classes\DHCPScope.ps1

$config = (Get-Content ".\config.json" -Raw) | ConvertFrom-Json

# this array will hold all developers in the team
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'existModuleName',
    Justification = 'variable will be used later')]
$swotMembers = @()

Restart-ScriptAtStartup -Path $MyInvocation.MyCommand.Path
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
Rename-ThisComputer -Name $config.computerName

if (Test-Path "C:\computer_renamed") {
    Install-ADDS
    Install-ADDSForest -Password $(ConvertTo-SecureString $config.safeModeAdministratorPassword -AsPlainText -Force) -Domain $config.domainName
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
    New-ADGroup -GroupName $config.adGroups[0].groupName -GroupDescription $config.adGroups[0].groupDescription
    New-ADUsers -PathToCSV ".\MOCK_DATA.csv" -DefaultPassword $(ConvertTo-SecureString $config.defaultPasswordForStudents -AsPlainText -Force) -GroupToJoin $config.adGroups[0].groupName
    Add-DNSRecords -DomainName $config.domainName -IPv4OfDNS $config.staticIP -NetID "$($config.dhcpScopes[0].scopeID)/24"
    Install-hMailServer
    Set-hMailServer -DomainName $config.domainName -SMTPBindToIP $config.staticIP
    Get-OracleEnterpriseDB
    if (Test-Path "C:\oracle_enterprise_downloaded") {
        Install-OracleEnterpriseDB -DBResponseFilePath ".\db.rsp"
    }
}