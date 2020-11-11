
Get-Service | ?{$_.Name -like "winRM"} -ComputerName 

Write-Output "Server: " + ENV:ComputerName" 

