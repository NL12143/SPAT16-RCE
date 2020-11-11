
<<<<<<< HEAD:X-Remote-Server-Command.ps1
https://adamtheautomator.com/invoke-expression/

Invoke-Command -ComputerName $server -filePath
Invoke-Command -ComputerName $server -scriptBlock 

$psconfigUI = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\bin\psconfigUI.exe"
#Cannot be run remote due UI 
=======
>>>>>>> 558ecc1c96ccf58d35d16e54aeec6d3e12b749f7:X-Remote-Server-Invoke.ps1

$PSconfig = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\bin\psconfig.exe"
$PSconfigV2V = "$PSconfig -cmd upgrade -inplace v2v # After migration  
$PSconfigB2B = "$PSconfig -cmd upgrade -inplace b2b -force" # After upgrade, patch, CU   

$psconfigUI = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\bin\psconfigUI.exe"
#Cannot be run remote due UI Parameters, options  ?

$cred = Get-Credential # popup 
$creds.setup = Get-Credential # ?
$server = "P3000737"
$script = ".\Update-PSC.ps1"
$debug = $false

#Invoke-Command to server 
Invoke-Command -ComputerName $server `
  -FilePath $script `
  -ArgumentList $debug `
  -Credential $creds.setup -Authentication CredSSP

#Invoke-Command to session 
$session = New-Session -ComputerName $server -Credential $cred -Authentication CredSSP 
    Invoke-Command -Session $session -filePath $script -ArgumentList $debug `
    -Credential $creds.Setup -Authentication CredSSP
End-Session $session 

#Invoke-Command to session with PSsnapin
$session = Start-Session -ComputerName $server -Credential $cred -Authentication CredSSP 
Add-PSSnapin -Name "Microsoft.SharePoint.PowerShell" 
$upgradeScript -ArgumentList $debug `
End-Session $session 
#endregion REMOTE COMMANDS 


https://adamtheautomator.com/invoke-expression/
Invoke-Command -ComputerName $server -filePath
Invoke-Command -ComputerName $server -scriptBlock 

