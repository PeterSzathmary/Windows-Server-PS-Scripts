

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
    Send-Mail -To "Ainslee Ash <aash@windows.lab>" -From "Administrator <administrator@windows.lab>" -Subject "hello with HTML" -Attachments "C:\backup_log_13-02-2023-19-15-38.txt"

    -- OR --

    send mail with multiple attachments

    Send-Mail -To "Ainslee Ash <aash@windows.lab>" -From "Administrator <administrator@windows.lab>" -Subject "hello with HTML" -Attachments "C:\backup_log_13-02-2023-19-15-38.txt", "C:\schema_report_13-02-2023-18-23-05.txt"

    -- OR --

    send email with no attachments

    Send-Mail -To "Ainslee Ash <aash@windows.lab>" -From "Administrator <administrator@windows.lab>" -Subject "hello with HTML"

    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Send-Mail {
    [CmdletBinding()]
    param (
        # to whom send the mail
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $To,

        # from who
        [Parameter(
            Position = 1,
            Mandatory = $true
        )]
        [string]
        $From,

        # email subject
        [Parameter(
            Position = 2,
            Mandatory = $true
        )]
        [string]
        $Subject,

        # attachment
        [Parameter(
            Position = 3,
            Mandatory = $false
        )]
        [string[]]
        $Attachments
    )
    
    begin {
        $style = Get-Content "$env:UserProfile\Desktop\Final-Project\test.css" | Out-String

        $html = Get-Content "$env:UserProfile\Desktop\Final-Project\test.html" | Out-String
        $html = $html.Replace("/*VarStyle*/", $style)
        $html = $html.Replace("**VarUsername**", $($env:USERNAME))

        $body = ConvertTo-Html -PreContent @"
        $html
"@

        $mailParams = @{
            SmtpServer  = "localhost"
            to          = $To
            from        = $From
            Subject     = $Subject
            Body        = $($body | Out-String)
            BodyAsHtml  = $true
            Encoding    = "UTF8"
        }

        if ($Attachments) {
            $mailParams.Attachments = $Attachments
        }
        
    }
    
    process {
        Send-MailMessage @mailParams
    }
    
    end {
        
    }
}#Send-Mail