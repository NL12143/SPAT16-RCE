Set-Location D:\Install\Patches\CUokt2020\
$patchPath = "D:\Install\Patches\CUokt2020\"
$patchPath = "\\P3000838\D$\Install\Patches\CUokt2020\"

$patchFiles = Get-ChildItem -LiteralPath $patchPath -Filter *.exe | ? { $_.Name -match '([A-Za-z0-9\-]+)2013-kb([A-Za-z0-9\-]+)glb.exe' }
$patchFile = "wacserver2013-kb4484518-fullfile-x64-glb.exe"
$patchL = $patchPath+$patchFile 
Unblock-File -Path $patchL -Verbose

LOCAL 
$process = Start-Process $patchL -ArgumentList '/passive /quiet' -PassThru -Wait # Remote # 17025
$process = Start-Process $patchL -ArgumentList '/norestart' -PassThru -Wait #Local 
$process.ExitCode

REMOTE
$patchL
Invoke-Command Unblock-File -Path $patch   

Enter-PSsession -ComputerName P3000017 
$patchPath = "\\P3000838\D$\Install\Patches\CUokt2020\"
$patchPath = "D:\Install\Patches\CUokt2020\"
$patchFile = "wacserver2013-kb4484518-fullfile-x64-glb.exe"
$patch = $patchPath+$patchFile 
$patch
$process = Start-Process $patch -ArgumentList '/passive /quiet' -PassThru -Wait # Remote # 17025
$process = Start-Process $patch -ArgumentList "/passive /quiet" -PassThru -Wait # Remote # 17025
$process = Start-Process $patch -ArgumentList '/norestart' -PassThru -Wait #Local # EULA 
$process.ExitCode # 0 is OK
Exit-PSsession 

$s = New-PSsession -ComputerName P3000017 


Ref 

https://github.com/Nauplius/SharePoint-Patch-Script/blob/master/SharePointPatchScript.psm1
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/unblock-file?view=powershell-7
https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-unblock-files-in-folder/
https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.process.exitcode?view=netcore-3.1


$process.ExitCode 17025
