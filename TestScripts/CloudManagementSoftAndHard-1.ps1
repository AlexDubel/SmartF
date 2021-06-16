#Get hardware information from Management vCenter
#Connect-VIServer -Server vcm01.kvcloud.local `
# -Credential (Get-Credential -Message "Put your credentials to connect to management vCenter" -UserName sasha@kvcloud.local) -SaveCredentials
#Get-VMHost | Format-Table -AutoSize
#Get-Datacenter
Get-Datastore | Select-Object name, id, type, FileSystemVersion, CapacityGB, FreeSpaceGB, Datacenter | Format-Table -AutoSize
#Get-Datastore | Format-Table -AutoSize
Get-VMHost | Select-Object name, state, ConnectionState, Manufacturer, Model, NumCpu, ProcessorType, StorageInfo, Version, Build, TimeZone
#Example
get-vm zabbix01 | Select-Object *
Get-VDSwitch | Select-Object *

