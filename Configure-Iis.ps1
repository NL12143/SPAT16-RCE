<#
.REMARKS
Use Kernel Mode Authentication, kerberos, SPN, ...
Set AppPools not pause and/or recycle (CRM best practice) 
.SYNOPSIS
    Remove IIS default App Pools and Web Sites.
    Configures the default Log file location for future Web Sites.
    Configures additional log fields.   
.DESCRIPTION
    Remove IIS default App Pools and Web Sites.
    Configures the default Log file location for future Web Sites.
    Configures additional log fields.
    Intended to ensure a clean configuration prior to creating or joining machines to a SharePoint Farm.
    Assumes the SharePoint Pre-requisites installer has been used, or eviqualent pre reqs installed.
    
    spence@harbar.net
    25/06/2015
.NOTES
	File Name  : Configure-Iis.ps1
	Author     : Spencer Harbar (spence@harbar.net)
	Requires   : PowerShell Version 2.0  
.LINK
.PARAMETER File  
.EXAMPLE 
.HELP     
#>

#region PARAMS
param (  
    [String]$IISlogsLocation,
    [String]$WebSite = "Default Web Site",
    [String[]]$AppPools = (".NET v2.0", ".NET v2.0 Classic", ".NET v4.5", ".NET v4.5 Classic", "Classic .NET AppPool", "DefaultAppPool"),
    [String]$IisLogFields = "Date,Time,ClientIP,UserName,ServerIP,Method,UriStem,UriQuery,HttpStatus,Win32Status,BytesSent,BytesRecv,TimeTaken,ServerPort,UserAgent,Host,HttpSubStatus"
) 
#endregion PARAMS

#region MODULES
Import-Module WebAdministration
#endregion MODULES

# Remove existing web sites 
# $WebSite = "Default Web Site"
if (Get-Website -Name $WebSite) { Remove-WebSite -Name $WebSite }

# Remove application pools
foreach ($AppPool in $AppPools) {
    if (Test-Path IIS:\AppPools\$AppPool) {
        Remove-WebAppPool -name $AppPool
    }
}

# Set default log location
if ($IisLogsLocation -ne $null) {
    Set-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -name logfile.directory -value $IisLogsLocation
}

# Set fields to log
Set-WebConfigurationProperty -Filter System.Applicationhost/Sites/SiteDefaults/logfile -Name LogExtFileFlags -Value $IisLogFields
Write-Output "$(Get-Date -Format T) : IIS Configuration Updated on $env:ComputerName"

#EOF