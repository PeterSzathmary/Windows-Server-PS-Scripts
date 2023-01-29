function Get-Sum() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [int] $a,

        [Parameter(Mandatory)]
        [int] $b
    )

    $c = $a + $b
    Write-Host "Sum of $a and $b is: $c"
}

function Get-Sum2() {
    [CmdletBinding()]
    Param(
        [int]$a,
        [int]$b
    )
    Write-Host "Sum of: $a + $b = $($a + $b)"
}