$usercred=Get-Credential -Message "Enter user credentials" -UserName alex
Connect-CIServer -Server incloud.vodafone.ua -Org neworg -Port 9443 -Credential $usercred -SaveCredentials
get-org
Get-PIVApp
Get-PIVM
Get-EdgeGateway
Get-OrgVdcNetwork
Get-OrgVdc


