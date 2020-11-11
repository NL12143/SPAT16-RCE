
$dst = "P3000017" 
$src = "P3000838"
$srcPath = "\\$src\D$\Install\Patches\CUokt2020\"
$dstPath = "\\$src\D$\Install\Patches\CUokt2020\"

$patchPath = "\\$src\D$\Install\Patches\CUokt2020\"
$patchPath = "D:\Install\Patches\CUokt2020\"

#SMB
$srcPath = "D:\Install\Patches\CUokt2020\*"
$dstPath = "\\$server\D$\Install\Patch\"
Get-ChildItem $dstPath 

#PS
$s = New-PSSession -ComputerName $dst 
Invoke-Command -Session $s -ScriptBlock { Test-Path -Path C:\File.txt } #true
Copy-Item -Path C:\File.txt -ToSession $session -Destination 'C:\'
Invoke-Command -Session $session -ScriptBlock { Test-Path -Path C:\File.txt } #true


Get-Command *-Item | Select Name 

https://adamtheautomator.com/copy-item-copying-files-powershell/
https://www.computerperformance.co.uk/powershell/backup-script/ 
