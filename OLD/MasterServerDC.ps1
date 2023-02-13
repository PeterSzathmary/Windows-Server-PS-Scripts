# replace <?email?> with your email
# replace <?password?> with your password

$domainName = "windows.lab"
$allIsDone = $false
$staticIP = "10.0.0.1"
$renameComputer = "WIN-DC-001"
$hMailAdminPassword = "Start123"

# this array will hold all developers in the team
$swotMembers = @()

# restart script after renamed computer
# restart script after ad ds installation

#################################################################################
##
##  Windows Firewall Advanced
##  allow inbound and outbound rules for (25 SMTP), (110 POP3), (143 IMAP)
##
##  DNS MANAGER
##  add MX record to DNS forward lookup zone
##  
##  hMailServer Administrator
##  SMTP protocol: set local host name, RFC compliance check all, advanced bind local IP address to server IP address
##  Logging: check enabled, and log all
##  Advanced: IP ranges: my computer: requires SMTP authentication: check both local
##
##
## if something doesn't work TRY TO TRUN OFF FIREWALL (server & client) !!!!!! ----> in server how to separate networks so windows.lab is on ethernet1 and nat on ethernet0
## OR OR OR disable only domain network in firewall in server so client can connect to server on port 25
## on Thunderbird USE POP3 (when to use IMAP create account without password and later change in Thunderbird account settings <username>@<>)

# if flags doesn't exists, create them
# it starts the script after logging into OS
if (!(Test-Path -Path "HKLM:\SOFTWARE\MyFlags")) {
    New-Item -Path "HKLM:\SOFTWARE" -Name "MyFlags"
    New-ItemProperty -Path "HKLM:\Software\MyFlags" -Name "StartAtLogon" -Value 1
    New-Item `
        -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" `
        -Name "startup.cmd" `
        -ItemType "file" `
        -Value 'start powershell -noexit -file C:\Users\Administrator\Desktop\MasterServerDC.ps1'
}

# Disable MapsBroker service
function DisableMapsBroker {
    if (!(Test-Path "C:\maps_broker_disabled")) {
        Get-Service -Name MapsBroker | Set-Service -StartupType Disabled -Confirm:$false
    
        New-Item -Path "C:\" -Name "maps_broker_disabled" -ItemType File
    }
    else {
        Write-Host "MapsBroker already disabled."
    }
}

# Static IP
function SetStaticIP {
    if (!(Test-Path "C:\static_ip")) {
        Get-NetIPConfiguration
        $width = [Console]::WindowWidth
        Write-Host ("-" * $width + "`n")
        Write-Host "Please enter which interface you want to configure." -ForegroundColor Green
        $interfaceIndex = Read-Host "Choose the interface index (-1 for exit)"
        if ($interfaceIndex -ne -1) {
            # $ip = Read-Host "New IP Address"
            $ip = $staticIP
            # $primaryDNS = Read-Host "Set primary DNS"
            $primaryDNS = $staticIP
            # $secondaryDNS = Read-Host "Set secondary DNS"
            $secondaryDNS = ""
    
            Start-Sleep 3
            #Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceIndex 10).InterfaceGuid)" -Name EnableDHCP -Value 0
            New-NetIPAddress -IPAddress $ip -PrefixLength 24 -InterfaceIndex $interfaceIndex
            Start-Sleep 3
            Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($primaryDNS, $secondaryDNS)
        }
    
        New-Item -Path "C:\" -Name "static_ip" -ItemType File
    }
    else {
        Write-Host "Static IP already configured."
    }
}

# Allow ICMPv4 (ping)
function AllowICMPv4 {
    if (!(Test-Path "C:\allow_icmpv4")) {
        New-NetFirewallRule -DisplayName "Allow ICMPv4 In Requests" -Direction Inbound -Program Any -Protocol ICMPv4 -Action Allow
        New-NetFirewallRule -DisplayName "Allow ICMPv4 Out Requests" -Direction Outbound -Program Any -Protocol ICMPv4 -Action Allow
    
        New-Item -Path "C:\" -Name "allow_icmpv4" -ItemType File
    }
    else {
        Write-Host "ICMPv4 In and Out requests already configured."
    }
}

