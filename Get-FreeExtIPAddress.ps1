Connect-ToVFCloud -ConnectToVMwareEntity incloud.vodafone.ua -vCenterName vcp01.kvcloud.local
function Get-FreeExtIPAddress([String]$extnetName){

    $extnet = Get-ExternalNetwork -name $extnetName
    
    $ExtNetView = $Extnet | Get-CIView
    
    $allocatedGatewayIPs=$extnetView.Configuration.IpScopes.IpScope[0].SubAllocations.SubAllocation.IpRanges.IpRange
    #Write-Host allocatedGatewayIPs=$allocatedGatewayIPs
    #exit
    
    [int]$ThirdStartingIP   =[System.Convert]::ToInt32($extnet.StaticIPPool[0].FirstAddress.IPAddressToString.Split(".")[2],10)
    [int]$ThirdEndingIP     =[System.Convert]::ToInt32($extnet.StaticIPPool[0].LastAddress.IPAddressToString.Split(".")[2],10)
    [int]$FourthStartingIP  =[System.Convert]::ToInt32($extnet.StaticIPPool[0].FirstAddress.IPAddressToString.Split(".")[3],10)
    [int]$FourthEndingIP    =[System.Convert]::ToInt32($extnet.StaticIPPool[0].LastAddress.IPAddressToString.Split(".")[3],10)
    
    $octet=$extnet.StaticIPPool[0].FirstAddress.IPAddressToString.split(".")
    $3Octet= ($octet[0]+"."+$octet[1]+"."+$octet[2])
    $2Octet= ($octet[0]+"."+$octet[1])
    $ips= @()
    
    if($ThirdStartingIP -eq $ThirdEndingIP) {
    
    $ips = $FourthStartingIP..$FourthEndingIP | ForEach-Object {$3Octet+'.'+$PSItem}
    
    }
    else {
    
        do {
            for($i=$FourthStartingIP; $i -le255; $i++) { $ips+= ($2Octet+ "." + $ThirdStartingIP + "."+$i) }
        $ThirdStartingIP = $ThirdStartingIP+ 1
        }
    while($ThirdEndingIP -ne $ThirdStartingIP)
    for($i=0; $i -le $FourthEndingIP; $i++) {
    $ips+= ($2Octet+ "." + $ThirdStartingIP + "."+$i)  }
    }
    $allocatedIPs=$ExtNetView.Configuration.IpScopes.IpScope[0].AllocatedIpAddresses.IpAddress
    
    for($i=0; $i -le $ips.count; $i++) {
    
    for($j=0; $j -lt $allocatedGatewayIPs.count; $j++) {
    
    if($ips[$i] -eq $allocatedGatewayIPs[$j].StartAddress) { $ips = $ips | Where-Object { $PSItem -ne $ips[$i] } 
    
    $i--
    
    }
    
    }
    
    for($z=0; $z -lt $allocatedIPs.count; $z++) {
    
    if($ips[$i] -eq $allocatedIPs[$z]) {
    
    $ips = $ips | Where-Object { $PSItem -ne $ips[$i] }
    
    $i--
    
    }
    
    }
    
    }
    Write-Host -ForegroundColor Yellow "======================="
    Write-host allocatedIPsCount -ForegroundColor Cyan
    $allocatedIPs | Sort-Object
    Write-Host -ForegroundColor Yellow "======================="
    return $Ips 
    
    }
    #Get-ExternalNetwork
    #exit
    #dirty hack (сеть указана вручную из списка который можно получить через Get-ExternalNetwork)
    Get-FreeExtIPAddress -extnetName "External 77.52.1.1/25"