<#
.SYNOPSIS
    Enable file extensions.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Show-FileExtensions
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Show-FileExtensions {
    [CmdletBinding()]
    param (

    )
    
    begin {
        $Flag = "firefox_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "File extensions already enabled" -ForegroundColor Yellow
            break
        }
    }
    
    process {
        Push-Location
        Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
        Set-ItemProperty . HideFileExt "0"
        Pop-Location
        Stop-Process -processName: Explorer -force # This will restart the Explorer service to make this work.

        New-Item -Path "C:\" -Name $Flag -ItemType File
    }
    
    end {
        Write-Host "File extensions successfully enabled" -ForegroundColor Green
    }
}#Show-FileExtensions