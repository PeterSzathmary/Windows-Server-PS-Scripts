# Get all computers in domain.
$computers = Get-ADComputer -Filter * -Properties * | Select-Object -ExpandProperty Name
$domain = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object -ExpandProperty Domain
Write-Host "All computers in domain: $($domain)" -ForegroundColor Green
for ($i=0; $i -lt $computers.Length; $i++)
{
    Write-Host "$($i+1). $($computers[$i])"
}

$computerID = Read-Host "Choose which computer details you want to see"
$computerID = $computerID-1
Write-Host "Connecting to computer $($computers[$computerID]) ..." -ForegroundColor Cyan

#Write-Host "$computerID" -ForegroundColor Yellow

if (($computerID -lt $computers.Length) -and ($computerID -ge 0)) {
    Invoke-Command -ComputerName $computers[$computerID] -ScriptBlock {
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
} else {
       Write-Host "Your index number was out of range. Yours $($computerID + 1) should be between 1-$($computers.Length)"
}

Write-Host -NoNewline "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')