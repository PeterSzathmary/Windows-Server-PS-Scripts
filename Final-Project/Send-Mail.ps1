


function Send-Mail {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $body = ConvertTo-Html -PreContent @"
        <h2>Folders older than 30 days</h2>
        <div>
            Hello, from $($env:USERNAME)
            <br></br>
            Location: \\Server01\XFER\Cory
        </div>
        <br></br>
		<style>
/* --- Required CSS (not customizable) --- */

.tooltip:focus::after,
.tooltip:hover::after {
  content: attr(aria-label);
  display: block;
}

/* --- Required CSS (customizable) --- */

.tooltip:focus::after,
.tooltip:hover::after {
  position: absolute;
  top: 100%;
  font-size: 1.2rem;
  background-color: #f2f2f2;
  border-radius: 0.5rem;
  color: initial;
  padding: 1rem;
  width: 13rem;
  margin-top: 0.5rem;
  text-align: left;
}

.tooltip {
  position: relative;
  color: goldenrod;
  display: inline-block;
}

.tooltip:hover::before {
  top: 100%;
  right: 0;
  left: 0;
  margin: -1rem auto 0;
  display: block;
  border: solid transparent;
  content: "";
  height: 0;
  width: 0;
  position: absolute;
  pointer-events: none;
  border-bottom-color: #f2f2f2;
  border-width: 1rem;
}

/* --- Codepen styles - not required --- */

body {
  padding: 4rem 2rem;
  text-align: center;
  font-size: 2rem;
}
</style>

♕ This is an example of a <a href="#" class="tooltip" aria-label="The tooltip or a hint is a common GUI element that describes the item it's related to.">Tooltip</a>. Click on it to learn more.
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