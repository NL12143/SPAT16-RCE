
#GLOBAL    
$farmServers = @{
    "P3000738" = "DEV-1"  
    "P3000739" = "DEV-2"  
}

$farmServers
$farmServers.Keys
$farmServers.Keys($server) 
$farmServers.Item($server)
$role = $farmServers.Item($server)

#WINDOWS
foreach ($server in $farmServers.Keys) {
    Write-Output "Server: " + ENV:ComputerName + " " + $role = $farmServers.Item($server) 
}

#INVOKE 
$creds = Get-Credential "dnbAD\NC2643B" 
$server = "P3000738"   
$servers = "P3000738", "P3000739"
$script   = ".\Configure-Loopback.ps1"
foreach ($server in $server) {
    Write-Output "Invoke command " $script "to "$server   
    Invoke-Command -ComputerName $server -FilePath $script `
    # -Credential $creds.Setup -Authentication CredSSP # For Windows no need credSSP 
    # ?How to check for credSSP > Enable-WinRM 
    }

