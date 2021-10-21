Function Disable-NetProxy
{
  Begin { $regKey="HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" }
   #Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings
    Process
    {	Set-ItemProperty -path $regKey ProxyEnable -value 0 -ErrorAction Stop
		  Set-ItemProperty -path $regKey ProxyServer -value "" -ErrorAction Stop
		  Set-ItemProperty -path $regKey AutoConfigURL -Value "" -ErrorAction Stop 
	}
    End
    {	Write-Host -Foreground Yellow "Proxy is now Disabled" }
}
Clear-Host
Disable-NetProxy