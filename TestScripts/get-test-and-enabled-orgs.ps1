#Path to output file
$myoutfile = "C:\Users\oldubel\Documents\PowerShell\vCloud\TestScripts\Outputs\test-and-disabled-orgs.csv"
#Connect to the Cloud Director

if(!$global:DefaultCIServers.IsConnected){
$vcmcred=Get-Credential -Message "Please specify credentials to connect to incloud.vodafone.ua" -UserName sasha@kvcloud.local
Connect-CIServer incloud.vodafone.ua -Credential $vcmcred
$orginfo = Get-org 
}

#exit
#$orginfo | Where-Object {$PSItem.Description -like "*TEST*" -and $PSItem.enabled -eq $true} |`
# Select-Object name, description | Export-Csv -Path $myoutfile -Delimiter ";" -Encoding utf8BOM

#{$_-replace "t`r`n", "ting`r`na "} 
$orginfo | Where-Object {$PSItem.Description -like "*TEST*" -and $PSItem.enabled -eq $false} |`
 Select-Object name, enabled, @{label ="Description"; expression = {$PSItem.description -replace "`r", " "}} |`
  Export-Csv -Path $myoutfile -Delimiter ";" -Encoding utf8BOM

 #$orginfo | Where-Object {$PSItem.Description -like "*TEST*" -and $PSItem.enabled -eq $true} |`
 #Select-Object name, enabled, @{label ="Description"; expression = {$PSItem.description}}  | Out-GridView


 #@{label ="Description"; expression = {$PSItem.description}

 #Внутренние адреса машин, которые находятся в Cloud Director
Get-CINetworkAdapter -VM VM1
Get-CIVM | ForEach-Object {Get-CINetworkAdapter -vm $PSItem}
#
#Получить перечень используемых внешних ip адресов можно командой (нужна предварительная авторизация)
Get-NsxEdge | ForEach-Object {Get-NsxEdgeNat -Edge $PSItem} |`
 ForEach-Object {(Get-NsxEdgeNatRule -EdgeNat $PSItem).originalAddress} | select-string "77.52." | Sort-Object -Unique
