
$AP = "SharePoint Central Administration v4"
& $env:windir\\system32\\inetsrv\\appcmd.exe list apppool $AP /text:ProcessModel.Password 
& $env:windir\\system32\\inetsrv\\appcmd.exe list apppool $AP /text:ProcessModel.User 


https://www.sharepointdiary.com/2014/01/get-managed-account-password-in-sharepoint.html

#region Get-ChildItem -Path IIS:\AppPools\
https://www.sharepointdiary.com/2017/08/get-sharepoint-farm-account-user-name-password.html
#Get SharePoint Farm Account Password:
Import-Module WebAdministration
#Get Central Admin App Pool - which Runs on FARM account
$CAPool = Get-ChildItem -Path IIS:\AppPools\ | 
    Where-Object { $_.Name -eq "SharePoint Central Administration v4" }
#Get User Name and Password for Farm Account
$CAPool.ProcessModel.UserName
$CAPool.ProcessModel.Password
#endregion 

#region appcmd list apppool
https://www.sharepointdiary.com/2012/01/how-to-retrieve-iis-application-pool-password.html

1. IIS Metabase Explorer (for IIS 6) - Part of IIS Resource kit - Make sure "Secure Data" is checked
get app pool password. 
Get it from here. http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=17275

2. SharePoint Manager - Excellent tool for exploring the server objects. 
Just navigate to the target application pool, get the password from properties pane.

3. appcmd list apppool "<Your Application Pool Name>" /text:ProcessModel.Password
& $env:windir\\system32\\inetsrv\\appcmd.exe list apppool $AP /text:ProcessModel.Password 
& $env:windir\\system32\\inetsrv\\appcmd.exe list apppool $AP /text:ProcessModel.User 

4. PowerShell to retrieve App Pool Passwords 
Get-WmiObject -Namespace "root\MicrosoftIISV2" -Class "IIsApplicationPoolSetting" | Select WAMUserName, WAMUserPass
#endregion 

#region get-managed-account-password
https://www.sharepointdiary.com/2014/01/get-managed-account-password-in-sharepoint.html
SharePoint Managed accounts feature was introduced in its 2010 version, 
and of course its a wonderful feature to manage service accounts 
(I remember those old days.. We used to create a batch file to update password for each and everything in SharePoint 2007!).
So, We utilized managed accounts in SharePoint 2013, enabled automatic password change. 
All went well until we needed the password for a particular managed account 
to install a third-party add-on! Luckily found this script 
to get managed account passwords in SharePoint.

Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue
function Bindings()
{
 return [System.Reflection.BindingFlags]::CreateInstance -bor
 [System.Reflection.BindingFlags]::GetField -bor
 [System.Reflection.BindingFlags]::Instance -bor
 [System.Reflection.BindingFlags]::NonPublic
}
function GetFieldValue([object]$o, [string]$fieldName)
{
 $bindings = Bindings
 return $o.GetType().GetField($fieldName, $bindings).GetValue($o);
}
function ConvertTo-UnsecureString([System.Security.SecureString]$string)
{
 $intptr = [System.IntPtr]::Zero
 $unmanagedString = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($string)
 $unsecureString = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($unmanagedString)
 [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($unmanagedString)
 return $unsecureString
}
Get-SPManagedAccount | 
    select UserName, @{Name="Password"; Expression={ConvertTo-UnsecureString (GetFieldValue $_ "m_Password").SecureStringValue}}

#endregion get-managed-account-password



