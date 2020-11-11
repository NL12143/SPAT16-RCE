


#region MACHINE_PREP
try {
    Write-Output "$time : Performing Server Preparation..."
    foreach ($server in $farmServers.Keys) {
    $role = $farmServers.Item($server)

    $scriptSSP = 
    Invoke-Command -ComputerName $server -FilePath $script `
                    -Credential $creds.Setup -Authentication Credssp
    }

    $scriptARG = 
    Invoke-Command -ComputerName $server -FilePath $script `
    -ArgumentList
}


#region XXX
$region = "Region XXX"
$title = "XXX"
$scriptPS = "Get-Service | Select Name" # $ENV:ComputerName 
try {
    Write-Output "$time : Performing " $title "on all servers."
    foreach ($server in $farmServers.Keys) 
    {
    $role = $farmServers.Item($server)
    Invoke-Command -ComputerName $server -FilePath $scriptPS 
    }
catch {
    Write-Host "OOOPS! We failed during " $title" -ForegroundColor Red
    $_
 #  Pause
    }
    
#region FINAL_TASKS
$region = "Final Tasks"
try {
    Write-Output "$time : Initiating all Health Analysis Jobs..."
    Get-SPTimerJob | Where-Object {$_.Title -like "Health Analysis Job*"} | Start-SPTimerJob
    Write-Host "$time : Farm Build Complete" -ForegroundColor Green
    Write-Host "* * * * * * * * * * * * * * * * * * * * * * * * * * *" -ForegroundColor DarkMagenta
    Write-Host "* * * * * * * * * * * * * * * * * * * * * * * * * * *" -ForegroundColor DarkMagenta
    Write-Host "* * * * * * * T H A N K S   F O R * * * * * * * * * *" -ForegroundColor DarkMagenta
    Write-Host "* * * * * * * * * S C R I P T * * * * * * * * * * * *" -ForegroundColor DarkMagenta
    Write-Host "* * * * * * * * * * * * * * * * * * * * * * * * * * *" -ForegroundColor DarkMagenta
    Write-Host "* * * * * * * * * * * * * * * * * * * * * * * * * * *" -ForegroundColor DarkMagenta

    Start-Process iexplore Central Administration
    }
catch {
    Write-Host "OOOPS! We failed during " $region -ForegroundColor Red 
    $_
    Pause
    }
#endregion FINAL_TASKS

#EOF