#$vchost="incloud.vodafone.ua"
#$vctestport="9443"
#$mycred=(get-Credential -Message "Enter your login and password to connect to the VMware vCloud Director" -UserName "sasha@kvcloud.local")
###$RootCred=New-VICredentialStoreItem -Host $vchost -User $mycred.username -Password $mycred.Password
###Connect-CIServer -Server $vchost -Port $vctestport -User $mycred.username -Password $mycred.Password
#Connect-CIServer -Server $vchost -Port $vctestport -Credential $mycred
# Working!
$cred=(Get-Credential -Message "Please enter password to connect to Cloud Director" -UserName sasha@kvcloud.local)
Connect-VIServer -Server vcm01.kvcloud.local -Credential $cred
Connect-NsxServer -vCenterServer vcm01.kvcloud.local -Credential $cred
#Connect-VIServer -Server vcm01.kvcloud.local `
# -Credential (Get-Credential -Message "Put your credentials to connect to management vCenter" -UserName sasha@kvcloud.local) -SaveCredentials
#Get-CIDatastore
#$NetAdapterCI=Get-CINetworkAdapter
#$NetAdapterCI 


Get-CINetworkAdapter #| Select-Object {$PSItem.IPAddressAllocationMode, $PSItem.VAppNetwork, $PSItem.VM, $PSItem.IPAddress,$PSItem.MACAddress, $PSItem.ExternalIPAddress}

#Install Backup service
#Install-WindowsFeature Windows-Server-Backup

#Check SMB v1 is installed
$smb1 = Invoke-Command -Session $ss -ScriptBlock {Get-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" }
$smb1 | Format-Table PSComputerName, FeatureName, State
#Enable or disable SMB v1
Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol

#Check NSX-V or NSX-T is installed and it version
$extensionManager = Get-View ExtensionManager

foreach ($extension in $extensionManager.ExtensionList) {
    if($extension.key -eq "com.vmware.vShieldManager") {
        Write-Host "NSX-V is installed with version"$extension.Version
    } elseif($extension.key -eq "com.vmware.nsx.management.nsxt") {
        Write-Host "NSX-T is installed with version"$extension.Version
    }
}


