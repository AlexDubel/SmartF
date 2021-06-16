
    Connect-ToVFCloud -ConnectToVMwareEntity incloud.vodafone.ua -vCenterName vcp01.kvcloud.local -AdmLogin sasha@kvcloud.local
    
    #get-module -ListAvailable
    #exit
    #Get-Datastore
    Get-Datastore | Select-Object Name, @{N="CapacityGB"; E={[math]::round(($PSItem.CapacityGB)/1,2)}}, `
    @{N="FreeSpaceGB"; E={[math]::round(($PSItem.FreeSpaceGB)/1,2)}}, `
    @{N="ProvisionedGB"; E={[math]::round(($PSItem.ExtensionData.Summary.Capacity - $PSItem.ExtensionData.Summary.FreeSpace + `
        $PSItem.ExtensionData.Summary.Uncommitted)/1GB,2) }} |`
    Export-Excel -Path "c:\temp\cdrom-info.xlsx" -Title "Info from $vCenterName about Datastores usage." -AutoSize -WorksheetName "DataStoresUsage"
    #$Snap = 
    Get-VM | Get-Snapshot | Select-Object Description, Created, VM, @{N="SizeMB"; E={[math]::round(($PSItem.SizeMB)/1,2)}} | Sort-Object -Descending SizeMB |`
    Export-Excel -Path "c:\temp\cdrom-info.xlsx" -Title "Info from $vCenterName about VM Snaphots." -AutoSize -WorksheetName "VMSnaphotsSize"
    