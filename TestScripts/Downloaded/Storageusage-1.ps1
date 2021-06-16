[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$true,ParameterSetName="Session")]$session,

    [Parameter(Mandatory=$True,ParameterSetName="Server")]
    [String]$Server,

    [Parameter(Mandatory=$True,ParameterSetName="Server")]
    [System.Management.Automation.PSCredential]$Credential,

    [Parameter(ParameterSetName="Session")]
    [parameter(ParameterSetName = "Server")]
    [String]$Minutes,

    [Parameter(ParameterSetName="Session")]
    [parameter(ParameterSetName = "Server")]
    [String]$Hours

    )
Begin{

    #Create Start Time
    if ($minutes){ $starttime = (get-date).AddMinutes(0-$Minutes)}
    if ($hours) { $starttime = (get-date).AddHours(0-$Hours)}
    if ($null -eq $Minutes -and $null -eq $hours) {$starttime = (get-date).AddMinutes(-5)}

    #connect to host
    #Connect-To-VodafoneProdCloud -ConnectToVMwareEntity incloud.vodafone.ua -vCenterName vcp01.kvcloud.local -LoginToIncloud sasha@kvcloud.local
    #if (!($hours)) { $Hours = 24 }
    If ($server){$Session= connect-viserver -server $server -credential $credential -NotDefault}
    
    #Get list of ESXi Hosts in VCenter
    $ESXiHosts = Get-vmhost * -server $Session | Where-Object {$_.PowerState -eq "PoweredOn"}

}

Process{
     
    #Set up Runspace increase Max Threads to increase number of runspaces running at a time
    $MaxThreads = 10
    $RunspacePool = [RunspaceFactory ]::CreateRunspacePool(1, $MaxThreads)
    $RunspacePool.Open()
    $Jobs = @()

    #Get I/O for all VMs on each Host
    Foreach ($ESXihost in $ESXiHosts){

        #Create scriptblock to run for each ESXi host, parameters are passed through to script
        $scriptblock = {

           #Get list of VMs
            $VMs = Get-vm * -server $args[1] -location $args[0] | Where {$_.PowerState -eq "PoweredOn"}

            Foreach($VM in $VMs){
                Try{
                    #Gather I/O statistics for the VM based on the StartTime parameter
                    $numberwrite = get-stat -realtime -entity (get-vm $vm -server $args[1]) -stat disk.numberWriteAveraged.average -start $args[2] -finish (get-date) -ErrorAction Stop
                    $numberread = get-stat -realtime -entity (get-vm $vm -server $args[1]) -stat disk.numberReadAveraged.average -start $args[2] -finish (get-date) -ErrorAction Stop


                    Foreach ($writesample in $numberwrite){[array]$writedata += $writesample.value}
                    Foreach ($readsample in $numberread){[array]$readdata += $readsample.value}

                    $averageread = [int]($readdata | measure-object -average).average
                    $averagewrite = [int]($writedata | measure-object -average).average
                    $writedata = $null
                    $readdata = $null
                }
                Catch{
                    #If metrics are not available set them to 0
                    $averageread = 0
                    $averagewrite = 0
                }

                #Set up Array for reporting I/O stats
                $name = $vm.name
                $ESXiHost = $vm.vmhost
                $status = New-Object System.Object
                $status | Add-Member -type NoteProperty -name VM -value $name
                $status | Add-Member -type NoteProperty -name AvgReadIO -value $averageread
                $status | Add-Member -type NoteProperty -name AvgWriteIO -value $averagewrite
                $status | Add-Member -type NoteProperty -name AvgTotalIO -value ($averagewrite + $averageread)
                $status | Add-Member -type NoteProperty -name ESXHost -value $ESXiHost
                [array]$VMreport += $status
            }
            #Output Report
            $VMreport
        }

        #Run the script block in a separate runspace for the ESXi Host and pass parameter's through
        $VMinfoJob = [powershell ]::Create().AddScript($ScriptBlock).AddArgument($ESXihost).AddArgument($Session).AddArgument($starttime)
        $VMinfoJob.RunspacePool = $RunspacePool
        $Jobs += New-Object PSObject -Property @{
                                Pipe = $VMinfoJob
                                Result = $VMinfoJob.BeginInvoke()
                                JobName = "ESXi-$esxihost"
                                }
    }



    #Wait until jobs are complete
    Do {Start-sleep -Milliseconds 300 } While ( $Jobs.Result.IsCompleted -contains $false)


    #Display output from each Runspace Job for status
    ForEach ($Job in $Jobs){
        $info= $Job.Pipe.EndInvoke($Job.Result)
        [array]$report += $info
    }

    $report #| Sort-Object AvgWriteIO -Descending | Format-Table -AutoSize
}
#Можно запускать так
#  <Папка с программой>\Storageusage-1.ps1 -Server vcp01.kvcloud.local -Hours 24 | Sort-Object AvgWriteIO -Descending | Format-Table -AutoSize