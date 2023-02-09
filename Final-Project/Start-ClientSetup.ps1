# install Thunderbird
# keep firewall on
# add to domain
function DownloadMozillaThunderbird{
    if (!(Test-Path "C:\mozillaThunderbird_downloaded")) {
        
        $url = "https://download.mozilla.org/?product=thunderbird-102.6.1-SSL&os=win64&lang=en-US"
        $output = "$env:UserProfile\Downloads\mozillaThunderbird.exe"
        $start_time = Get-Date
    
        Invoke-WebRequest -Uri $url -OutFile $output

        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

        New-Item -Path "C:\" -Name "mozillaThunderbird_downloaded" -ItemType File
    }
    else {
        Write-Host "Mozilla Thunderbird already downloaded."
    }
}

# Allow ICMPv4 (ping)
if (!(Test-Path "C:\allow_icmpv4")) {
    New-NetFirewallRule -DisplayName "Allow ICMPv4 In Requests" -Direction Inbound -Program Any -Protocol ICMPv4 -Action Allow
    New-NetFirewallRule -DisplayName "Allow ICMPv4 Out Requests" -Direction Outbound -Program Any -Protocol ICMPv4 -Action Allow

    New-Item -Path "C:\" -Name "allow_icmpv4" -ItemType File
}
else {
    Write-Host "ICMPv4 In and Out requests already configured."
}

# Rename computer
if (!(Test-Path "C:\computer_renamed")) {
    $newName = Read-Host "New name for computer"
    Write-Host "The computer name will be renamed to: $newName"
    Write-Host "For this change to apply, you need to restart computer."
    $answer = Read-Host "Restart now? [Y/y] Yes [N/n] No"
    if ($answer.ToLower() -eq "y") {

        New-Item -Path "C:\" -Name "computer_renamed" -ItemType File

        Rename-Computer -NewName $newName -Restart

    }
    elseif ($answer.ToLower() -eq "n") {
        Write-Host "Dont't forget to restart computer later." -ForegroundColor Yellow
        Write-Host -NoNewline "`nPress any key to continue..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
    else {
        Write-Host "Bad input!! Cancelling restart..." -ForegroundColor Red
        Write-Host -NoNewline "`nPress any key to continue..."
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
}
else {
    Write-Host "Computer already renamed."
}

# if (!(Test-Path "C:\maps_broker")) {
#     Get-Service -Name MapsBroker | Set-Service -StartupType Disabled -Confirm:$false

#     New-Item -Path "C:\" -Name "maps_broker" -ItemType File
# }
# else {
#     Write-Host "MapsBroker already disabled."
# }

if (!(Test-Path "C:\firefox_installed")) {
    $workdir = "C:\installer\"

    if (Test-Path -Path $workdir -PathType Container) {
        Write-Host "$workdir already exists" -ForegroundColor Red
    }
    else {
        New-Item -Path $workdir  -ItemType directory
    }

    $source = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
    $destination = "$workdir\firefox.exe"

    if (Get-Command 'Invoke-WebRequest') {
        Invoke-WebRequest $source -OutFile $destination
    }
    else {
        $WebClient = New-Object System.Net.WebClient
        $webclient.DownloadFile($source, $destination)
    }

    Start-Process -FilePath "$workdir\firefox.exe" -ArgumentList "/S"

    Start-Sleep -s 35

    Remove-Item -Force $workdir/firefox*
    Remove-Item "C:\installer"

    New-Item -Path "C:\" -Name "firefox_installed" -ItemType File
}
else {
    Write-Host "Firefox already installed."
}

Push-Location
Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
Set-ItemProperty . HideFileExt "0"
Pop-Location
Stop-Process -processName: Explorer -force # This will restart the Explorer service to make this work.

DownloadMozillaThunderbird

# Add to domain
if (!(Test-Path "C:\added_to_domain")) {
    $domainName = Read-Host "Enter a domain name you want to join"

    New-Item -Path "C:\" -Name "added_to_domain" -ItemType File

    Add-Computer -DomainName $domainName -Restart
}
else {
    Write-Host "Already in domain."
}