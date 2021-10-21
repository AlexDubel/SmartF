Команда Get-NsxEdge выдает переречень всех EDGEs и их параметры, но на вход не хочет принимать ничего. 
Т.е. все варианты Accept pipeline input = false
Пример вывода команды:
id                : edge-1
version           : 36
description       : Provider Edge
status            : deployed
datacenterMoid    : datacenter-2
datacenterName    : KV-ORS-DC1-PLD
tenant            : default
name              : pesg01
fqdn              : pesg01.kvcloud.local
enableAesni       : true
enableFips        : false
vseLogLevel       : info
vnics             : vnics
appliances        : appliances
cliSettings       : cliSettings
features          : features
autoConfiguration : autoConfiguration
type              : gatewayServices
isUniversal       : false
hypervisorAssist  : false
tunnels           :
edgeSummary       : edgeSummary

id                : edge-4
version           : 159
description       :
status            : deployed
datacenterMoid    : datacenter-2
datacenterName    : KV-ORS-DC1-PLD
tenant            : b97f6246-84b2-40dc-b3ef-af3ed06ce71c
name              : vse-FoEdge (0af580b6-05bb-44a5-92ad-cb7843afef55)
fqdn              : vse-6cf202c7-b13f-4283-84d8-e12f7eaaba65
enableAesni       : true
enableFips        : false
vseLogLevel       : info
vnics             : vnics
appliances        : appliances
cliSettings       : cliSettings
features          : features
autoConfiguration : autoConfiguration
type              : gatewayServices
isUniversal       : false
hypervisorAssist  : false
tunnels           :
edgeSummary       : edgeSummary

При этом если сделать вывод команды (get-org).id
То получим примерно такой список:
urn:vcloud:org:ff26a6d2-6c09-4865-93f0-daba7acc3120
urn:vcloud:org:b3da94bd-e9ac-4e88-91a9-3f276becb3ca
urn:vcloud:org:f118f059-5012-476d-b3fc-acb00dda6c4b
urn:vcloud:org:441423ac-8101-406d-b618-b7ef0801a530
urn:vcloud:org:1c6d209d-eab4-47c4-9fc6-5440377a5d5a
urn:vcloud:org:b97f6246-84b2-40dc-b3ef-af3ed06ce71c
...
где, например у edge-4 tenant это b97f6246-84b2-40dc-b3ef-af3ed06ce71c, что совпадает с (get-org).id после urn:vcloud:org:
 
Get-NsxEdge | ForEach-Object {Get-NsxSslVpn -Edge $PSItem}
Данная команда выдает перечень NSXSSL VPN'ов. при этом в выводе указывается edge id (например edge-4)
кусок вывода из многих эджей (только для 4-ого эджа):
...
version                     : 28
enabled                     : false
logging                     : logging
advancedConfig              : advancedConfig
clientConfiguration         : clientConfiguration
layoutConfiguration         : layoutConfiguration
authenticationConfiguration : authenticationConfiguration
edgeId                      : edge-4
...

$alledges | ForEach-Object {(Get-NsxSslVpn -Edge $PSItem)| Select-Object edgeID, enabled, version}

edgeId   enabled version
------   ------- -------
edge-1   false   2
edge-4   false   28
edge-9   false   5
edge-15  false   2
edge-16  false   8
edge-20  true    27
edge-26  false   2
edge-30  false   6
edge-46  false   4
edge-64  false   2
edge-71  false   2
edge-93  true    16
edge-113 false   1
edge-128 false   32
edge-132 false   1
edge-133 false   1
edge-136 false   2
edge-137 false   1

