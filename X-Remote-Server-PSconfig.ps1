
After migrate ContentDB via attach  

$script = ".\Update-PSC.ps1"
& $path -cmd upgrade -inplace b2b -force | Out-Null     # Silent
& $path -cmd upgrade -inplace b2b -force -verbose       # Debug

$path = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\bin\psconfig.exe"
$path15 = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\bin\psconfig.exe"
$path16 = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\bin\psconfig.exe"

$psconfig.exe -cmd upgrade -inplace b2b -wait -verbose # After patch 
$psconfig.exe -cmd upgrade -inplace v2v -wait # After version upgrade

Invoke-Command -ComputerName $server -filePath $upgradeScript `
-ArgumentList $debug `
-Credential $creds.Setup -Authentication Credssp

# B2B_UPGRADE
#region B2B_UPGRADE # note: finally resolved in recent 2016 PU!!!!
    Write-Output "$time : Upgrading (B2B) servers in the farm..."
    ForEach ($server in $farmServers.Keys) {
        if ($farmServers.Item($server) -ne "Wac") {
            Invoke-Command -ComputerName $server -filePath $upgradeScript `
                           -ArgumentList $debug `
                           -Credential $creds.Setup -Authentication Credssp
        }
    }
    Write-Output "$time : All servers upgraded!"
#endregion B2B_UPGRADE


$creds.Setup = @{
    "setup" = 
}


$farmServers
$farmServers = @{
    "P3000738" = "DEV-AutoSP"  
    "P3000738" = "DEV-Roeland"  
    "P3000739" = "DEV-Jean"  
    "P3000740" = "DEV-Jan"  
    }

<#
http://technet.microsoft.com/en-us/library/cc263093.aspx 

[-inplace <v2v|b2b>]
If specified, the SharePoint Products Configuration Wizard will perform an in-place upgrade. 
If v2v is specified, an in-place version to version upgrade is performed. #FarmPhrase 
If b2b is specified, an in-place build to build upgrade is performed. # 

The Psconfig commands must be performed in the following order:
configdb
helpcollections
secureresources
services
installfeatures
adminvs
evalprovision (only for stand-alone installations)
applicationcontent
upgrade

Important
If Psconfig detects that the server farm has to be upgraded, 
it will automatically start an upgrade when you run it 
(even if you did not select the upgrade command).

You can specify all the commands to run in a single command-line string. 
If you do this, Psconfig runs all the commands in the correct order. 
For example, at the command prompt, you can run a command similar to the following:

$PSconfig -cmd upgrade -inplace b2b -force # Needs SPshell ? 

PSconfig.exe -cmd configdb <parameters>
-cmd helpcollections <parameters>
-cmd secureresources <parameters>
-cmd services <parameters>
-cmd installfeatures <parameters>
-cmd adminvs <parameters>
-cmd evalprovision <parameters>
-cmd applicationcontent <parameters>

A v2v upgrade is used for upgrading from one product version to another 
(e.g. MOSS 2007 to SharePoint Server 2010).

A b2b upgrade is used for upgrading from one build to another 
within the same product version (e.g. SP2010 RTM to SP2010 SP1). ? After a CU ? 

Examples 
psconfig.exe -cmd secureresources
psconfig.exe -cmd adminvs -provision -port 8080 
psconfig.exe -cmd quiet 
psconfig.exe -cmd upgrade -inplace v2v -wait -force 
psconfig.exe -cmd quiet -cmd upgrade -inplace b2b -wait  

psconfig.exe -cmd setup/repair 

#>
