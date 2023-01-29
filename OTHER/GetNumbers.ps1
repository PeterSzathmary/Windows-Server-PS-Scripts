function Get-Numbers {
    [CmdletBinding(SupportsPaging)]
    param()

    $FirstNumber = [System.Math]::Min($PSCmdlet.PagingParameters.Skip, 100)
    $LastNumber = [System.Math]::Min($PSCmdlet.PagingParameters.First + $FirstNumber - 1, 100)

    if ($PSCmdlet.PagingParameters.IncludeTotalCount) {
        $TotalCountAccuracy = 1.0
        $TotalCount = $PSCmdlet.PagingParameters.NewTotalCount(100, $TotalCountAccuracy)
        Write-Output $TotalCount
    }
    $FirstNumber .. $LastNumber | Write-Output
}