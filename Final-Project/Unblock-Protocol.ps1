
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
<#
.SYNOPSIS
    Unblock protocol in the firewall.
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Unblock-Protocol -Protocol 25
    Unblock-Protocol -Protocol SMTP

    Unblocks SMTP protocol.
#>
function Unblock-Protocol {
    [CmdletBinding()]
    param (
        # protocol to unblock
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]
        $Protocol
    )
    
    begin {
        if (Test-Path "C:\allow_$Protocol") {
            Write-Host "Protocol $Protocol already unblocked in both IN and OUT directions." -ForegroundColor Yellow
            break
        }
    }
    
    process {
        New-NetFirewallRule -DisplayName "Allow $Protocol In Requests" -Direction Inbound -Program Any -Protocol $Protocol -Action Allow
        New-NetFirewallRule -DisplayName "Allow $Protocol Out Requests" -Direction Outbound -Program Any -Protocol $Protocol -Action Allow
    
        New-Item -Path "C:\" -Name "allow_$Protocol" -ItemType File
    }
    
    end {
        Write-Host "Protocol $Protocol successfully enabled." -ForegroundColor Green
    }
}#Unblock-Protocol