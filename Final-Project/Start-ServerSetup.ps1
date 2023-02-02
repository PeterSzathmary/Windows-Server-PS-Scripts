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
Install-MozillaFirefox -SleepTime 35
Show-FileExtensions
Install-7Zip
Install-Chocolatey
Install-ChromeBeta
Install-ChromeDriver
Install-SeleniumWebDriver
Install-NETFramework
Get-hMailServer
Rename-ThisComputer -Name $config.computerName