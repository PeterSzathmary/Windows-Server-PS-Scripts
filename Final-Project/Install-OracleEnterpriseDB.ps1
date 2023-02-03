<#
.SYNOPSIS
    Installs Oracle Enterprise DB
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Install-OracleEnterpriseDB -DBResponseFilePath ".\db.rsp"
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Install-OracleEnterpriseDB {
    [CmdletBinding()]
    param (
        # database response file
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $DBResponseFilePath
    )
    
    begin {
        $Flag = "oracle_enterprise_installed"
        if (Test-Path "C:\$Flag") {
            Write-Host "Oracle Enterprise DB already installed" -ForegroundColor Yellow
            break
        }
    }
    
    process {
        $oracleDBProductPath = "C:\app\19c\product"
        $oracleDBBasePath = "C:\app\19c\base"

        New-Item -ItemType Directory -Force -Path $oracleDBProductPath
        New-Item -ItemType Directory -Force -Path $oracleDBBasePath

        #extract archive to c -> app -> 19c -> product
        Write-Host -ForegroundColor Magenta "Wait until the download process of Oracle DB is finished. Start Expanding? Press ENTER to continue... " -NoNewline
        Read-Host
        Expand-Archive "C:\Users\Administrator\Downloads\WINDOWS.X64_193000_db_home.zip" -DestinationPath $oracleDBProductPath

        #C:\app\19c\product\bin to path # should be already there

        #C:\app\19c\product\setup.exe /s /v"RSP_FILE=C:\Users\Administrator\Desktop\db.rsp" /v"/L*v C:\Users\Administrator\Desktop\setup.log" /v"/qn"
        if (Test-Path $DBResponseFilePath) {
            C:\app\19c\product\setup.exe -silent -responseFile $DBResponseFilePath
            New-Item -Path "C:\" -Name $Flag -ItemType File
        }
        else {
            Write-Host "Response file is not FOUND!"
            Start-Sleep -Seconds 10
            Exit
        }

        # set ORACLE_HOME
    }
    
    end {
        Write-Host "Oracle Enterprise DB successfully installed" -ForegroundColor Yellow
    }
}#Install-OracleEnterpriseDB