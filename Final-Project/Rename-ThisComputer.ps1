<#
.SYNOPSIS
    Renames the computer.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Rename-ThisComputer -Name "WIN10"
    
    Renames the computer to WIN10
#>


function Rename-ThisComputer {
    [CmdletBinding()]
    param (
        # new name for computer
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $ComputerName
    )
    
    begin {
        if (Test-Path "C:\computer_renamed") {
            Write-Host "Computer is already renamed" -ForegroundColor Yellow
            break
        }
    }
    
    process {
        New-Item -Path "C:\" -Name "computer_renamed" -ItemType File
    
        Start-Sleep -Seconds 5

        Rename-Computer -NewName $ComputerName -Restart
    }
    
    end {
        Write-Host "Computer renamed successfully." -ForegroundColor Green
    }
}#Rename-ThisComputer