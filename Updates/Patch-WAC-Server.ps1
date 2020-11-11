
$title = "Patching Office Web Apps Farm"
$script = 

try {
    Write-Output "$(Get-Date -Format T) : $title on $server..."
    Invoke-Command -ComputerName $server -FilePath $loopbackScript `
    -Credential $creds.Setup -Authentication CredSSP

}

catch {
    Write-Host "OOOPS! We failed during " $script" "on $server." -ForegroundColor Red"
    $_
    Exit
}

Write-Output "$time : Patching complete. Run PSconfig on all servers !"     
$ver = (Invoke-WebRequest $testURL -UseBasicParsing).Headers["X-OfficeVersion"]
Write-Output "$(Get-Date -Format T) : WAC Farm Version: $ver"

