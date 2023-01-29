$computers = @("SRV1", "SRV2", "SRV3")

function Install-Software {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("1", "2")]
        [string] $Version,

        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $ComputerName
    )

    process {
        Write-Host "I installed software version $Version on $ComputerName. Yippee!"
    }
}

#foreach ($pc in $computers) {
#    Install-Software -Version 2 -ComputerName $pc
#}

$computers | Install-Software -Version 2