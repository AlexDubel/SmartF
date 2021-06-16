
Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCeip $false -InvalidCertificateAction Ignore

#connect to VBR server (на машине radmin например). 
Add-PSSnapin VeeamPSSnapin
Connect-VBRServer -Server veeamcloud01.kvcloud.local -Port 9392 -User kvcloud\oldubel 


