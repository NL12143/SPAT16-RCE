
if ( (Get-PSSnapin -Name "Microsoft.SharePoint.PowerShell" -EA 0) -eq $null) 
{ 
Add-PSSnapin -Name "Microsoft.SharePoint.PowerShell" 
}
Write-Host "Added snapin "Microsoft.SharePoint.PowerShell""
