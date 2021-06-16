Function Get-VMKLinuxDrivers {
    <#
        .NOTES
        ===========================================================================
        Created by:    William Lam
        Organization:  VMware
        Blog:          www.virtuallyghetto.com
        Twitter:       @lamw
        ===========================================================================
        .DESCRIPTION
            This function returns the list of ESXi hosts within a vSphere Cluster
            that is currently has VMklinux Drivers in use and the list of drivers
        .PARAMETER Cluster
            The name of a vSphere Cluster to analyze
        .EXAMPLE
            Get-VMKLinuxDrivers -Cluster Cluster-01
    #>
    param (
        [Parameter(Mandatory=$true)][string]$Cluster
    )
    #$vmhosts = Get-VMHost | Where-Object {$PSItem.ConnectionState -eq "Connected"}
    $vmhosts = Get-Cluster $Cluster | Get-VMHost | Where-Object {$_.ConnectionState -eq "Connected"}

    $results = @()
    foreach ($vmhost in $vmhosts | Sort-Object -Property name) {
        Write-Host "Checking $($vmhost.name) ..."
        $esxcli = Get-EsxCli -VMHost $vmhost -V2
        $modules = $esxcli.system.module.list.Invoke() | Where-Object {$PSItem.IsLoaded -eq $true}
        $vmklinuxDrivers = @()
        foreach ($module in $modules) {
            $moduleName         = $esxcli.system.module.get.CreateArgs()
            $moduleName.module  = $module.name
            $vmkernelModule     = $esxcli.system.module.get.Invoke($moduleName)

            if($vmkernelModule.RequiredNamespaces -match "com.vmware.driverAPI") {
                $vmklinuxDrivers += $module.name
            }
        }

        if($vmklinuxDrivers) {
            $tmp = [pscustomobject] @{
                VMHost = $vmhost.name;
                VMKLinuxDriver = ($vmklinuxDrivers -join ",")
            }
            $results += $tmp
        }
    }
    $results | Sort-Object -Property VMHost | Format-Table
}

$ConnectToVMwareEntity = "vcp01.kvcloud.local"
#$global:DefaultVIServers.IsConnected
#$global:DefaultVIServers.name
#if ($global:DefaultVIServers.name -eq $ConnectToVMwareEntity) { Write-Host 123}
#exit 
if( (!$global:DefaultVIServers.IsConnected) -or ($global:DefaultVIServers.name -ne $ConnectToVMwareEntity) ){
    $vcmcred=Get-Credential -Message "Please specify credentials to connect to $ConnectToVMwareEntity" -UserName sasha@kvcloud.local
    Connect-VIServer $ConnectToVMwareEntity -Credential $vcmcred
    #$orginfo = Get-org 
    }
    Get-VMKLinuxDrivers