function AllowSMTP {
    if (!(Test-Path "C:\allow_smtp")) {
        New-NetFirewallRule -DisplayName "Allow SMTP In Requests" -Direction Inbound -Program Any -Protocol 25 -Action Allow
        New-NetFirewallRule -DisplayName "Allow SMTP Out Requests" -Direction Outbound -Program Any -Protocol 25 -Action Allow
    
        New-Item -Path "C:\" -Name "allow_smtp" -ItemType File
    }
    else {
        Write-Host "SMTP In and Out requests already configured."
    }
}

function AllowPOP3 {
    if (!(Test-Path "C:\allow_pop3")) {
        New-NetFirewallRule -DisplayName "Allow POP3 In Requests" -Direction Inbound -Program Any -Protocol 110 -Action Allow
        New-NetFirewallRule -DisplayName "Allow POP3 Out Requests" -Direction Outbound -Program Any -Protocol 110 -Action Allow
    
        New-Item -Path "C:\" -Name "allow_pop3" -ItemType File
    }
    else {
        Write-Host "POP3 In and Out requests already configured."
    }
}

function AllowIMAP {
    if (!(Test-Path "C:\allow_imap")) {
        New-NetFirewallRule -DisplayName "Allow IMAP In Requests" -Direction Inbound -Program Any -Protocol 143 -Action Allow
        New-NetFirewallRule -DisplayName "Allow IMAP Out Requests" -Direction Outbound -Program Any -Protocol 143 -Action Allow
    
        New-Item -Path "C:\" -Name "allow_imap" -ItemType File
    }
    else {
        Write-Host "IMAP In and Out requests already configured."
    }
}

# Rename computer
function RenameComputer {
    if (!(Test-Path "C:\computer_renamed")) {
        # $newName = Read-Host "New name for computer"
        $newName = $renameComputer
        Write-Host "The computer name will be renamed to: $newName"

        New-Item -Path "C:\" -Name "computer_renamed" -ItemType File
    
        Start-Sleep -Seconds 5

        Rename-Computer -NewName $newName -Restart

    }
    else {
        Write-Host "Computer already renamed."
    }
}

# Install ADDS
function InstallADDS {
    if (!(Test-Path "C:\adds_installed")) {
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
        New-Item -Path "C:\" -Name "adds_installed" -ItemType File
    }
    else {
        Write-Host "ADDS already installed."
    }
}

# Install forest
function InstallForest {
    if (!(Test-Path "C:\forest_installed")) {
    
        # $password = Read-Host "Enter SafeModeAdministratorPassword" -AsSecureString
        $password = "IWillNeverUseIt_123"
        $secureString = ConvertTo-SecureString $password -AsPlainText -Force
        $domain = $domainName
        Install-ADDSforest -DomainName $domain -InstallDns -SafeModeAdministratorPassword $secureString -Confirm:$false
    
        New-Item -Path "C:\" -Name "forest_installed" -ItemType File
    }
    else {
        Write-Host "ADDS forest already installed."
    }
}

# Enable AD Recycle Bin
function EnableADRecycleBin {
    if (!(Test-Path "C:\ad_recycle_bin_enabled")) {
        $computerName = hostname.exe
        $domain = $domainName
        Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target $domain -Server $computerName -Confirm:$false
    
        New-Item -Path "C:\" -Name "ad_recycle_bin_enabled" -ItemType File
    }
    else {
        Write-Host "AD recycle bin already enabled."
    }
}

