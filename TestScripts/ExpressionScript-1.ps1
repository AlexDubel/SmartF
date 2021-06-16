$prot = @{Label='LocalPortName'; Expression={
    if ($PSItem.LocalPort       -eq 443)    {'HTTPS'}
    elseif ($PSItem.LocalPort   -eq 80)     {'HTTP'}
    elseif ($PSItem.LocalPort   -eq 22)     {'SSH'}
    elseif ($PSItem.LocalPort   -eq 53)     {'DNS'}
    elseif ($PSItem.LocalPort   -eq 389)    {'LDAP'}
    elseif ($PSItem.LocalPort   -eq 135)    {'LOC-SRV'}
    }
}
Get-NetTCPConnection | Select-Object -Property LocalAddress,OwningProcess,LocalPort,$prot,RemotePort | Sort-Object -Descending LocalPortName | ft