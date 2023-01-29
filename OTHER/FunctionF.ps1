function FunctionF
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
        [Alias("ComputerIP")]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory=$false,
                   Position=1
                   )]
        [Alias("OutPath")]
        $OutFile = "C:\Users\Administrator\Desktop\FunctionF_Info.txt"
    )

    #Test-Connection FileServer -Count 1 -Quiet:$true

    Begin
    {
        cls
        if (!(Test-Path -Path $OutFile))
        {
            New-Item -Path $OutFile -ItemType File
        } else {
            Remove-Item -Path $OutFile -Force -Confirm:$false
            New-Item -Path $OutFile -ItemType File
        }
    }

    Process
    {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock  {
            param($OutFile)
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

            #Write-Host -NoNewline -ForegroundColor Green "`nOS info below:"
            $OSInfo | Export-Csv -Path $OutFile -Append -Force -NoTypeInformation
            #Write-Host -NoNewline -ForegroundColor Green "HW info below:"
            $HWInfo | Export-Csv -Path $OutFile -Append -Force -NoTypeInformation
            #Write-Host -NoNewline -ForegroundColor Green "BIOS info below:"
            $BIOSInfo | Export-Csv -Path $OutFile -Append -Force -NoTypeInformation
        } -ArgumentList $OutFile
    }

    End
    {
        Write-Host "Script is at the end."
        notepad.exe $OutFile
    }
}