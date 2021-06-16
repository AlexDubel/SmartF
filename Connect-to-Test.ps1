$webclient=New-Object System.Net.WebClient
$webclient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
[Net.ServicePointManager]::SecurityProtocol = "tls12"
Function prompt {Write-Host -ForegroundColor Yellow “IncloudTest “ -NoNewline}
$error.clear()
function Connect-VC-Server () {
$cred=(Get-Credential -Message "Please enter password to connect to Test Cloud Director" -UserName sasha@kvcloud.local)
    try    { Connect-CIServer -Server incloud.vodafone.ua -Port 9443 -User $cred.UserName -Password $cred.Password -ErrorAction Stop }
    catch [system.exception] {#"caught a system exception!";
    if ($Error -like "No Cloud server was found*") {Write-Host -foreground Cyan "Check your Internet connection. Maybe it is blocked by your proxy."}
    Write-Host $Error
    Write-Host -foreground Cyan "Check your Internet connection. Maybe it is blocked by your proxy."
    Write-Host "Exiting..."
    #Write-Host "errorCount="$($Error.Count)
     exit 100;}
    catch  { 
    
  
    Write-Host -ForegroundColor Cyan "Connection to server was unsuccessful. Please try again" 
             Connect-VC-Server}
    
}
Connect-VC-Server
#Connect-CIServer -Server incloud.vodafone.ua -Port 9443 -User $cred.UserName -Password $cred.Password08 