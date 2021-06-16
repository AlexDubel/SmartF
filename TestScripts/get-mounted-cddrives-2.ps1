$ConnectToVMwareEntity = "incloud.vodafone.ua"
$LoginToIncloud = "sasha@kvcloud.local"
$vCenterName = "vcp01.kvcloud.local"
#if(!$global:DefaultCIServers.IsConnected -or ($global:DefaultCIServers.name -ne $ConnectToVMwareEntity)){
#    $vcmcred=Get-Credential -Message "Please specify credentials to connect to incloud.vodafone.ua" -UserName $LoginToIncloud
#    Connect-CIServer $ConnectToVMwareEntity -Credential $vcmcred
#    }
   function Connect-To-VodafoneProdCloud {
        param (
            #$vCenterName = "vcp01.kvcloud.local"
        )
        Clear-Host
        #Write-Host "defaultNSXConnection=$defaultNSXConnection" #-BackgroundColor Yellow
        if((!$global:DefaultCIServers.IsConnected) -or ($global:DefaultCIServers.name -ne $ConnectToVMwareEntity)){
            $vcmcred=Get-Credential -Message "Please specify credentials to connect to $ConnectToVMwareEntity" -UserName $LoginToIncloud
            Connect-CIServer $ConnectToVMwareEntity -Credential $vcmcred }
            
            else { Write-Host -ForegroundColor Cyan "Already connected to $ConnectToVMwareEntity. Continue..."  }
            if((!$global:DefaultVIServers.IsConnected) -or ($global:DefaultVIServers.name -ne $vCenterName)){
                Write-Host -ForegroundColor Yellow "global:DefaultVIServers.IsConnected =" $global:DefaultVIServers.IsConnected
                Write-Host -ForegroundColor Yellow "global:DefaultVIServers.name =" $vCenterName
                $vcmcred=Get-Credential -Message "Please specify credentials to connect to $vCenterName" -UserName $LoginToIncloud
                Connect-VIServer -Server $vCenterName -Credential $vcmcred }
            else { Write-Host -ForegroundColor Cyan "Already connected to $vCenterName. Continue..."    }
        #Write-Host -ForegroundColor Cyan "Already connected to $ConnectToVMwareEntity. Continue..."
    }
    function Get-VMCDROM-Info {
        $allcivm=Get-CIVM
        #$allvmtocivm= $allcivm | Get-VM
        #get-civm | Select-Object name, org, orgvdc, Status | Format-Table -AutoSize
        #Working 
        #$allvms | ForEach-Object {Get-CDDrive -VM $PSItem.name | Select-Object Parent, ConnectionState | Where-Object ConnectionState -like "Connected*"}
        #
        #[string[]]$result = "" | Select-Object [string[]]Parent, [string[]]ConnectionState, [string[]]Name, [string[]]Org, [string[]]OrgVdc, [string[]]Status
        #[array]$result = "" | Select-Object Parent, ConnectionState, Name, Org, OrgVdc, Status
        $MyExportarray = @()
        #$allcivm | ForEach-Object -parallel  {
            
        #}
          $allcivm | ForEach-Object {
            #$PSItem | get-vm | Get-CDDrive -VM $PSItem.name | Select-Object Parent, ConnectionState | Where-Object ConnectionState -like "Connected*"
            #$allcivm | ForEach-Object {Write-host -foregroundcolor Cyan $PSItem"`t" -NoNewline; $PSItem | get-vm}
            #Write-Host -ForegroundColor Cyan $PSItem.Name
            $ll=$PSItem | get-vm 
            #$kk = Get-CDDrive -VM $ll.name

            $kk = Get-CDDrive -VM $ll.name | Select-Object Parent, ConnectionState, IsoPath | Where-Object ConnectionState -like "Connected*"
            
            #$kk = Get-CDDrive -VM $ll.name | Where-Object ConnectionState -like "Connected*"
            
            $infoObject = New-Object PSObject        
            if ($kk) {
                #Write-Host kk=$kk
                #$mm = $PSItem | Select-Object name, org, orgvdc, Status #| Format-Table -AutoSize
             #$result+=$kk.Parent, $kk.ConnectionState, $mm.name, $mm.Org, $mm.OrgVdc, $mm.Status
             #Write-Host -BackgroundColor Black "kk = "$kk
             #Write-Host -BackgroundColor Black "kk.Parent="$kk.Parent.Name "$kk.ConnectionState="$kk.ConnectionState.connected
             #exit
             #$result+=$kk.Parent, $kk.ConnectionState.connected, $PSItem.Name, $PSItem.Org, $PSItem.OrgVdc, $PSItem.Status
             Add-Member -inputObject $infoObject -memberType NoteProperty -name "Parent"            -value $kk.Parent 
             Add-Member -inputObject $infoObject -memberType NoteProperty -name "ConnectionState"   -value $kk.ConnectionState
             Add-Member -inputObject $infoObject -memberType NoteProperty -name "ISOPath"           -value $kk.IsoPath
             Add-Member -inputObject $infoObject -memberType NoteProperty -name "Name"              -value $PSItem.Name
             Add-Member -inputObject $infoObject -memberType NoteProperty -name "Org"               -value $PSItem.Org
             Add-Member -inputObject $infoObject -memberType NoteProperty -name "OrgVDC"            -value $PSItem.OrgVdc
             Add-Member -inputObject $infoObject -memberType NoteProperty -name "Status"            -value $PSItem.Status
                         
             #$infoObject | Export-Csv -path "c:\temp\cdrom-info.csv" -NoTypeInformation -Encoding UTF8 -Append #Export the results in csv file.
            $MyExportarray += $infoObject
            }
        } 
        #$MyExportarray | Export-Csv -path "c:\temp\cdrom-info.csv" -NoTypeInformation -Encoding UTF8 #-Append #Export the results in csv file.
        $MyExportarray | Export-Excel -Path "c:\temp\cdrom-info.xlsx" -Title "Info from $vCenterName about Cdrom connected to VM."`
         -AutoSize -WorksheetName "CDROM-in-VM" 
        #$infoObject| Export-Csv -path "c:\temp\cdrom-infoobject.csv" -NoTypeInformation -Encoding UTF8 #-Append #Export the results in csv file.
        #$result | export-csv -Path "c:\temp\cdrom-info.csv" -Delimiter "," -NoTypeInformation
    }
    
    Connect-To-VodafoneProdCloud
    Get-VMCDROM-Info 
    