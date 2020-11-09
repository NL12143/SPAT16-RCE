
$farmServers = @{
    "P3000738" = "DEV-AutoSP"  
    "P3000738" = "DEV-Roeland"  
    "P3000739" = "DEV-Jean"  
    "P3000740" = "DEV-Jan"  
}

$farmServers
$farmServers.Keys
$farmServers.Keys($server) 
$farmServers.Item($server)
$role = $farmServers.Item($server)

foreach ($server in $farmServers.Keys) {
    Write-Output "Server: " + ENV:ComputerName + " " + $role = $farmServers.Item($server) 
    }

$creds = Get-Credential "dnbAD\NC2643B" 
$server = "P3000738" = "DEV-Roeland"  
$loopbackScript   = ".\Configure-Loopback.ps1"
Invoke-Command -ComputerName $server -FilePath $loopbackScript `
# -Credential $creds.Setup -Authentication CredSSP # For Windows no need credSSP 
# ?How to check for credSSP > Enable-WinRM 

#region MACHINE_PREP
try {
    Write-Output "$time : Performing Server Preparation..."
    foreach ($server in $farmServers.Keys) 
    {
    $role = $farmServers.Item($server)

    # Disable Loopback Check on all servers
    Invoke-Command -ComputerName $server -FilePath $loopbackScript `
                    -Credential $creds.Setup -Authentication CredSSP

    # Bypass CRL Checking for the .Net Framework on all servers
    Invoke-Command -ComputerName $server -FilePath $crlBypassScript `
                    -Credential $creds.Setup -Authentication Credssp
    }
Write-Output "$time : Server Preparation complete!"
}
catch {
    Write-Host "OOOPS! We failed during server preperation." -ForegroundColor Red
    $_
    Pause
    }
#endregion MACHINE_PREP

$farmServers
$farmServers.Keys


$loopbackScript   = ".\Configure-Loopback.ps1"
$crlBypassScript  = ".\Configure-CrlBypass.ps1"

Configure-Loopback.ps1 # disables the loopback check
$lsaPath = "HKLM:\System\CurrentControlSet\Control\Lsa"
$lsaPathValue = Get-ItemProperty -path $lsaPath
If (-not ($lsaPathValue.DisableLoopbackCheck -eq "1"))
{
    New-ItemProperty HKLM:\System\CurrentControlSet\Control\Lsa -Name "DisableLoopbackCheck" -value "1" -PropertyType dword -Force | Out-Null
    Write-Warning "A server restart on ($env:ComputerName) is needed for the loopback setting to take effect." 
}
Write-Output "$(Get-Date -Format T) : Loopback Check Disabled on $env:ComputerName"

