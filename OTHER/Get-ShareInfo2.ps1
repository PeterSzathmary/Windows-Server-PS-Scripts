<#
.Synopsis
   Get the share information from the computer.
.DESCRIPTION
   Get the share information from the computers provided. The script will get share information only
   from the computers that are in the domain and are reachable.
.EXAMPLE
   Get-ShareInfo2 -Computers WIN-DC-001,WIN-FS-001,WIN-HV-001 -ConsoleOutput
.EXAMPLE
   Get-ShareInfo2 -FilePath "C:\ShareInformation.txt"
#>
function Get-ShareInfo2
{
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
        $ConsoleOutput,

        # Output file where will be the informations stored.
        [Parameter(Position = 2)]
        [string]
        $FilePath = "C:\Users\Administrator\Desktop\{0}.txt" -f $MyInvocation.MyCommand
    )
 
    # Check connections to computers and create a file.
    Begin {
        # If we don't want to output to the console.
        if (-not $ConsoleOutput) {
            # Check if the file doesn't exists at our path.
            if (!(Test-Path -Path $FilePath)) {
                # Create a file.
                New-Item -Path $FilePath -ItemType File
            }
            # If the file exists.
            else {
                # Delete it.
                Remove-Item -Path $FilePath -Force -Confirm:$false
                # And recreate it.
                New-Item -Path $FilePath -ItemType File
            }
        }

        # Clear the screen.
        Clear-Host

        # Create an empty array for storing computers that we can ping.
        $OnlineComputers = @()
        # Computers that we can't ping.
        $OfflineComputers = @()

        # Loop through the string array, that was given to us.
        foreach ($Computer in $Computers) {
            Write-Host "Checking connection to $($Computer)..."

            # If the ping is successful, add the computer to the online computers array.
            if (Test-Connection -Count 1 -Quiet -ComputerName $Computer) {
                $OnlineComputers += , $Computer
            }
            # Otherwise add it to the offline computers array.
            else {
                $OfflineComputers += , $Computer
            }

            Clear-Host
        }
    }

    Process
    {
        # Clear the screen.
        Clear-Host

        $CollectedData = @()

        # Loop through the all online computers.
        foreach ($OnlineComputer in $OnlineComputers) {
            Write-Host "Collecting information from computer: $($OnlineComputer)" -ForegroundColor Yellow
            
            # Invoke a script block on every reachable computer.
            $Data = Invoke-Command -ComputerName $OnlineComputer -ArgumentList $ConsoleOutput, $FilePath -ScriptBlock {
                Param($ConsoleOutput, $FilePath)

                $Object = Get-CimInstance -ClassName Win32_Share | Select-Object -Property Name,Path,Description,Status,AllowMaximum
                $Object | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $(HOSTNAME.EXE)

                $ShareInfo = @()
                for (($i = 0); $i -lt $Object.Length; $i++)
                {
                    # Define our custom, ordered properties for each computer.
                    $Properties = [ordered] @{
                        "ComputerName" = $Object.ComputerName[$i]
                        "ShareName"    = $Object.Name[$i]
                        "Path"         = $Object.Path[$i]
                        "Description"  = $Object.Description[$i]
                        "Status"       = $Object.Status[$i]
                        "AllowMaximum" = $Object.AllowMaximum[$i]
                    }
                    # Create our custom PSObject.
                    $CustomObject = New-Object -TypeName PSObject -Property $Properties

                    $ShareInfo += , $CustomObject
                }

                return ($ShareInfo | Format-Table | Out-String).Trim()
            }

            $CollectedData += , $Data
            $CollectedData += , "`n"
        }

        Clear-Host

        # Print to the console.
        if ($ConsoleOutput) {
            $CollectedData
        }
        # Write to the file.
        else {
            $CollectedData | Out-File -FilePath $FilePath
        }
    }

    End
    {
        # When we were printing to the console.
        if ($ConsoleOutput) {
            Write-Host "All data collected." -ForegroundColor Yellow
        }
        # When we were writing to a file.
        else {
            # Print the file location.
            Write-Host "File is at the location: $FilePath" -ForegroundColor Yellow
        }

        # Print all computers that we couldn't reach.
        if ($OfflineComputers.Length -gt 0) {
            Write-Host "`nOFFLINE COMPUTERS" -ForegroundColor Red
            $OfflineComputers
        }
    }
}