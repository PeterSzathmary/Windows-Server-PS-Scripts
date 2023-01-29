Function Go-Verbose {
     [CmdletBinding()]Param()
     Write-Verbose "Alright, you prefer talkative functions. First of all, I appreciate your wish to learn more about the common parameter -Verbose. Secondly, blah blah.."
     Write-Host "This is self-explanatory, anyway."
}

Function Remove-ByForce {
     [cmdletbinding(SupportsShouldProcess)] 
     Param([string]$File)
     If ($PSCmdlet.ShouldContinue("Are you sure that you know what you are doing?","Delete with -Force parameter!")) {  
             Remove-Item $File -Force
     } Else {  
             "Mission aborted!"     
     } 
}
Remove-ByForce test -Confirm