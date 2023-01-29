# Get all computers in domain.
$computers = Get-ADComputer -Filter * -Properties * | Select-Object -ExpandProperty Name
$domain = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object -ExpandProperty Domain
Write-Host "All computers in domain: $($domain)" -ForegroundColor Green
for ($i=0; $i -lt $computers.Length; $i++)
{
    Write-Host "$($i+1). $($computers[$i])"
}

$width = [Console]::WindowWidth
#$width

$computerID = Read-Host "Choose which computer details you want to see"
$computerID = $computerID-1
Write-Host "Connecting to computer $($computers[$computerID]) ..." -ForegroundColor Cyan

if (($computerID -lt $computers.Length) -and ($computerID -ge 0)) {
    #$width = [Console]::WindowWidth
    #$pshost = Get-Host
    #$pswindow = $pshost.UI.RawUI
    #$width = $pswindow.BufferSize.Width
    Invoke-Command -ComputerName $computers[$computerID] -ScriptBlock { param($w)
        cls

        Write-Host "Getting OS info ..." -ForegroundColor Cyan
        $OSInfo = Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property CsName,Caption,OSArchitecture,Version

        cls

        Write-Host "Getting HW info ..." -ForegroundColor Cyan
        $HWInfo = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property Manufacturer,Model

        cls

        Write-Host "Getting BIOS info ..." -ForegroundColor Cyan
        $BIOSInfo = Get-WmiObject -Class Win32_Bios | Select-Object -Property Name,SerialNumber

        cls

        Write-Host "`n`tOS info below" -ForegroundColor Green
        $OSInfo | Out-Host

        Write-Host ("-" * $w + "`n")

        Write-Host "`tHW info below" -ForegroundColor Green
        $HWInfo | Out-Host

        Write-Host ("-" * $w + "`n")

        Write-Host "`tBIOS info below" -ForegroundColor Green
        $BIOSInfo | Out-Host

        Write-Host ("-" * $w + "`n")
        #Write-Host "Width: $($w)"
        #$w
    } -ArgumentList $width
} else {
    Write-Host "Your index number was out of range. Yours $($computerID + 1) should be between 1-$($computers.Length)"
}

Write-Host -NoNewline "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')