# Install DHCP
function InstallDHCP {
    if (!(Test-Path "C:\dhcp_installed")) {
        Install-WindowsFeature DHCP -IncludeManagementTools
        Add-DhcpServerInDC -DnsName $domainName -IPAddress $staticIP
        Add-DhcpServerSecurityGroup
        Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
        Restart-Service -Name DHCPServer -Force
    
        # Configuration
        Import-Module DHCPServer
        # Create new inactive scope
        Add-DhcpServerv4Scope -Name "Students3v" -StartRange 10.0.0.30 -EndRange 10.0.0.60 -SubnetMask 255.255.255.0 -State InActive
        Set-DhcpServerv4OptionValue -ScopeID 10.0.0.0 -DnsDomain $domainName -DnsServer 10.0.0.1 # -Router 192.168.113.1
        # Activate
        Set-DhcpServerv4Scope -ScopeID 10.0.0.0 -State Active
    
        New-Item -Path "C:\" -Name "dhcp_installed" -ItemType File
    }
    else {
        Write-Host "DHCP already installed."
    }
}

# Create OU Students
function CreateOUStudents {
    if (!(Test-Path "C:\ou_students_created")) {
        $forest = Get-ADDomain | Select-Object -ExpandProperty Forest
        $arr = $forest.Split(".")
        $organizationalUnit0 = "Students"
        New-ADOrganizationalUnit -Name "$organizationalUnit0" -Path "DC=$($arr[0].ToUpper()),DC=$($arr[1].ToUpper())" -ProtectedFromAccidentalDeletion $false
    
        New-Item -Path "C:\" -Name "ou_students_created" -ItemType File
    }
    else {
        Write-Host 'OU "Students" already created.'
    }
}

$swotGroupName = "SWOT Developers"
function CreateNewADGroup {
    $forest = Get-ADDomain | Select-Object -ExpandProperty Forest
    $arr = $forest.Split(".")
    $groupDescription = "Members of this group are SWOT Developers"
    New-ADGroup -Name $swotGroupName -SamAccountName $swotGroupName -GroupCategory Security -GroupScope Global -DisplayName $swotGroupName -Path "CN=Users,DC=$($arr[0]),DC=$($arr[1])" -Description $groupDescription
}

