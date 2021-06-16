Function New-Org {
    Param (
        $Name,
        $FullName,
        $Description,
        [Switch]$Enabled,
        [Switch]$PublishCatalogs
    )
    Process {
        $vcloud = $DefaultCIServers[0].ExtensionData
       
        $AdminOrg = New-Object VMware.VimAutomation.Cloud.Views.AdminOrg
        $adminOrg.Name          = $name
        $adminOrg.FullName      = $FullName
        $adminOrg.Description   = $description
        $adminOrg.IsEnabled     = $Enabled

        $orgSettings = New-Object VMware.VimAutomation.Cloud.Views.OrgSettings
        $orgGeneralSettings = New-Object VMware.VimAutomation.Cloud.Views.OrgGeneralSettings
        $orgGeneralSettings.CanPublishCatalogs = $PublishCatalogs
        $orgSettings.OrgGeneralSettings = $orgGeneralSettings

        $adminOrg.Settings = $orgSettings

        $org = $vcloud.CreateOrg($adminOrg)
        Get-Org -Name $name
    }
}

Function New-CIUser {
    Param (
        $Name,
        $Pasword,
        $FullName,
        [Switch]$Enabled,
        $Org,
        $Role
    )
    Process {
        $OrgED = (Get-Org $Org).ExtensionData
        $orgAdminUser           = New-Object VMware.VimAutomation.Cloud.Views.User
        $orgAdminUser.Name      = $Name
        $orgAdminUser.FullName  = $FullName
        $orgAdminUser.Password  = $Pasword
        $orgAdminUser.IsEnabled = $Enabled

        $vcloud = $DefaultCIServers[0].ExtensionData
       
        $orgAdminRole = $vcloud.RoleReferences.RoleReference | Where-Object {$PSItem.Name -eq $Role}
        $orgAdminUser.Role = $orgAdminRole
       
        $user = $orgED.CreateUser($orgAdminUser)
        Get-CIUser -Org $Org -Name $Name
    }
}   

Function New-OrgVDC {
    Param (
        $Name,
        [Switch]$Enabled,
        $Org,
        $ProviderVDC,
        $AllocationModel,
        $CPULimit,
        $CPUAllocated,
        $MEMAllocated,
        $MEMLimit,
        $StoraqeLimit
    )
    Process {
        $adminVdc                               = New-Object VMware.VimAutomation.Cloud.Views.AdminVdc
        $adminVdc.Name                          = $name
        $adminVdc.IsEnabled                     = $Enabled
        $providerVdc                            = Get-ProviderVdc $ProviderVDC
        $providerVdcRef                         = New-Object VMware.VimAutomation.Cloud.Views.Reference
        $providerVdcRef.Href                    = $providerVdc.Href
        $adminVdc.ProviderVdcReference          = $providerVdcRef
        $adminVdc.AllocationModel               = $AllocationModel
        $adminVdc.ComputeCapacity               = New-Object VMware.VimAutomation.Cloud.Views.ComputeCapacity
        $adminVdc.ComputeCapacity.Cpu           = New-Object VMware.VimAutomation.Cloud.Views.CapacityWithUsage
        $adminVdc.ComputeCapacity.Cpu.Units     = "MHz"
        $adminVdc.ComputeCapacity.Cpu.Limit     = $CPULimit
        $adminVdc.ComputeCapacity.Cpu.Allocated = $CPUAllocated
        $adminVdc.ComputeCapacity.Memory        = New-Object VMware.VimAutomation.Cloud.Views.CapacityWithUsage
        $adminVdc.ComputeCapacity.Memory.Units  = "MB"
        $adminVdc.ComputeCapacity.Memory.Limit  = $MEMLimit
        $adminVdc.ComputeCapacity.Memory.Allocated = $MEMAllocated
        $adminVdc.StorageCapacity               = New-Object VMware.VimAutomation.Cloud.Views.CapacityWithUsage
        $adminVdc.StorageCapacity.Units         = "MB"
        $adminVdc.StorageCapacity.Limit         = $StorageLimit
       
        $OrgED = (Get-Org $Org).ExtensionData
        $orgVdc = $orgED.CreateVdc($adminVdc)
        Get-OrgVdc $name
    }
}

Function Connect-ToTestCloud {
    $cred = Get-Credential -Message "Enter credentials to connect to TEST incloud.vodafone.ua" -UserName sasha@kvcloud.local
    Connect-CIServer -Server incloud.vodafone.ua -Port 9443 -Credential $cred 

}

Connect-ToTestCloud
exit 
## Create a new Org
#Write-Host "newOrg-02-Feb-2021" -Description "Тестовая организация №2 Дубель Саша дата создания $(get-date)"
#New-Org -Name "NewOrg1" -FullName "newOrg-02-Feb-2021" -Description "Тестовая организация 2 Дубель Саша дата создания $(get-date)" -Enabled
##New-Org -Name "PowerCLIRocks" -FullName "PowerCLI Rocks hard!" -description "PowerCLI really rocks hard." -Enabled

# Create a new Administrator for that Org
###New-CIUser -Enabled -Name "PowerCLIRocksAdmin" -FullName "PowerCLI Rocks Administrator"
   ### -Pasword "P@ssw0rd" -Org "PowerCLIRocks" -Role "Organization Administrator"

New-CIUser -Enabled -Name "Alex" -FullName "Alex Administrator PCLI" -Pasword "P@ssw0rd" -Org "NewOrg1" -Role "Organization Administrator"
   exit
# Create a new Org VDC for that Org
New-OrgVDC -Name "NewOrg1 oVDC" -Org "NewOrg1" -Allocationmodel "AllocationPool" -Enabled $true`
    -CpuAllocationGHz 50 -CPULimit 100 -MemoryAllocationGB 32 -ProviderVDC "pVDC01" -StorageAllocationGB 200
    ##New-OrgVdc -Name "NewOrg1 oVDC" -Org "NewOrg1" -ProviderVdc "pVDC01"  -AllocationModelAllocationPool`
  ##-CpuAllocationGHz 5 -Description "NewOrg1 oVDC Description" -MemoryAllocationGB 32 -NetworkPool ((Get-NetworkPool).name) -StorageAllocationGB 100

# Create all the Urgent Orgs
#Import-Csv c:\UrgentWork\UrgentOrgs.csv | Foreach {
#    New-Org -Name $_.OrgName -FullName $_.OrgFullName -description $_.OrgDesc -Enabled
#}