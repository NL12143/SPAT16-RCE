
#region GLOBAL
$sslWebApps = $true 
$farmServers
$wacFarm = $true
#endregion GLOBAL 

#region WAC CONFIG
#####################################################################
$wacHostName = "wac"
$wacCertName = "wac.fabrikam.com"                # Cert friendly name
$wacLogLocation = "c:\Logs\WAC"
$wacCacheLocation ="c:\WACcache"
$wacRenderCacheLocation = "c:\WACRenderCache"
#endRegion WAC CONFIG

#region INVOKE
$script = "createWacFarmScript.ps1"
$arguments = $server, $wacUrl, $wacUrl, $wacCertName, $wacCacheLocation, $wacLogLocation, $wacRenderCacheLocation
try {
    if ($sslWebApps) {
        $wacFarm = $false
        ForEach ($server in $farmServers.Keys) {
            $role = $farmServers.Item($server)
            if ($role -eq "Wac") {
                if (!$wacFarm) {
                    Invoke-Command -ComputerName $server -FilePath $script `
                                   -ArgumentList $Arguments `
                                   -Credential $creds.Setup -Authentication Credssp
                    $wacFarm = $true
                    Write-Output "$time : WAC Farm Created!"
                }
                else {
                    Write-Output "$time : WAC FARM JOIN NOT IMPLEMENTED!"
                    #Join Farm not implemented
                }
            }
        }

        Write-Output "$time : Connecting SharePoint to Office Web Apps..."
        New-SPWOPIBinding -ServerName $wacHostName | out-null
        Write-Output "$time : Office Web Apps Complete!"
    }
    else {
        Write-Output "$time : Office Web Apps Not Configured without SSL!"
    }
}
catch {
    Write-Host "OOOPS! We failed during calling" $script "to create WAC Farm." -ForegroundColor Red
    $_
    Pause
}
#endregion INVOKE
