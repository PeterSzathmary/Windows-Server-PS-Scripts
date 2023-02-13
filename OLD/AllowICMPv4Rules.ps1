$domain = Read-Host "Your Domain"
$GPORuleName = Read-Host "GPO Name"
New-NetFirewallRule -DisplayName "Allow ICMPv4 In Requests" -Direction Inbound -Program Any –Protocol ICMPv4 -Action Allow –PolicyStore "$domain\$GPORuleName"
New-NetFirewallRule -DisplayName "Allow ICMPv4 Out Requests" -Direction Outbound -Program Any –Protocol ICMPv4 -Action Allow –PolicyStore "$domain\$GPORuleName"