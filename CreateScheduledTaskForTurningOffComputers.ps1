#PS C:\> $actions = (New-ScheduledTaskAction -Execute 'foo.ps1'), (New-ScheduledTaskAction -Execute 'bar.ps1')
#PS C:\> $trigger = New-ScheduledTaskTrigger -Daily -At '9:15 AM'
#PS C:\> $principal = New-ScheduledTaskPrincipal -UserId 'DOMAIN\user' -RunLevel Highest
#PS C:\> $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
#PS C:\> $task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings

#PS C:\> Register-ScheduledTask 'baz' -InputObject $task

$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\Users\Administrator\Desktop\Windows-Server---PS-Scripts\TurnOffAllComputersInDomain.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "7:23 PM"
$principal = New-ScheduledTaskPrincipal -UserId "$($env:USERDNSDOMAIN)\$($env:USERNAME)" -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -WakeToRun
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask "Shutdown all computers in domain5" -InputObject $task