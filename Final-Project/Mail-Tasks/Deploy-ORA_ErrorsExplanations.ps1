<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Deploy-ORA_ErrorsExplanations {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        sqlplus.exe / as sysdba "@C:\Users\Administrator\Desktop\Final-Project\SQL\master.sql"

        $file = "C:\users_sperrorlogs.csv"

        (Get-Content $file | Select-Object -Skip 1) | Set-Content $file

        $sperrorlogs = Import-Csv -Path $file

        foreach ($sperrorlog in $sperrorlogs) {

            $errorPathFile = "C:\$($sperrorlog.owner.ToLower())_errors.txt"

            if (Test-Path $errorPathFile) {
                Clear-Content $errorPathFile
            }

            #Write-Host $sperrorlog.owner

            Add-Content -Path $errorPathFile "$($sperrorlog.owner) errors : "
    
            sqlplus.exe / as sysdba "@C:\Users\Administrator\Desktop\Final-Project\SQL\show_ora_msgs.sql" "'$($errorPathFile)'" "'$($sperrorlog.owner.ToLower()).sperrorlog'"

            # $ORA_line = if pjake.errors.txt -> starts line with ORA copy the line
    
            $ORA_lines = get-content $errorPathFile -ReadCount 1000 |
            ForEach-Object { $_ -match "ORA-" }

            if (Test-Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt") {
                Clear-Content "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt"
            }

            Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" "BE CAREFUL FOR THESE ERRORS : `n"

            foreach ($ORA_line in $ORA_lines) {

                $pos = $ORA_line.IndexOf(":")
                $leftPart = $ORA_line.Substring(0, $pos)

                # ORA-00001:
                #Write-Host $leftPart
                $ORA_number = $leftPart.Replace("ORA-", "")

                Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" $ORA_line
                Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" $(oerr ora $ORA_number)
                Add-Content -Path "C:\$($sperrorlog.owner.ToLower())_errors_explained.txt" ""
            }
        }
    }
    
    process {
        
    }
    
    end {
        
    }
}