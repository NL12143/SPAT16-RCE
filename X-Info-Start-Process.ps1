
Start-Process iexplorer .....

You need to invoke the script through powershell.exe:
Start-Process powershell -ArgumentList "-File .\test.ps1 arg1 arg2 argX"
You can specify the argument list either as a string or an array of strings. 
See example 7 here for more information.
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/start-process?view=powershell-5.1#examples

Start-Process powershell.exe -ArgumentList '-NoExit -File .\myscript.s1'

Start-Process and Invoke-Expression cmdlets, 
we can call the executable directly or 
use the ampersand (&) to invoke expressions. 
Install-Script 'Invoke-Process'
PS> . Invoke-Process.ps1

$PS = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
 Start-Process -FilePath $PS -ArgumentList "-NoExit","-command `"& { get-date } " 
 
 I can handle variables also, Start-Process -FilePath


 Invoke-Command -ComputerName $server -FilePath $loopbackScript `
 Invoke-Command -ComputerName $server -ScriptBlock $ScriptBlock 

 foreach ($server in $farmServers.Keys) 
 {
    $role = $farmServers.Item($server)
    # Disable Loopback Check on all servers
    Invoke-Command -ComputerName $server -FilePath $loopbackScript `
                   -Credential $creds.Setup -Authentication Credssp
 }


