#Get hardware information from Management vCenter
#Connect-VIServer -Server vcm01.kvcloud.local `
# -Credential (Get-Credential -Message "Put your credentials to connect to management vCenter" -UserName sasha@kvcloud.local) -SaveCredentials
#Get-VMHost | Format-Table -AutoSize
if(!$global:DefaultCIServers.IsConnected){}
$global:DefaultCIServers.Version

#Get-Datacenter
Get-Datastore | Select-Object name, id, type, FileSystemVersion, CapacityGB, FreeSpaceGB, Datacenter | Format-Table -AutoSize
#Get-Datastore | Format-Table -AutoSize
Get-VMHost | Select-Object name, state, ConnectionState, Manufacturer, Model, NumCpu, ProcessorType, StorageInfo, Version, Build, TimeZone
#Example
get-vm zabbix01 | Select-Object *
Get-VDSwitch | Select-Object *

$serverlist=Get-Content C:\Users\oldubel\Documents\PowerShell\vCloud\TestScripts\get-servinfo.txt
$ss=New-PSSession -Credential (Get-Credential -Message ggg -UserName oldubel@kvcloud.local) -ComputerName $serverlist
#https://business.vodafone.ua/produkty/infrastructure-as-a-service

#NSX Module installation
Find-Module PowerNSX | Install-Module
#info about NAT rules on NSX Edges
$vcmcred=Get-Credential -Message "Please specify credentials to connect to VC[m,p,t] server" -UserName sasha@kvcloud.local
#Connecting to NSX server on vcm01 vCenterServer
Connect-NsxServer -vCenterServer vcm01.kvcloud.local -Credential $vcmcred
$alledges = Get-NsxEdge
$alledges | ForEach-Object { Get-NsxEdgeNat -Edge $PSItem  | Get-NsxEdgeNatRule | Where-Object { $PSItem.originalAddress -like "77.52.184.182" } |`
    Select-Object originalAddress, originalPort, translatedAddress, translatedPort, action, enabled, edgeid | Format-Table -AutoSize }
 #Or without ip filtering
 $alledges | ForEach-Object { Get-NsxEdgeNat -Edge $PSItem  | Get-NsxEdgeNatRule |`
    Select-Object originalAddress, originalPort, translatedAddress, translatedPort, action, enabled, edgeid | Format-Table -AutoSize }
    