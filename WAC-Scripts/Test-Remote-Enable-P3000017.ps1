﻿$psExec = $env:dp0+"\PsExec.exe"
$env:dp0 # Working Directory 

#Run script remote 
$launchPath = "D:\Install\Patches"
$server = "P3000017" 
$psExec = $launchPath+"\PsExec.exe"
$script = $launchPath+"\AutoSPUpdaterConfigureRemoteTarget.ps1"
$credential = Get-Credential 
$username = $credential.Username
$password = ConvertTo-PlainText $credential.Password

Start-Process -FilePath "$psExec" `
  -ArgumentList "/acceptEula \\$server -h powershell.exe `
  -Command `"Set-ExecutionPolicy Bypass -Force ; Stop-Process -Id `$PID`"" `
  -Wait # -NoNewWindow

Write-Host "Use PSexec to run script $script "
Start-Process -FilePath "$psExec" `
  -ArgumentList "/acceptEula \\$server -u $username -p $password -h powershell.exe `

#Results 
Invoke-Command  -ComputerName P3000017 { Get-ExecutionPolicy } | Select PScomputerName, Value
Write-Host ""
Invoke-Command  -ComputerName P3000017 { Get-WSManCredSSP }  

<#
-u $username -p $password -h
Start-Process -FilePath "$psExec" -ArgumentList 
#>