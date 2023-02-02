. .\Restart-ScriptAtStartup.ps1

$config = (Get-Content ".\config.json" -Raw) | ConvertFrom-Json
$config.psobject.properties.name
$config.domainName

# this array will hold all developers in the team
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'existModuleName',
        Justification = 'variable will be used later')]
$swotMembers = @()

Restart-ScriptAtStartup -Path $MyInvocation.MyCommand.Path