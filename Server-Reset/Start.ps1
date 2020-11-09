param (
    [string]$Parameters, 
    $beheerSrv,
    [string[]]$serverFunctions=@()
)

Write-verbose -Message "DNB Installation & update script" -Verbose

function Get-ScriptDirectory {
	$Invocation = (Get-Variable MyInvocation -Scope 1).Value
	return Split-Path $Invocation.MyCommand.Path
}

$ErrorActionPreference = "Stop"
$executePath = (Get-ScriptDirectory)
if (Test-Path $executePath\reboot.ps1) 
{
	Import-Module $executePath\reboot.ps1 -Force
}

# -----------------------------------------------------------------------------------------------
# Variables default
# -----------------------------------------------------------------------------------------------
$Domain = $env:USERDOMAIN.ToLower()
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ScriptDir = "D:\scripts"
$Scriptname = ($MyInvocation.MyCommand.Name).TrimEnd(".ps1")
$inputFile = $scriptPath + "\config.xml"

# -----------------------------------------------------------------------------------------------
# Variables custom
# -----------------------------------------------------------------------------------------------
$global:beheerServer = $beheerSrv
# -----------------------------------------------------------------------------------------------
# Import modules
# -----------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------
# Main script
# -----------------------------------------------------------------------------------------------
Function Execute() {
        $ErrorActionPreference = "Stop"
# -----------------------------------------------------------------------------------------------
# Get XML from config.xml
# -----------------------------------------------------------------------------------------------
Write-Output "Start get Inputfile $inputFile"
$config = New-Object xml
$config.Load($inputFile)
Write-Output "Finished loading XML"
# -----------------------------------------------------------------------------------------------
# Loop through all the XML of the Domain we are in
# -----------------------------------------------------------------------------------------------
Foreach ($serverFunction in $serverFunctions) {
    $xmlServerNames = $config.Main.$Domain.Servers.Server | Where-Object {$_.function -match $serverFunction}
    $serverNames = $xmlServerNames.name
      Foreach($computerName in $serverNames) {
         $session = New-PSSession -name PS01 -ComputerName $computerName -Port 5985
            Try {
                    Write-Output "----Start rebooting $computerName ----"
                    reboot-Server   $computerName
                    Write-Output "----Finished rebooting $computerName ----"
            }
            Catch {
                    Write-Output "Kan server $computerName niet rebooten..."
                    Write-Output $Error
            }
        }
    Remove-PSSession -Session $session -ErrorAction Ignore
 } 
# -----------------------------------------------------------------------------------------------
# Close log footer  
# -----------------------------------------------------------------------------------------------

Set-Location $executePath
}

Execute | Out-String | Write-Verbose -Verbose