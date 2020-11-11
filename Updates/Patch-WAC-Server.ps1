

$title = "Patching Office Web Apps Farm"
$patch = "Patch-WAC-Server.ps1"

try {
    Write-Output "$(Get-Date -Format T) : $title on $server..."
    Invoke-Command -ComputerName $server -FilePath $loopbackScript `
    -Credential $creds.Setup -Authentication CredSSP

}

catch {
    Write-Host "OOOPS! We failed during " $patch" "on $server." -ForegroundColor Red"
    $_
    Exit
}

Write-Output "$time : Patching complete. Run PSconfig on all servers !"     
$ver = (Invoke-WebRequest $testURL -UseBasicParsing).Headers["X-OfficeVersion"]
Write-Output "$(Get-Date -Format T) : WAC Farm Version: $ver"

