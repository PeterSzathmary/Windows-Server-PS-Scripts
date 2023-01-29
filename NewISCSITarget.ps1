$ipForInitiator = Read-Host "IP of Initiator"
New-IscsiServerTarget -TargetName "iscsiTarget1" -InitiatorId @("IPAddress:$ipForInitiator")