
#joelblogs
retrieve password from IIS for app pool identity
Run following command in powershell
$AP = "SharePoint Central Administration v4"
& $env:windir\\system32\\inetsrv\\appcmd.exe list apppool $AP /text:ProcessModel.Password 
& $env:windir\\system32\\inetsrv\\appcmd.exe list apppool $AP /text:ProcessModel.User 
http://joelblogs.co.uk/2012/09/22/recovering-passwords-for-sharepoint-2010-farm-web-application-and-service-application-accounts/



#sharepointdiary.com
https://www.sharepointdiary.com/2012/01/how-to-retrieve-iis-application-pool-password.html#ixzz6dIjYE56H

3. Using APPCMD command line tool to get App Pool Password 
AppCmd is a command line tool for managing IIS 7 and above. 
$AP = = "SharePoint Central Administration v4" 
appcmd list apppool $AP /text:ProcessModel.Password

4. PowerShell to retrieve App Pool Passwords 
Get-WmiObject -Namespace "root\MicrosoftIISV2" -Class "IIsApplicationPoolSetting" | Select WAMUserName, WAMUserPass



