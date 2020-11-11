$launchPath = "D:\Install\Patches"
$server = "P3000017" 
$psExec = $launchPath+"\PsExec.exe"

$script = $launchPath+"\AutoSPUpdaterConfigureRemoteTarget.ps1"
Invoke-Command -ComputerName $server -filePath $script

#Results 
Invoke-Command  -ComputerName P3000017 { Get-ExecutionPolicy } | Select PScomputerName, Value
Write-Host ""
Invoke-Command  -ComputerName P3000017 { Get-WSManCredSSP }  

$script = "D:\Install\Patches\CUokt2020\Update-WAC.ps1"
Invoke-Command -ComputerName $server -filePath $
$cred = Get-Credential "dnbad\nc2643b"
Invoke-Command -ComputerName $server -filePath $script -Credential $cred -Authentication CredSSP 
$path =   "D:\Install\Patches\CUokt2020\wacserver2013-kb4484357-fullfile-x64-glb.exe"
& $path -help 
Start-Process $path 



ref 
https://github.com/NL12143/SPAT16-RCE/blob/master/X-Remote-Server-PSconfig.ps1
