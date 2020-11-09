
#Variables 
$PSScriptRoot
$ENV:USERDOMAIN

$domain = $env:USERDOMAIN    
$domainFQDN = $env:USERDNSDOMAIN
$farmAccount = "$domain\" + $accounts.Farm

#SNIPPETS 

#REMOTE COMMANDS
$creds
$creds.Setup
$farmServers
$server =  "    "
$farmServers.Item($server)  
foreach ($server in $farmServers.Keys) 
{
    $role = $farmServers.Item($server)

Invoke-Command -ComputerName $server `  # Not a SPshell with snapin 
-FilePath $sqlAliasScript ` # $sqlAliasScript = ".\New-SqlAlias.ps1"
-ArgumentList $content1AliasName, $content1ServerName, $content1InstanceName, $content1Port `
-Credential $creds.Setup -Authentication CredSSP 

ForEach ($server in $farmServers.Keys) {
    if ($farmServers.Item($server) -ne "Wac") {
        Invoke-Command -ComputerName $server -filePath $upgradeScript `
                       -ArgumentList $debug `
                       -Credential $creds.Setup -Authentication Credssp


#TABLES 

$farmServers = @{
    "fabsp01" = "DistributedCache"  # adjust for combined roles 
    "fabsp02" = "DistributedCache"
    "fabsp03" = "WebFrontEnd"
    "fabsp04" = "WebFrontEnd"
    "fabsp05" = "Application"
    "fabsp06" = "Application"
    "fabsp07" = "Search"            # Index, Query and Admin
    "fabsp08" = "Search"            # Index, Query and Admin
    "fabsp09" = "Search"            # Crawl, Content and Analytics Processing
    "fabsp10" = "Search"            # Crawl, Content and Analytics Processing
    "fabsp11" = "WAC"
    "fabsp12" = "WAC"



# TABLES 
$farmAccount = "$domain\" + $accounts.Farm


$farmServers
foreach ($server in $farmServers.Keys) {
    $role = $farmServers.Item($server)



#region Loop through input request and store in hash 
$creds
$creds.Keys
$creds.Cred
$creds = @{} #hashTable 
ForEach ($account in $accounts.Keys)
{
    $userName = "$domain\$($accounts.Item($account))"
    $cred = Get-Credential -UserName $userName `
     -Message "Please provide the credentials for the $account Account: "
    # validate the creds
    if (!(Test-Credentials $cred)) # Test against AD 
    {
        Throw "The credentials provided for the $account Account are invalid!"
    }
    else {
        $creds.Add($account, $cred)
    }
}

$userName = "$domain\$($accounts.Item($account))" 

$farmAccount = "$domain\" + $accounts.Farm

$accounts.Farm # Single entry 
$accounts.Keys # All items
$accounts = @{
    "Setup" = "SP_Setup"
    "Farm" = "SP_Farm"
    "Services" = "SPSservices"
    "Web Applications" = "SP_Content"
    "Content Access" = "SP_AontentAccess"
}
#endregion
