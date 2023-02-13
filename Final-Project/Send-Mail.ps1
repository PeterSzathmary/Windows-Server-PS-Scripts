


function Send-Mail {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        # $body= $style + $results
        # $body | Out-File c:\temp\html.html
        # $body1= (Get-Content c:\temp\html.html) | out-string 
        # sendEmail $body1
        $style = Get-Content "$env:UserProfile\Desktop\Final-Project\test.css" | Out-String
        # -CssUri "$env:UserProfile\Desktop\Final-Project\test.css"
        $body = ConvertTo-Html -PreContent @"
        <html>
            <head>
                <style>
                    $($style)
                </style>
            </head>
            <body>
                <h2>Folders older than 30 days</h2>
                <div>
                    Hello, from $($env:USERNAME)
                    <br></br>
                    Location: \\Server01\XFER\Cory
                </div>
                <br></br>
                ♕ This is an example of a <a href="#" class="tooltip" aria-label="The tooltip or a hint is a common GUI element that describes the item it's related to.">Tooltip</a>. Click on it to learn more.
            </body>
        </html>
"@

        $mailParams = @{
            SmtpServer = "localhost"
            to         = "Ainslee Ash <aash@windows.lab>"
            from       = "Administrator <administrator@windows.lab>"
            Subject    = "hello with HTML"
            Body       = $($body | Out-String)
            BodyAsHtml = $true
            Attachments = "C:\backup_log_13-02-2023-19-15-38.txt"
            Encoding    = "UTF8"
        }
        
    }
    
    process {
        Send-MailMessage @mailParams
    }
    
    end {
        
    }
}#Send-Mail