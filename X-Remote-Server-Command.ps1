

https://adamtheautomator.com/invoke-expression/




Invoke-Command -ComputerName $server -filePath
Invoke-Command -ComputerName $server -scriptBlock 

$psconfigUI = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\bin\psconfigUI.exe"
#Cannot be run remote due UI 

$PSconfig = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\bin\psconfig.exe"

$PSconfigV2V = "$PSconfig -cmd upgrade -inplace v2v # After migration  
$PSconfigB2B = "$PSconfig -cmd upgrade -inplace b2b -force" # After upgrade, patch, CU   

#region REMOTE COMMANDS 
$server = "P3000737"
Invoke-Command -ComputerName $server -filePath $upgradeScript `
  -ArgumentList $debug `
  -Credential $creds.Setup -Authentication CredSSP


$session = New-Session -ComputerName $server -Credential $creds.Setup -Authentication CredSSP 
    Invoke-Command -Session $session -filePath $upgradeScript -ArgumentList $debug `
End-Session $session 

$session = Start-Session -ComputerName $server -Credential $creds.Setup -Authentication CredSSP 
Add-PSsnapin 
$upgradeScript -ArgumentList $debug `
End-Session $session 
#endregion REMOTE COMMANDS 
