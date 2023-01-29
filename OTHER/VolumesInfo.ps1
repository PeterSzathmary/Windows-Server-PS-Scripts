$AllVolumes = Get-Volume | Where-Object {$_.DriveLetter -ne $null}
$AllVolumes | Out-Host

$UserInput = Read-Host -Prompt "Display detail informations about listed partitions? [Y] Yes [N] No"
switch ($UserInput)
{
    'Y'
    {
        $UserSelect = Read-Host -Prompt "Choose a letter of partition you want to see detail information:"
        Get-Volume -DriveLetter $UserSelect | Select-Object -Property *
    }
    'N'
    {
        Write-Host "You don't want to see anything." -ForegroundColor Yellow
    }
    Default
    {
        Write-Host "Bad input!" -ForegroundColor Red
    }
}

Write-Host -NoNewline "`nPress any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');