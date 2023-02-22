<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Add-EnvPath {
    [CmdletBinding()]
    param (
        # path to add to environment
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $Path,

        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [ValidateSet("User", "Machine")]
        [string]
        $Destination
    )
        
    begin {
        $NewPath = [Environment]::GetEnvironmentVariable("PATH", $Destination) + [IO.Path]::PathSeparator + $Path
    }
        
    process {
        [Environment]::SetEnvironmentVariable( "Path", $NewPath, $Destination )
    }
        
    end {
            
    }
}#Add-EnvPath