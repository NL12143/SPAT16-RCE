
Run script remote 

<#
.SYNOPSIS
    Patches Web Apps (WAC) Farm
.DESCRIPTION
.NOTES
	File Name  : Patch-WacFarm.ps1
	Author     : Spencer Harbar (spence@harbar.net)
	Requires   : PowerShell Version 2.0  
.LINK
.PARAMETER File  
	The configuration file
#>

#region PARAMS
param (  
    [String]$server,
    [String]$patch = "D:\Temp\wac-----gbs.exe"
) 
#endregion PARAMS

#INPUT 
$servers = "P3000738", "P3000739"
$script   = ".\Patch-WAC-server.ps1"

#INVOKE 
$creds = Get-Credential "dnbAD\NC2643B" 

foreach ($server in $servers) {
    Write-Output "Invoke command " $script "to "$server   
    Invoke-Command -ComputerName $server -FilePath $script `
    # -Credential $creds.Setup -Authentication CredSSP # For Windows no need credSSP 
    # ?How to check for credSSP > Enable-WinRM 
    }


Write-Output "$time : Patching complete. Run PSconfig on all servers !"     
$ver = (Invoke-WebRequest $testURL -UseBasicParsing).Headers["X-OfficeVersion"]
Write-Output "$(Get-Date -Format T) : WAC Farm Version: $ver"
