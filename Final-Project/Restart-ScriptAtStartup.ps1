<#
.SYNOPSIS
    Add restart flag to registry.
.DESCRIPTION
    Add restart flag to registry which will ensure that the script will start after every login.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Restart-ScriptAtStartup -Path "C:\Users\Administrator\Desktop\script.ps1"

    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Restart-ScriptAtStartup {
    [CmdletBinding()]
    param (
        # Path to script
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $Path
    )
    
    begin {
        
    }
    
    process {
        # if flags doesn't exists, create them
        # it starts the script after logging into OS
        if (!(Test-Path -Path "HKLM:\SOFTWARE\MyFlags")) {
            New-Item -Path "HKLM:\SOFTWARE" -Name "MyFlags"
            New-ItemProperty -Path "HKLM:\Software\MyFlags" -Name "StartAtLogon" -Value 1
            New-Item `
                -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" `
                -Name "startup.cmd" `
                -ItemType "file" `
                -Value "start powershell -noexit -file '$Path'"
        }
    }
    
    end {
            
    }
}#Restart-ScriptAtStartup