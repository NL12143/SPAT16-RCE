
$key = "HKLM:\System\CurrentControlSet\Control\Lsa"
$keyName = "DisableLoopbackCheck"

$keyValue = Get-ItemProperty -path $key


# Set a (new ?) value 
HKLM:\System\CurrentControlSet\Control\Lsa
New-ItemProperty $key -Name $keyName -value "1" -PropertyType Dword -Force | Out-Null



$lsaKey = "HKLM:\System\CurrentControlSet\Control\Lsa"
$lsaKeyValue = Get-ItemProperty -path $lsaPath

If (-not ($lsaKeyValue.DisableLoopbackCheck -eq "1")) # KeyValue is not 1, default = is 0
{
    New-ItemProperty HKLM:\System\CurrentControlSet\Control\Lsa -Name "DisableLoopbackCheck" -value "1" -PropertyType dword -Force | Out-Null
    Write-Warning "A server restart on ($env:ComputerName) is needed for the loopback setting to take effect." 
}
Write-Output "$(Get-Date -Format T) : Loopback Check Disabled on $env:ComputerName"
