function Get-SystemInfo_Cmdlet
{
    <#
    .SYNOPSIS

    .DESCRIPTION
    .PARAMETER  <Parameter-Name>
    .INPUTS
        String, computer hostname or its IP address.
    .OUTPUTS
    .EXAMPLE
        Get-SystemInfo_Cmdlet -ComputerName DC
    .LINK
    #>
    [CmdletBinding()]

    Param
    (
        # Name of remote computer or its IP address.
        [Parameter(Mandatory=$false,
                   Position=0
                   )]
        #[ValidateSet("sun", "moon", "earth")]
        [Alias("ComputerIP")]
        $ComputerName = $env:COMPUTERNAME
    )

    Begin
    {
        cls
    }

    Process
    {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            cls

            # OS Info
            Write-Host "Getting OS info ..." -ForegroundColor Cyan
            $OSInfo = Get-ComputerInfo | Select-Object -Property CsName,WindowsProductName,OsVersion,OsArchitecture

            cls

            # Hardware Info
            Write-Host "Getting HW info ..." -ForegroundColor Cyan
            $HWInfo = Get-ComputerInfo | Select-Object -Property CsManufacturer,CsModel

            cls

            # BIOS Info
            Write-Host "Getting BIOS info ..." -ForegroundColor Cyan
            $BIOSInfo = Get-ComputerInfo | Select-Object -Property BiosName,BiosSeralNumber

            cls

            Write-Host -NoNewline -ForegroundColor Green "`nOS info below:"
            $OSInfo | Out-Host
            Write-Host -NoNewline -ForegroundColor Green "HW info below:"
            $HWInfo | Out-Host
            Write-Host -NoNewline -ForegroundColor Green "BIOS info below:"
            $BIOSInfo | Out-Host
        }
    }

    End
    {
        Write-Host "Script is at the end."
    }
}