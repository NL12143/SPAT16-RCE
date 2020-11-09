function reboot-Server {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $false, Position = 0)]
        $computerName
    )
    
    Write-Output "restarting server $computerName "
    Restart-Computer -Protocol WSMan -Wait -For PowerShell -ComputerName $computerName -Force | Out-Null
    Write-Output "$computerName rebooted"
}