# Create new AD users
function CreateNewADUsers {
    if (!(Test-Path "C:\students_created")) {
        if (!(Test-Path "C:\Users\Administrator\Desktop\MOCK_DATA.csv")) {
            Write-Host "Missing MOCK_DATA.csv"
            Start-Sleep -Seconds 10
            Exit
        }
        Write-Host "Creating students..."
        $data = Import-Csv -Path C:\Users\Administrator\Desktop\MOCK_DATA.csv
        $defaultPassword = ConvertTo-SecureString "Changeme123" -AsPlainText -Force
        foreach ($student in $data) {

            $samAccountName = "$($student.first_name.Substring(0, 1))$($student.last_name)".ToLower()

            if ($student.team -eq "swot") {
                $swotMembers += $samAccountName
            }
            
            New-ADUser `
                -Name "$($student.first_name) $($student.last_name)" `
                -GivenName "$($student.first_name)" `
                -Surname "$($student.last_name)" `
                -UserPrincipalName "$($student.first_name).$($student.last_name)@$domainName" `
                -SamAccountName $samAccountName `
                -AccountPassword $defaultPassword `
                -Path "OU=STUDENTS,DC=WINDOWS,DC=LAB"
    
            Set-ADUser -Identity $samAccountName -ChangePasswordAtLogon $true
            Enable-ADAccount -Identity $samAccountName
        }

        Add-ADGroupMember -Identity $swotGroupName -Members $swotMembers
    
        New-Item -Path "C:\" -Name "students_created" -ItemType File
    }
    else {
        Write-Host "Students already created."
    }
}

# Create new GPO "Proxy GPO Settings"
function CreateGPOProxySettings {
    if (!(Test-Path "C:\proxy_gpo_created")) {

        New-GPO -Name "Proxy Settings GPO" -Comment "Proxy settings for OU Students"
    
        Set-GPPrefRegistryValue -Context "User" -Action "Update" -Name "Proxy Settings GPO" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ValueName "ProxyEnable" -Type Dword -Value 00000001
        Set-GPPrefRegistryValue -Context "User" -Action "Update" -Name "Proxy Settings GPO" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ValueName "ProxyServer" -Type String -Value "10.0.0.1:8080"
        Set-GPPrefRegistryValue -Context "User" -Action "Update" -Name "Proxy Settings GPO" -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ValueName "ProxyOverride" -Type String -Value "<local>"
    
        # Prevent users from changing proxy settings.
        Set-GPRegistryValue -Name "Proxy Settings GPO" -Key "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel" -ValueName "Proxy" -Type Dword -Value 00000001
    
        Get-GPO "Proxy Settings GPO" | New-GPLink -Target "OU=STUDENTS,DC=WINDOWS,DC=LAB"
    
        New-Item -Path "C:\" -Name "proxy_gpo_created" -ItemType File
    }
    else {
        Write-Host "Proxy GPO already created."
    }
}

# Install Firefox
function InstallFirefox {
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
}

function ShowFileExtensions() {
    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    Set-ItemProperty . HideFileExt "0"
    Pop-Location
    Stop-Process -processName: Explorer -force # This will restart the Explorer service to make this work.
}

function InstallNETFramework {
    Install-WindowsFeature Net-Framework-Core
}

function Download_hMailServer() {
    # https://adamtheautomator.com/hmailserver/
    if (!(Test-Path "C:\hMailServer_downloaded")) {
        
        $url = "https://www.hmailserver.com/files/hMailServer-5.6.8-B2574.exe"
        $output = "C:\Users\Administrator\Downloads\hMailServer_setup.exe"
        $start_time = Get-Date
    
        Invoke-WebRequest -Uri $url -OutFile $output

        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

        New-Item -Path "C:\" -Name "hMailServer_downloaded" -ItemType File
    }
    else {
        Write-Host "hMailServer already downloaded."
    }
}

function DownloadMozillaThunderbird {
    if (!(Test-Path "C:\mozillaThunderbird_downloaded")) {
        
        $url = "https://download.mozilla.org/?product=thunderbird-102.6.1-SSL&os=win64&lang=en-US"
        $output = "C:\Users\Administrator\Downloads\mozillaThunderbird.exe"
        $start_time = Get-Date
    
        Invoke-WebRequest -Uri $url -OutFile $output

        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

        New-Item -Path "C:\" -Name "mozillaThunderbird_downloaded" -ItemType File
    }
    else {
        Write-Host "Mozilla Thunderbird already downloaded."
    }
}

function DownloadPostgreSql {
    if (!(Test-Path "C:\postgresql_downloaded")) {
        
        #$url = "(New-Object Net.WebClient).DownloadFile('https://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows-x64.exe', $exePath)"
        $url = "https://get.enterprisedb.com/postgresql/postgresql-14.5-1-windows-x64.exe"
        $output = "C:\Users\Administrator\Downloads\postgresql_14_setup.exe"
        $start_time = Get-Date
    
        Invoke-WebRequest -Uri $url -OutFile $output

        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

        New-Item -Path "C:\" -Name "postgresql_downloaded" -ItemType File
    }
    else {
        Write-Host "PostgreSql already downloaded."
    }
}

function DownloadOracleDB {
    if (!(Test-Path "C:\oracle_downloaded")) {
        
        $url = "https://download.oracle.com/otn-pub/otn_software/db-express/OracleXE213_Win64.zip"
        $output = "C:\Users\Administrator\Downloads\oracle.zip"
        $start_time = Get-Date
    
        Invoke-WebRequest -Uri $url -OutFile $output

        Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

        Expand-Archive "C:\Users\Administrator\Downloads\oracle.zip" -DestinationPath "C:\Users\Administrator\Downloads\oracle"

        New-Item -Path "C:\" -Name "oracle_downloaded" -ItemType File
    }
    else {
        Write-Host "Oracle DB already downloaded."
    }
}

function ConfigureDNS {
    if (!(Test-Path "C:\dns_configured")) {
        # 1. create record A (@) point to IP server
        Add-DnsServerResourceRecordA -Name "mail" -ZoneName "windows.lab" -IPv4Address "10.0.0.1"
        # MX record
        Add-DnsServerResourceRecordMX -Preference 10  -Name "windows.lab" -MailExchange "mail.windows.lab" -ZoneName "windows.lab"
        # add reverse lookup zone primary
        Add-DnsServerPrimaryZone -NetworkID "10.0.0.0/24" -ReplicationScope "Forest"
        # reverse PTR records
        # TODO: fix (it doesn't set correct Name in DNS like this: 10.0.0.1)
        # Add-DnsServerResourceRecordPtr -Name "10" -ZoneName "0.0.10.in-addr.arpa" -PtrDomainName "WIN-DC-001.windows.lab"
        New-Item -Path "C:\" -Name "dns_configured" -ItemType File
    }
    else {
        Write-Host "DNS already configured."
    }
}

function InstallOracleDB {
    <# #Do not leave any parameter with empty value
    #Install Directory location, username can be replaced with current user
    INSTALLDIR=C:\app\product\21c\
    #Database password, All users are set with this password, Remove the value once installation is complete
    PASSWORD=passwordvalue
    #If listener port is set to 0, available port will be allocated starting from 1521 automatically
    LISTENER_PORT=0
    #If EM express port is set to 0, available port will be used starting from 5550 automatically
    EMEXPRESS_PORT=0
    #Specify char set of the database
    CHAR_SET=AL32UTF8
    #Specify the database comain for the db unique name specification
    DB_DOMAIN=oracleserverdb
    ORACLE_HOME="C:\app\product" #>

    C:\Users\Administrator\Downloads\oracle\setup.exe /s /v"RSP_FILE=C:\Users\Administrator\Downloads\oracle\XEInstall.rsp" /v"/L*v C:\Users\Administrator\Downloads\oracle\setup.log" /v"/qn"
}

function DownloadOracleEnterpriseDB {
    if (!(Test-Path "C:\oracle_enterprise_downloaded")) {
        $p = "C:\tools\selenium"
        Import-Module "$($p)\WebDriver.dll"

        $chromeOptions = [OpenQA.Selenium.Chrome.ChromeOptions]::new()
        $chromeOptions.AddArgument("start-maximized")
        $chromeOptions.AddArgument("incognito")
        $chromeOptions.AddArgument("headlesss")
        $chromeOptions.AddArgument("disable-gpu")


        $chromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver -ArgumentList $chromeOptions
        $chromeDriver.Url = "https://www.oracle.com/database/technologies/oracle-database-software-downloads.html"

        #$iframe = '/html/body/div[5]/div/iframe'

        Start-Sleep 5

        $chromeDriver.SwitchTo().Frame(1)
        $acceptAll = "/html/body/div[8]/div[1]/div/div[3]/a[1]"

        $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($acceptAll)).Click()

        $chromeDriver.SwitchTo().ParentFrame()
        Start-Sleep 5

        #$downloadZIP = "/html/body/div[2]/section[3]/div/div[1]/div/table/tbody/tr/td[2]/div/a"
        # Windows x64 zip
        $downloadZIP = "/html/body/div[2]/section[3]/div/div[2]/div/table/tbody/tr[1]/td[2]/div/a"

        $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($downloadZIP)).Click()
        $checkbox = "/html/body/div[7]/div/div[1]/div/div/div/form/ul/li/label/input"

        $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($checkbox)).Click()
        $download = "/html/body/div[7]/div/div[1]/div/div/div/form/div/div[2]/div/div/a"

        $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($download)).Click()
        $email = "//*[@id='sso_username']"
        $password = '//*[@id="ssopassword"]'
        $signin = '//*[@id="signin_button"]'
        $emailToDownload = Read-Host "Email"
        $passwordToDownload = Read-Host "Password"
        $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($email)).SendKeys($emailToDownload)
        $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($password)).SendKeys($passwordToDownload)
        $chromeDriver.FindElement([OpenQA.Selenium.By]::XPath($signin)).Click()

        New-Item -Path "C:\" -Name "oracle_enterprise_downloaded" -ItemType File
    }
    else {
        Write-Host "Oracle Enterprise DB already downloaded."
    }
}

function InstallOracleEnterpriseDB {
    if (!(Test-Path "C:\oracle_enterprise_installed")) {
        $oracleDBProductPath = "C:\app\19c\product"
        $oracleDBBasePath = "C:\app\19c\base"

        New-Item -ItemType Directory -Force -Path $oracleDBProductPath
        New-Item -ItemType Directory -Force -Path $oracleDBBasePath

        #extract archive to c -> app -> 19c -> product
        Read-Host "Start Expanding? "
        Expand-Archive "C:\Users\Administrator\Downloads\WINDOWS.X64_193000_db_home.zip" -DestinationPath $oracleDBProductPath
    
        #C:\app\19c\product\bin to path # should be already there

        #C:\app\19c\product\setup.exe /s /v"RSP_FILE=C:\Users\Administrator\Desktop\db.rsp" /v"/L*v C:\Users\Administrator\Desktop\setup.log" /v"/qn"
        if (Test-Path "C:\Users\Administrator\Desktop\db.rsp") {
            C:\app\19c\product\setup.exe -silent -responseFile "C:\Users\Administrator\Desktop\db.rsp"
            New-Item -Path "C:\" -Name "oracle_enterprise_installed" -ItemType File
        }
        else {
            Write-Host "Response file is not FOUND!"
            Start-Sleep -Seconds 10
            Exit
        }

        # set ORACLE_HOME
    }
    else {
        Write-Host "Oracle Enterprise DB already installed."
    }
}

function Install7Zip {
    if (!(Test-Path "C:\7zip_installed")) {
        $dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Download') -and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe") } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        # modified to work without IE
        # above code from: https://perplexity.nl/windows-powershell/installing-or-updating-7-zip-using-powershell/
        $installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
        Invoke-WebRequest $dlurl -OutFile $installerPath
        Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
        Remove-Item $installerPath

        New-Item -Path "C:\" -Name "7zip_installed" -ItemType File
    }
    else {
        Write-Host "7zip already installed."
    }
}

function InstallChocolatey {
    if (!(Test-Path "C:\chocolatey_installed")) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        New-Item -Path "C:\" -Name "chocolatey_installed" -ItemType File
    }
    else {
        Write-Host "Chocolatey already installed."
    }
}

function InstallSeleniumWebDriverDll() {
    if (!(Test-Path "C:\selenium_webdriver_dll_downloaded")) {
        $url = "https://www.nuget.org/api/v2/package/Selenium.WebDriver/4.5.1"
        $out = "C:\Users\Administrator\Downloads\selenium_webdriver.zip"

        Invoke-WebRequest -Uri $url -OutFile $out
        Expand-Archive "C:\Users\Administrator\Downloads\selenium_webdriver.zip" -DestinationPath "C:\Users\Administrator\Downloads\selenium_webdriver"

        Copy-Item -Path "C:\Users\Administrator\Downloads\selenium_webdriver\lib\net48\WebDriver.dll" -Destination "C:\tools\selenium"

        New-Item -Path "C:\" -Name "selenium_webdriver_dll_downloaded" -ItemType File
    }
    else {
        Write-Host "Selenium WebDriver DLL already downloaded."
    }
}

function InstallChromeDriverWithChoco {
    if (!(Test-Path "C:\chrome_driver_installed")) {
        choco install selenium-chrome-driver --force -y # c:\tools\selenium
        New-Item -Path "C:\" -Name "chrome_driver_installed" -ItemType File
    }
    else {
        Write-Host "Chrome driver already installed."
    }
}

function InstallChromeBetaWithChoco {
    if (!(Test-Path "C:\chrome_beta_installed")) {
        choco install googlechromebeta --pre -y

        $chromePath = "C:\Program Files\Google\Chrome\Application"

        New-Item -ItemType Directory -Force -Path $chromePath
        Copy-Item -Path "C:\Program Files\Google\Chrome Beta\Application\*" -Destination $chromePath -Recurse
    
        New-Item -Path "C:\" -Name "chrome_beta_installed" -ItemType File
    }
    else {
        Write-Host "Chrome Beta already installed."
    }
}

function InstallChromeBetaOfficially {
    if (!(Test-Path "C:\chrome_beta_installed")) {
        $chromePath = "C:\Program Files\Google\Chrome\Application"

        New-Item -ItemType Directory -Force -Path $chromePath

        $url = "https://dl.google.com/tag/s/appguid%3D%7B8237E44A-0054-442C-B6B6-EA0509993955%7D%26iid%3D%7B2ECB1D76-9481-D047-CBDC-9AE27B179AB2%7D%26lang%3Den%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%2520Beta%26needsadmin%3Dprefers%26ap%3D-arch_x64-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"
        $out = "C:\Users\Administrator\Downloads\chrome_beta.exe"

        Invoke-WebRequest -Uri $url -OutFile $out

        C:\Users\Administrator\Downloads\chrome_beta.exe | Out-Null
        Copy-Item -Path "C:\Program Files\Google\Chrome Beta\Application\*" -Destination $chromePath -Recurse
        #https://dl.google.com/tag/s/appguid%3D%7B8237E44A-0054-442C-B6B6-EA0509993955%7D%26iid%3D%7B2ECB1D76-9481-D047-CBDC-9AE27B179AB2%7D%26lang%3Den%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%2520Beta%26needsadmin%3Dprefers%26ap%3D-arch_x64-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe
        New-Item -Path "C:\" -Name "chrome_beta_installed" -ItemType File
    }
    else {
        Write-Host "Chrome Beta already installed."
    }
}

function Install_hMailServer {
    if (!(Test-Path "C:\hMailServer_installed")) {
        #Start-Process -FilePath "C:\Users\Administrator\Downloads\hMailServer_setup.exe" -Verb RunAs -ArgumentList "/verysilent","/password=$hMailAdminPassword" -PassThru -NoNewWindow -Wait
        C:\Users\Administrator\Downloads\hMailServer_setup.exe /silent
        #Invoke-Command -ScriptBlock $pathvargs

        New-Item -Path "C:\" -Name "hMailServer_installed" -ItemType File
    }
    else {
        Write-Host "hMail server already installed."
    }
}

function Configure_hMailServer {
    if (!(Test-Path "C:\hMailServer_configured")) {
        # add domain: windows.lab
        #$hMSAdminPass = "Start123"
        $hMS = New-Object -COMObject hMailServer.Application
        Try {
            $hMS.Authenticate("Administrator", "") | Out-Null
            $hMSAddDomain = $hMS.Domains.Add()
            $hMSAddDomain.Name = "windows.lab"
            $hMSAddDomain.Active = $True
            $hMSAddDomain.Save()
        }
        Catch {
            Write-Host "Authentication failed."
        }

        # add accounts:
        $wlab = $hMS.Domains.ItemByName("windows.lab")

        # add administrator
        #cscript.exe C:\Users\Administrator\Desktop\Configure_hMailServer.vbs
        $newAccount = $wlab.Accounts.Add()
        $newAccount.Address = "administrator@windows.lab"
        #$newAccount.Password = 
        $newAccount.IsAD = $True
        $newAccount.ADUsername = "administrator"
        $newAccount.ADDomain = "windows.lab"
        $newAccount.AdminLevel = 0 # 0 - User 1 - Domain 2 - Server
        $newAccount.Active = $True
        $newAccount.MaxSize = 10
        $newAccount.Save()

        # get all students to array
        #$studentEmails = Get-ADUser -Filter * -SearchBase "OU=STUDENTS,DC=WINDOWS,DC=LAB"| Select-Object -ExpandProperty UserPrincipalName
        #$studentNames = Get-ADUser -Filter * -SearchBase "OU=STUDENTS,DC=WINDOWS,DC=LAB"| Select-Object -ExpandProperty Name
        $students = Get-ADUser -Filter * -SearchBase "OU=STUDENTS,DC=WINDOWS,DC=LAB" | Select-Object -Property Name, UserPrincipalName, SamAccountName

        foreach ($s in $students) {
            $newAccount = $wlab.Accounts.Add()
            $newAccount.Address = $s.SamAccountName + "@windows.lab"
            #$newAccount.Password = 
            $newAccount.IsAD = $True
            $newAccount.ADUsername = $s.SamAccountName
            $newAccount.ADDomain = "windows.lab"
            $newAccount.AdminLevel = 0 # 0 - User 1 - Domain 2 - Server
            $newAccount.Active = $True
            $newAccount.MaxSize = 10
            $newAccount.Save()
        }

        # settings: protocols: check all
        $hMS.Settings.ServiceIMAP = $True
        $hMS.Settings.ServicePOP3 = $True
        $hMS.Settings.ServiceSMTP = $True

        # settings: protocols: smtp: delivery of e-mail: set local host name to "windows.lab"
        $hMS.Settings.HostName = "windows.lab"

        # settings: protocols: smtp: rfc check all -> advanced: bind to local ip (ip of server 10.0.0.1)
        $hMs.Settings.SMTPDeliveryBindToIP = "10.0.0.1"

        # logging: enabled and check all (not keep files open)
        $hMS.Settings.Logging.Enabled = $True
        $hMS.Settings.Logging.LogApplication = $True
        $hMS.Settings.Logging.LogSMTP = $True
        $hMS.Settings.Logging.LogPOP3 = $True
        $hMS.Settings.Logging.LogIMAP = $True
        $hMS.Settings.Logging.LogTCPIP = $True
        $hMS.Settings.Logging.LogDebug = $True
        $hMS.Settings.Logging.AWStatsEnabled = $True

        # advanced: ip ranges: my computer: allow ALL connections, requires smtp all local, allow deliveries uncheck last


        # advanced: ip ranges: internet:    ----------------------------||-----------------------------------------------

        # TCP/IP ports keep 25 110 143 (all else delete)

        # utilities: set backup destination

        # run diagnostics

        New-Item -Path "C:\" -Name "hMailServer_configured" -ItemType File
    }
    else {
        Write-Host "hMail server already configured."
    }
}

function Main {
    # ShowFileExtensions # mám
    # DisableMapsBroker # mám
    # SetStaticIP # mám
    # AllowICMPv4 # mám
    # AllowIMAP # mám
    # AllowPOP3 # mám
    # AllowSMTP # mám
    # InstallFirefox # mám
    # RenameComputer # mám

    # Check if computer is renamed
    if (Test-Path "C:\computer_renamed") {
        # InstallADDS # mám
        # InstallForest # mám
        # EnableADRecycleBin # mám
        # InstallDHCP # mám
        # CreateOUStudents # mám
        # CreateNewADUsers # mám
        #CreateGPOProxySettings
        # InstallNETFramework # mám
        # Download_hMailServer # mám
        # DownloadMozillaThunderbird #mám
        # Install7Zip # mám
        # ConfigureDNS # mám

        # InstallChocolatey # mám
        #InstallChromeBetaWithChoco # checksum error
        # InstallChromeBetaOfficially # mám
        # InstallChromeDriverWithChoco # mám
        # InstallSeleniumWebDriverDll # mám
        
        # Install_hMailServer # mám
        # Configure_hMailServer # mám

        #DownloadOracleDB
        #DownloadPostgreSql
        # TODO:
        # wait for download oracle db to finish
        # DownloadOracleEnterpriseDB # mám
        if (Test-Path "C:\oracle_enterprise_downloaded") {
            InstallOracleEnterpriseDB
        }

        $allIsDone = $True
    }
    else {
        Write-Host "Please restart the computer" -ForegroundColor Yellow
    }

    # after all is done, remove in registry something that was starting the script on every logon
    if ($allIsDone) {
        <# Action to perform if the condition is true #>
    }
}

Main