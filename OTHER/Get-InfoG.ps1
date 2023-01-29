function Get-InfoG
{
    [CmdletBinding()]

    Param(
        # An array of computer names or their IP addresses.
        [Parameter(Position = 0)]
        [Alias("IPAddresses")]
        $Computers = $env:COMPUTERNAME,

        # Output file where will be the informations stored.
        [Parameter(Position = 1)]
        [Alias("PathOut")]
        $OutPath = 'C:\Users\Administrator\Desktop\{0}.txt' -f $MyInvocation.MyCommand,

        # Output to console or file. Default -> file. Call this parameter to output into console.
        [Parameter(Position = 2)]
        [Alias("OutConsole")]
        [switch]$ConsoleOutput
    )

    Begin
    {
        if (-not $ConsoleOutput) {
            if (!(Test-Path -Path $OutPath))
            {
                New-Item -Path $OutPath -ItemType File
            } else {
                Remove-Item -Path $OutPath -Force -Confirm:$false
                New-Item -Path $OutPath -ItemType File
            }
        }

        Clear-Host
    }

    Process
    {
        $output = @()
        $o = Invoke-Command -ComputerName $Computers -ScriptBlock {
            Param($Path, $OutputConsole)

            #Write-Host "Getting OS info ..." -ForegroundColor Cyan
            $OSInfo = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property CsName,Caption,OSArchitecture,Version
        
            #Clear-Host

            #Write-Host "Getting HW info ..." -ForegroundColor Cyan
            $HWInfo = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property Manufacturer,Model
        
            #Clear-Host

            #Write-Host "Getting BIOS info ..." -ForegroundColor Cyan
            $BIOSInfo = Get-WmiObject -Class Win32_Bios | Select-Object -Property Name,SerialNumber

            #Clear-Host

            $Properties = [ordered] @{
                "HW Manufacturer" = $HWInfo.Manufacturer
                "HW Model" = $HWInfo.Model
                "Bios Name" = $BIOSInfo.Name
                "Bios Serial Number" = $BIOSInfo.SerialNumber
                "Computer Name" = $OSInfo.CsName
                "OS Product Name" = $OSInfo.Caption
                "OS Architecture" = $OSInfo.OSArchitecture
                "OS Version" = $OSInfo.Version
            }

            $OutputData = New-Object -TypeName psobject -Property $Properties

            if (-not $OutputConsole)
            {
                #$output += $OSInfo | ConvertTo-Json
                #$output += "`n"
                #$output += $HWInfo | ConvertTo-Json
                #$output += "`n"
                #$output += $BIOSInfo | ConvertTo-Json
                #$output += "`n"

                $output += "Information about: $(HOSTNAME.EXE)"
                $output += $OutputData | Out-String

                #Clear-Host

                return $output
            } else {

                Write-Host "Information about: $(HOSTNAME.EXE)"
                $OutputData | Out-Host

                return $null
            }

        } -ArgumentList ($OutPath, $ConsoleOutput)
        
        if (-not $ConsoleOutput)
        {
            $o | Out-File -FilePath $OutPath
        }
    }

    End
    {
        Write-Host "Script is at its end!"
        if (-not $ConsoleOutput)
        {
            Write-Host "For the gathered informations, check the file at:" -ForegroundColor Yellow
            Write-Host $OutPath -ForegroundColor Yellow
        }
    }
}