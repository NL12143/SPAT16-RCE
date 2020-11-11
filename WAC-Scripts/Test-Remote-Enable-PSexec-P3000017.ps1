$psExec = $env:dp0+"\PsExec.exe"
$env:dp0 # Working Directory 

#Run script remote 
$launchPath = "D:\Install\Patches"
$server = "P3000017" 
$psExec = $launchPath+"\PsExec.exe"
$script = $launchPath+"\AutoSPUpdaterConfigureRemoteTarget.ps1"
$credential = Get-Credential 
$username = $credential.Username
$password = ConvertTo-PlainText $credential.Password
Set-Location "D:\Install\Patches"
Start-Process -FilePath "$psExec" `
-ArgumentList "/acceptEula \\$server -h powershell.exe -Command `"try {Set-ExecutionPolicy Bypass -Force} catch {}; Stop-Process -Id `$PID`"" `
-Wait # -NoNewWindow

Write-Host "Use PSexec to Set ExecutionPolicy "
Start-Process -FilePath "$psExec" `
  -ArgumentList "/acceptEula \\$server -h powershell.exe `
  -Command `"Set-ExecutionPolicy Bypass -Force ; Stop-Process -Id `$PID`"" `
  -Wait # -NoNewWindow

Write-Host "Use PSexec to run script $script "
Start-Process -FilePath "$psExec" `
  -ArgumentList "/acceptEula \\$server -u $username -p $password -h powershell.exe `  -Command `"$script`"" -Wait #-NoNewWindow

Start-Process -FilePath "$psExec" `
-ArgumentList "\\$server cmd /c echo. ^| PowerShell dir ‘c:\program files’"

#Results 
Invoke-Command  -ComputerName P3000017 { Get-ExecutionPolicy } | Select PScomputerName, Value
Write-Host ""
Invoke-Command  -ComputerName P3000017 { Get-WSManCredSSP }  

<#
-u $username -p $password -h
Start-Process -FilePath "$psExec" -ArgumentList 
#>
