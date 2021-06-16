<#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
#$ExcelExportFilePathMan = "C:\Users\oldubel\Documents\PowerShell\vCloud\TestScripts\Outputs\nsx-management.xlsx"
$ExcelExportFilePathMan = "C:\Users\oldubel\Documents\PowerShell\vCloud\TestScripts\Outputs\nsx-payload.xlsx"
$ExcelExportFilePathPayload = "C:\Users\oldubel\Documents\PowerShell\vCloud\TestScripts\Outputs\nsx-payload.xlsx"
function Connect-To-VodafoneNsxServer {
    param (
        $vCenterName = "vcm01.kvcloud.local"
    )
    Clear-Host
    #Write-Host "defaultNSXConnection=$defaultNSXConnection" #-BackgroundColor Yellow
    if ( -not (test-path variable:global:DefaultNSXConnection) ) {
        #if ($defaultNSXConnection -eq $true) {
        $vcmcred = Get-Credential -Message "Enter Credential to connect to VC[M,P,T] server." -UserName sasha@kvcloud.local
        Connect-NsxServer -vCenterServer $vCenterName -Credential $vcmcred
    }
    Write-Host -ForegroundColor Cyan "Already connected to NSX. Continue..."
}
Connect-To-VodafoneNsxServer

$alledges = Get-NsxEdge 
$alledges | Select-Object id, version, description, status, datacenterMoid, datacenterName, tenant, name, fqdn, vnics, type, isUniversal, hypervisorAssist`
#Get-NsxEdge | Select-Object id, version, description, status, datacenterMoid, datacenterName, tenant, name, fqdn, vnics, type, isUniversal, hypervisorAssist`
| Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXEdges"  -AutoSize -BoldTopRow -ClearSheet
#-TitleBold -TitleSize 24 -TitleFillPatt LightGray -Title "123" -TitleBackgroundColor Red

$alledges | ForEach-Object {
Get-NsxLoadBalancer -Edge $PSItem.virtualserver |`
    Select-Object virtualServerId, name, enabled, ipAddress, protocol, port, connectionLimit, connectionRateLimit, defaultPoolId, applicationProfileId, `
    enableServiceInsertion, accelerationEnabled, @{label ="ApplicationRuleId"; expression = {[string]$PSItem.applicationRuleId -replace " ", ", "} } }|`
    Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXVirtServers"  -AutoSize -BoldTopRow #-ClearSheet
 
#$balancer0=Get-NsxLoadBalancer -Edge $alledges[0] # Not in use, therefore it is commented
#$balancer1 = Get-NsxLoadBalancer -Edge $alledges[1]
$allbalancers = Get-NsxLoadBalancer
Get-NsxLoadBalancerPool -LoadBalancer $balancer1 | Select-Object poolId, name, ipVersionFilter, algorithm, transparent, monitorId, edgeId |`
    Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXBalancerPools"  -AutoSize -ClearSheet -BoldTopRow        

Get-NsxLoadBalancerPool -LoadBalancer $balancer1 | ForEach-Object { Get-NsxLoadBalancerPoolMember -LoadBalancerPool $PSItem } |`
    Select-Object memberId, ipAddress, weight, monitorPort, port, maxConn, minConn, condition, name, edgeId, poolId |`
    Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXBalancerPoolMemberss"  -AutoSize -ClearSheet -BoldTopRow
#Get-NsxLoadBalancerPool -LoadBalancer $balancer1 | ForEach-Object {Get-NsxLoadBalancerPoolMember -LoadBalancerPool $PSItem}  | Sort-Object -Property name | Format-Table -AutoSize
Get-NsxLoadBalancerMonitor -LoadBalancer $balancer1 |`
    Select-Object monitorId, type, interval, timeout, maxRetries, name, edgeId |`
    Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXBalancerMonitors"  -AutoSize -ClearSheet -BoldTopRow 
Get-NsxLoadBalancerApplicationProfile -LoadBalancer $balancer1 |`
    Select-Object applicationProfileId, name, insertXForwardedFor, sslPassthrough, template, serverSslEnabled, clientSsl, serverSsl, edgeId |`
    Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXBalancerAppProfiles"  -AutoSize -ClearSheet -BoldTopRow
Get-NsxLoadBalancerApplicationRule -LoadBalancer $balancer1 |`
    Select-Object applicationRuleId, name, script |`
    Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXBalancerAppRules"  -AutoSize -ClearSheet -BoldTopRow 

    #У кого включен SSL VPN
    #$alledges | ForEach-Object { Get-NsxSslVpn -Edge $PSItem | Where-Object enabled -eq $true}

    #Edge certificates (возвращает три объекта)
    #$alledges | ForEach-Object { (Get-NsxEdgeCertificate -Edge $PSItem).objectId }


 
 
