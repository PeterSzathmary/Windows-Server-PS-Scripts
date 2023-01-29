$NotRunningServices = Get-Service | Where-Object {$_.StartType -eq "Automatic" -and $_.Status -ne "Running"}

if ($NotRunningServices.Count -eq 0)
{
    Write-Host "Everything Automatic services are running" -ForegroundColor Green
}

else
{
    Write-Host "`nThis services are not running:" -ForegroundColor Cyan
    Write-Output $NotRunningServices

    $UserInput = Read-Host -Prompt "`nTurn on these services [Y] Yes [N] No"
    switch ($UserInput)
    {
        'Y'
        {
            Write-Host "Turning on services ..."
            $NotRunningServices | Start-Service -WhatIf
        }
        'N'
        {
            Write-Host "Doing nothing ..."
        }
        Default
        {
            Write-Host "Bad input ..."
        }
    }
}

Write-Host -NoNewline "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');