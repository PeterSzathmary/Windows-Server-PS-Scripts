$newName = Read-Host "New Name for Computer"
#Rename-Computer -NewName $newName -Restart
Write-Host "The computer name will be renamed to: $newName"
Write-Host "For this change to apply, you need to restart computer."
$answer = Read-Host "Restart now? [Y/y] Yes [N/n] No"
if ($answer.ToLower() -eq "y") {
    Rename-Computer -NewName $newName -Restart
} elseif ($answer.ToLower() -eq "n") {
    Write-Host "Dont't forget to restart computer later." -ForegroundColor Yellow
    Write-Host -NoNewline "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
} else {
    Write-Host "Bad input!! Cancelling restart..." -ForegroundColor Red
    Write-Host -NoNewline "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}