Работающая команда выдает необходимую информацию по адресам
$alledges | ForEach-Object {Write-Host $PSItem.name -ForegroundColor Yellow; Get-NsxEdgeInterface -Edge $PSItem |`
 ForEach-Object { (Get-NsxEdgeInterfaceAddress -Interface $PSItem)}}
 
esxcli software vib list | grep esx
dvSwitchCompute
esxcli network vswitch dvs vmware list

Add or remove network cards (known as vmnics) to or from a vNetwork Distributed Switch (vDS) using these commands:

esxcfg-vswitch -Q vmnic -V dvPort_ID_of_vmnic dvSwitch # unlink/remove a vDS uplink
esxcfg-vswitch -P vmnic -V unused_dvPort_ID dvSwitch # add a vDS uplink

#
esxcfg-vswitch -Q vmnic1 -V 352 dvSwitchCompute

chsh -s /bin/bash root
chsh -s /bin/appliancesh root

Must provide VDS uplink or VDS lag in VdsUplink for nsx uplink(s) 
50 3e de 56 bd 0d 05 39-7e 5e e4 fe f5 70 fe ad 
for HostSwitch 9526 of type VDS. (Error code: 9526)

Must provide VDS uplink or VDS lag in VdsUplink for nsx uplink(s) 50 3e de 56 bd 0d 05 39-7e 5e e4 fe f5 70 fe ad for HostSwitch 9526 of type VDS. (Error code: 9526)
Failed to install software on host. NSX-V vib is present on host. Please uninstall NSX-V vib

There are no uplink host switch profiles which define all of the uplink teaming names [[DPG_geneve_vlan116]]. (Error code: 8522)

77.52.15.1/24  

Открыл ssh на 
10.1.1.80 
10.1.1.81
10.1.1.82
start service ssh
set service ssh start-on-boot
надо не забыть закрыть

https://10.1.1.83/api/v1/transport-nodes/<transport-node-id>/state

172.16.100.1/24
77.52.13.100/29
77.52.13.101/29

77.52.15.0/24  - Clients Public pool - NEW
77.52.13.96/29 -  vlan32 Transit - NEW

get logical-router <uuid>
    get logical-router <uuid> <route>
    get logical-router <uuid> <route> <prefix>
    get logical-router <uuid> interface <interface-id>
    get logical-router <uuid> interfaces
    get logical-router <uuid> routing-config
    get logical-router routes <prefix>
    get logical-routers
	
Get-CimInstance -ClassName Win32_ComputerSystem


SSD Unity350 5TB Ch1-2 CH121 Payload datastore 2


SAS Unity300 payload 1

#Variable Declaration
$vcloud = Read-Host "enter your vCloud address"
$externalnetwork = Read-Host "enter your external network name"
#Connect to vCloud
Connect-CIServer -Server $vcloud
#Get-External Network
$ExtNet = Get-ExternalNetwork -Name $externalnetwork
#Get Allocated IP Addresses
$ExtNet.ExtensionData.Configuration.IpScopes.IpScope.allocatedipaddresses.IpAddress

#Cool!
Search-Cloud -QueryType AdminVApp | Select-Object name, vdcname, isenabled

Найти все Public IP которые висят сразу на машинах (только gayeway IP :( )
Search-Cloud -QueryType AdminVAppNetwork | Select-Object name, gateway | Sort-Object -Property gateway | select-string "77.52"

получить все подсети у конкретного тенанта
(Get-CIView -CIObject $allorgs | Where-Object {$PSItem.name -eq "FRG"}).networks

### Результат
Network                                                                                                AnyAttr VCloudExtension
-------                                                                                                ------- ---------------
{192.168.221.1/24 routed to inet, FRG DATA direct via 1111 ext net, FRG VIDEO direct via 2113 ext net} 
 
 
Получение перечня всех виртуальных машин в клауде с одинаковыми UUID.

$AllVMs = Get-View -viewtype VirtualMachine -Property Name,Config.ExtraConfig,summary.runtime.powerstate | Where-Object {($_.Config.ExtraConfig | Where-Object {$_.key -eq "cloud.uuid"}).Value -ne $null} | Select-Object @{N="VMName";E={$_.Name}},@{N="CloudUUID";E={($_.Config.ExtraConfig | Where-Object {$_.key -eq "cloud.uuid"}).Value}},@{N="PowerState";E={$_.summary.runtime.powerstate}} | Sort-Object CloudUUID | Group-Object -Property CloudUUID | Where-Object -FilterScript {$_.Count -gt 1} | Select-Object -ExpandProperty Group
или вывести на экран
Get-View -viewtype VirtualMachine -Property Name,Config.ExtraConfig,summary.runtime.powerstate | Where-Object {($_.Config.ExtraConfig | Where-Object {$_.key -eq "cloud.uuid"}).Value -ne $null} | Select-Object @{N="VMName";E={$_.Name}},@{N="CloudUUID";E={($_.Config.ExtraConfig | Where-Object {$_.key -eq "cloud.uuid"}).Value}},@{N="PowerState";E={$_.summary.runtime.powerstate}} | Sort-Object CloudUUID | Group-Object -Property CloudUUID | Where-Object -FilterScript {$_.Count -gt 1} | Select-Object -ExpandProperty Group


start service migration-coordinator

$host.ui.RawUI.WindowTitle = “incloud-9443 vct01”
Connect-ToVFCloud -ConnectToVMwareEntity incloud.vodafone.ua -PortNumber 9443 -vCenterName vct01.kvcloud.local
VMware_NSX_Migration_for_VMware_Cloud_Director


(Search-Cloud -QueryType EdgeGateway).name

 (Search-Cloud -QueryType AdminVApp).name #(быстро)
  =
 (Get-CIVApp).name	# (медленно)
