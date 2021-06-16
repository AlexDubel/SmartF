Function Get-EdgeConfig ($EdgeGateway)
{
    $Edgeview               = $EdgeGateway | get-ciview
    $webclient              = New-Object system.net.webclient
    $webclient.Headers.Add("x-vcloud-authorization",$EdgeView.Client.SessionKey)
    $webclient.Headers.Add("accept","application/*+xml;version=32.0")
    $edgeview.id -match "(?<=urn:vcloud:gateway:).*"
    $edgeID = $Matches[0]
    $requrl = "https://" + $global:DefaultCIServers.name + "/network/edges/" + $edgeID
    [xml]$EGWConfXML = $webclient.DownloadString($requrl)
    $Holder = "" | Select-Object Firewall, NAT, LoadBalancer, DHCP, L2VPN
    $Holder.Firewall        =   $EGWConfXML.edge.features.firewall.firewallrules.firewallrule
    $Holder.NAT             =   $EGWConfXML.edge.features.nat.natrules.natrule
    $Holder.LoadBalancer    =   $EGWConfXML.edge.features.LoadBalancer
    $Holder.DHCP            =   $EGWConfXML.edge.features.DHCP
    $Holder.L2VPN           =   $EGWConfXML.edge.features.L2VPN
    Return $Holder
}

function Get-FirewallDetails ($config)
{
    foreach ($fwrule in $config.firewall){
        $protocol = $fwrule.application.service.protocol
        $fwrule.SetAttribute("protocol",$protocol)
        $port = $fwrule.application.service.port
        $fwrule.SetAttribute("port",$port)
        $srcport = $fwrule.application.service.sourcePort
        $fwrule.SetAttribute("sourcePort",$srcport)
        $destex = $fwrule.destination.exclude
        $fwrule.SetAttribute("destExclude",$destex)
        $destip = $fwrule.destination.ipAddress
        $fwrule.SetAttribute("destIP",$destip)
        $srcex = $fwrule.source.exclude
        $fwrule.SetAttribute("srcExclude",$srcex)
        $srcip = $fwrule.source.ipAddress
        $fwrule.SetAttribute("srcIP",$srcip)
    }
}
Connect-To-VodafoneProdCloud -ConnectToVMwareEntity incloud.vodafone.ua -vCenterName vcp01.kvcloud.local -LoginToIncloud sasha@kvcloud.local
$Gateways = Search-Cloud -QueryType EdgeGateway
#24-й элемент в массиве это ОГТСУ
$Config = Get-EdgeConfig -EdgeGateway $Gateways[23]
Get-FirewallDetails $Config

$Config.L2VPN       | Export-Excel -Path "c:\temp\edge-ogtsu-info.xlsx" -Title "Info from $vCenterName OGTSU Edge L2VPN."   -AutoSize -WorksheetName "OGTSU Edge L2VPN info" 
$Config.Firewall    | Export-Excel -Path "c:\temp\edge-ogtsu-info.xlsx"-Title "Info from $vCenterName OGTSU Edge Firewall"  -AutoSize -WorksheetName "OGTSU Edge Firewall" 