winRM QuickConfig # Set WinRM , Firewall  
Enable-PSremoting # Idem 

Get-Service -ComputerName P3000017 | ?{$_.Name -eq "WinRM"} | Select DisplayName, Name, Status

Get-Service -ComputerName P3000017 | Select DisplayName, Name, Status | Sort Name
Get-Service -ComputerName P3000017 | ?{$_.Name -eq "WACSM"} | Select DisplayName, Name, Status
Get-Service -ComputerName P3000017 | ?{$_.DisplayName -like "Office Web App"} 

Invoke-Command  -ComputerName P3000017 { Get-ExecutionPolicy } | Select PScomputerName, Value
Invoke-Command  -ComputerName P3000017 { Get-WSManCredSSP }  

Enter-PSsession -ComputerName P3000017
Exit-PSsession 

$launchPath = "D:\Install\Patches"
$psExec = $launchPath+"\PsExec64.exe"
$server = "P3000017" 
Start-Process -FilePath "$psExec" `
-ArgumentList "/acceptEula \\$server -h powershell.exe -Command `"try {Set-ExecutionPolicy Signed   -Force} catch {}; Stop-Process -Id `$PID`"" -Wait -NoNewWindow

$cmd = "try {Set-ExecutionPolicy Unsigned -Force} catch {}; Stop-Process -Id `$PID`"
Start-Process -FilePath "$psExec" `
-ArgumentList "/acceptEula \\$server -h powershell.exe -Command `$($cmd)  -Wait -NoNewWindow

$script = "$launchPath\AutoSPUpdaterConfigureRemoteTarget.ps1"
Start-Process -FilePath "$psExec" `
 -ArgumentList "/acceptEula \\$server -u $username -p $password -h powershell.exe -Command `"$script`"" `
 -Wait -NoNewWindow

$patch = $launchPath+"\CUokt2020\wacserver2013-kb4484357-fullfile-x64-glb.exe"
Start-Process -FilePath "$patch" `
    -ArgumentList "/help \\$server -h powershell.exe -Command `{Get-Process}` -Wait -NoNewWindow

$configureTargetScript = "$launchPath\AutoSPUpdaterConfigureRemoteTarget.ps1"
Start-Process -FilePath "$psExec" `
-ArgumentList "/acceptEula \\$server -u $username -p $password -h powershell.exe `-Command `"$configureTargetScript`"" `
-Wait -NoNewWindow

$psexec 
$launchPath = "D:\Install\Patches"
$configureTargetScript = "$launchPath\AutoSPUpdaterConfigureRemoteTarget.ps1"
$configureTargetScript




# from http://www.leeholmes.com/blog/2007/10/02/using-powershell-and-PsExec-to-invoke-expressions-on-remote-computers/
# PsExec64 \\P3000017 cmd /c "echo . | powershell {command}"



