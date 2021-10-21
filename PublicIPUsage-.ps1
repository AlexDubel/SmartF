$ExcelExportFilePathMan = "C:\Users\oldubel\Documents\PowerShell\vCloud\TestScripts\Outputs\nsx-payload.xlsx"
#$ExcelExportFilePathPayload = "C:\Users\oldubel\Documents\PowerShell\vCloud\TestScripts\Outputs\nsx-payload.xlsx"


function Connect-To-VodafoneNsxServer {
    param (
        $vCenterName = "vcp01.kvcloud.local"
    )
    Clear-Host
    #Write-Host "defaultNSXConnection=$defaultNSXConnection" #-BackgroundColor Yellow
    if ( -not (test-path variable:global:DefaultNSXConnection) ) {
        #if ($defaultNSXConnection -eq $true) {
            if (!($vcmcred)) {
            $vcmcred = Get-Credential -Message "Enter Credential to connect to VC[M,P,T] server." -UserName sasha@kvcloud.local        
            }
        Connect-NsxServer -vCenterServer $vCenterName -Credential $vcmcred
    }
    Write-Host -ForegroundColor Cyan "Already connected to NSX. Continue..."
}
Connect-ToVFCloud -ConnectToVMwareEntity incloud.vodafone.ua -vCenterName vcp01.kvcloud.local
Connect-To-VodafoneNsxServer

if (!($alledges)) { $alledges = Get-NsxEdge }    
#$allsslvpn = $alledges | foreach-object {Get-NsxSslVpn -Edge $PSItem}
$alledges | Select-Object id, version, status, datacenterMoid, datacenterName, tenant, name, fqdn, type, isUniversal, `
@{Label = "SSLVPNEnabled";      expression={(Get-NsxSslVpn -Edge $PSItem).enabled }}, `
@{Label = "LBEnabled";          expression={(Get-NsxLoadBalancer -Edge $PSItem).enabled }}, `
@{Label = "EdgeRoutingEnabled"; expression={(Get-NsxEdgeRouting -Edge $PSItem).enabled }}, `
@{Label = "description";        expression={$PSItem.description -replace "`n", " "}} |`
 Export-Excel -Path $ExcelExportFilePathMan -WorksheetName "NSXEdges"  -AutoSize -BoldTopRow -ClearSheet


#Working


#Measure-Command {
  # Без ключа -parallel время выполнения 8,603 сек  С ключом -parallel 0,072 сек.
    $allNsxEdgeInterface = $alledges | ForEach-Object -Parallel -ThrottleLimit 5 { Write-Host $PSItem.name -ForegroundColor Yellow; Get-NsxEdgeInterface -Edge $PSItem|`
     ForEach-Object { (Get-NsxEdgeInterfaceAddress -Interface $PSItem).primaryaddress } } 
 #  } 
    #$allNsxEdgeInterface
    
    #Write-Host -ForegroundColor Yellow "edgeaddr="$edgeAddrs
    #$edgeAddrs.primaryAddress
    #$edgeAddrs.primaryAddress | Select-String "77." | Measure-Object


<#
!!!Working!!!
#Показать только первый интерфейс (обычно на нем паблик IP)
$alledges | ForEach-Object {Write-Host $PSItem.name -ForegroundColor Yellow; Get-NsxEdgeInterface -Index 0 -Edge $PSItem | `
    ForEach-Object { (Get-NsxEdgeInterfaceAddress -Interface $PSItem).primaryaddress}}
#Показать все интерфейсы
$alledges | ForEach-Object {Write-Host $PSItem.name -ForegroundColor Yellow; Get-NsxEdgeInterface -Edge $PSItem |`
     ForEach-Object {(Get-NsxEdgeInterfaceAddress -Interface $PSItem).primaryaddress}}
#>
    #(Get-CIVApp).Name
    #Get-CIVAppNetwork | Where-Object {$PSItem.Gateway -like "77.*"}
    
    #Можно найти все машины, у которых есть Public IP. 
    # Время выполнения команды ниже 5 мин. 58 сек. 
    #get-civm | ForEach-Object -Parallel {Get-CINetworkAdapter -VM $PSItem}
    # С ключом -Parallel работает намного быстрее. Время выполениня 1 мин. 53 сек. 
    #get-civm | ForEach-Object -Parallel {Get-CINetworkAdapter -VM $PSItem}

<#
Get-NsxEdge "vse-FoEdge (0af580b6-05bb-44a5-92ad-cb7843afef55)" | Get-NsxEdgeInterface
Get-NsxEdge "vse-FoEdge (0af580b6-05bb-44a5-92ad-cb7843afef55)" | Get-NsxEdgeInterfaceAddress
get-help Get-NsxEdgeInterfaceAddress
get-help Get-NsxEdgeInterfaceAddress -examples
$allfointerfaces=Get-NsxEdge "vse-FoEdge (0af580b6-05bb-44a5-92ad-cb7843afef55)" | Get-NsxEdgeInterfaceAddress
$allfointerfaces=Get-NsxEdge "vse-FoEdge (0af580b6-05bb-44a5-92ad-cb7843afef55)" | Get-NsxEdgeInterface
$allfointerfaces | ForEach-Object {Get-NsxEdgeInterfaceAddress $PSItem}

get-org | ForEach-Object {Write-host $PSItem.name -ForegroundColor yellow; get-orgvdc -Org $PSItem}

#>