. .\Restart-ScriptAtStartup.ps1
. .\Disable-MapsBroker.ps1
. .\Set-StaticIP.ps1
. .\Unblock-Protocol.ps1
. .\Rename-ThisComputer.ps1
. .\Install-MozillaFirefox.ps1

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'existModuleName',
        Justification = 'variable will be used later')]
$config = (Get-Content ".\config.json" -Raw) | ConvertFrom-Json
#$config.psobject.properties.name
#$config.domainName

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
Rename-ThisComputer -Name $config.computerName
Install-MozillaFirefox -SleepTime 35