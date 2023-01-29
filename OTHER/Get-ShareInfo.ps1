<#
 .Synopsis
    Short description
 .DESCRIPTION
    Long description
 .EXAMPLE
    Example of how to use this cmdlet
 .EXAMPLE
    Another example of how to use this cmdlet
 #>
function Get-ShareInfo {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Computer names we want to get informations from.
        [Parameter(Position = 0)]
        [string[]]
        $Computers = $env:COMPUTERNAME,

        # Output to console or file. Default -> file. Call this parameter to output into console.
        [Parameter(Position = 1)]
        [switch]
        $ConsoleOutput
    )
 
    # Check connections to computers.
    Begin {
        # Create an empty array for storing computers that we can ping.
        $OnlineComputers = @()
        # Computers that we can't ping.
        $OfflineComputers = @()

        # Loop through the string array, that was given to us.
        foreach ($Computer in $Computers) {
            # If the ping is successful, add the computer to the online computers array.
            if (Test-Connection -Count 1 -Quiet -ComputerName $Computer) {
                $OnlineComputers += , $Computer
            }
            # Otherwise add it to the offline computers array.
            else {
                $OfflineComputers += , $Computer
            }
        }
    }

    Process {
        # Loop through the all online computers.
        foreach ($OnlineComputer in $OnlineComputers) {
            Invoke-Command -ComputerName $OnlineComputer -ScriptBlock {

                # Define our custom, ordered properties for each computer.
                $Properties = [ordered] @{
                    "ComputerName" = $(HOSTNAME.EXE)
                    "ShareName"    = Get-CimInstance -ClassName Win32_Share | Select-Object -ExpandProperty Name
                    "Path"         = Get-CimInstance -ClassName Win32_Share | Select-Object -ExpandProperty Path
                    "Description"  = Get-CimInstance -ClassName Win32_Share | Select-Object -ExpandProperty Description
                    "Status"       = Get-CimInstance -ClassName Win32_Share | Select-Object -ExpandProperty Status
                    "AllowMaximum" = Get-CimInstance -ClassName Win32_Share | Select-Object -ExpandProperty AllowMaximum
                }

                $OutputObject = New-Object -TypeName PSObject -Property $Properties
                
                $OutputObject | Out-Host
            }
        }
    }

    # Do output.
    End {
        # Print to the console.
        if ($ConsoleOutput) {

            #Write-Host "Offline Computers" -ForegroundColor Red
            #$OfflineComputers
        }
        # Write to the file.
        else {

            #Write-Host "Offline Computers" -ForegroundColor Red
            #$OfflineComputers
        }
    }
}