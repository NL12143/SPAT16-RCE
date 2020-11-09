https://gallery.technet.microsoft.com/office/Recover-SharePoint-Farm-3ddb6577
#To run this script:
#Run PowerShell as Server Administrator on a SharePoint Server
#Run the Script using .\Recover-SPManagedAccounts.ps1  (without quotes)

#------------------------------------------------------------------------------------------ 
# Name:         Recover-SPManagedAccounts 
# Description: This script will retrieve the Farm Account credentials and show the  
#              passwords for all of the SharePoint Managed Accounts 
# Usage:       Run the script on a SP Server with an account that has Local Admin Rights 
# By:          Ivan Josipovic, Softlanding.ca 
#------------------------------------------------------------------------------------------ 
 
#Checks if the Current PowerShell Session is running as the Administrator 
if(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $false){ 
    Throw "This Script must be ran as Administrator" 
} 
 
#This section retrives the Farm Account UserName/Password from the Security Token Service Application Pool 
$Farm_user = C:\Windows\System32\cmd.exe /q /c $env:windir\system32\inetsrv\appcmd.exe list apppool "SecurityTokenServiceApplicationPool" /text:ProcessModel.UserName; 
$Farm_pass = C:\Windows\System32\cmd.exe /q /c $env:windir\system32\inetsrv\appcmd.exe list apppool "SecurityTokenServiceApplicationPool" /text:ProcessModel.Password; 
$Credential = New-Object System.Management.Automation.PsCredential($Farm_user, (ConvertTo-SecureString $Farm_pass -AsPlainText -Force)); 
 
#This line contains the script which returns the account passwords, 
#script is from http://sharepointlonghorn.com/Lists/Posts/Post.aspx?ID=11 
$GetManagedAccountPasswords = " 
Add-PSSnapin Microsoft.SharePoint.PowerShell -EA 0; 

function Bindings(){ 
    return [System.Reflection.BindingFlags]::CreateInstance -bor 
    [System.Reflection.BindingFlags]::GetField -bor 
    [System.Reflection.BindingFlags]::Instance -bor 
    [System.Reflection.BindingFlags]::NonPublic; 
} 

function GetFieldValue([object]`$o, [string]`$fieldName){ 
    `$bindings = Bindings; 
    return `$o.GetType().GetField(`$fieldName, `$bindings).GetValue(`$o); 
} 

function ConvertTo-UnsecureString([System.Security.SecureString]`$string){  
    `$intptr = [System.IntPtr]::Zero; 
    `$unmanagedString = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode(`$string); 
    `$unsecureString = [System.Runtime.InteropServices.Marshal]::PtrToStringUni(`$unmanagedString); 
    [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode(`$unmanagedString); 
    return `$unsecureString; 
} 
Get-SPManagedAccount | select UserName, @{Name='Password'; Expression={ConvertTo-UnsecureString (GetFieldValue `$_ 'm_Password').SecureStringValue}}"; 
 
#Writes the Script to the Public Folder (C:\Users\Public), this is required as we cant run the script inline as its too long. 
Set-Content -Path "$($env:public.TrimEnd("\"))\GetManagedAccountPasswords" -Value $GetManagedAccountPasswords; 
 
#The Script which will be ran in the new PowerShell Window running as the Farm Account, 
#it also removes the script above which we wrote to the file system 
$Script = " 
`$Script = Get-Content `"$($env:public.TrimEnd("\"))\GetManagedAccountPasswords`"; 
PowerShell.exe -Command `$Script; 
Remove-Item `"$($env:public.TrimEnd("\"))\GetManagedAccountPasswords`"; 
Add-PSSnapin Microsoft.SharePoint.PowerShell -EA 0;" 
 
#Runs PowerShell as the Farm Account and loads the Script above 
Start-Process -FilePath powershell.exe -Credential $Credential -ArgumentList "-noexit -command $Script" -WorkingDirectory C:\



<#
This script will Display the SharePoint Farm Managed Accounts password including the Farm Account, 
without requiring the current user to be a part of the SharePoint Farm Admin Group. 

The script works by retrieving the Farm Account credentials from the Secure Token Service Application Pool. 
Then it runs PowerShell using the Farm Account credentials to retrieve the Passwords 
of all of the SharePoint Managed Accounts.

To run this script:
Run PowerShell as Administrator on a SharePoint Server
Run the Script using “.\Recover-SPManagedAccounts.ps1” (without quotes)

Disclaimer
The sample scripts are not supported under any Microsoft standard support program or service. 
The sample scripts are provided AS IS without warranty of any kind. 
Microsoft further disclaims all implied warranties including, 
without limitation, any implied warranties of merchantability or 
of fitness for a particular purpose. 
The entire risk arising out of the use or performance of 
the sample scripts and documentation remains with you. 
In no event shall Microsoft, its authors, or anyone else involved in 
the creation, production, or delivery of the scripts be liable for any damages whatsoever 
(including, without limitation, damages for loss of business profits, business interruption, 
loss of business information, or other pecuniary loss) 
arising out of the use of or inability to use the sample scripts or documentation, 
even if Microsoft has been advised of the possibility of such damages.
#> 
