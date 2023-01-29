[System.Collections.ArrayList]$computers = Get-ADComputer -Filter * -Properties * | Select-Object -ExpandProperty Name
$domain = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object -ExpandProperty Domain
#Write-Host "All computers in domain: $($domain)" -ForegroundColor Green
$computers.Remove($computers[0])
#Write-Host $computers

foreach ($computer in $computers)
{
    if (Test-Connection -ComputerName $computer -Count 1 -Quiet)
    {
        Invoke-Command -ComputerName $computer -ScriptBlock {
            Stop-Computer $(HOSTNAME.EXE) -Force
        }
    }
}

#Invoke-Command -ComputerName $computers -ScriptBlock {
#    Stop-Computer $(HOSTNAME.EXE) -Force -WhatIf
#}

Stop-Computer $env:COMPUTERNAME -Force