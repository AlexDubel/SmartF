Function New-CIUser { 
    Param ( 
        $Name, 
        [Switch] $Enabled, 
        $Org, 
        $Role,
        $FullName,
        $Password
    ) 
    Process { 
        Write-Host "New Local User "$name "in " $Org " as "$Role "will be created"
        $OrgED 			= (Get-Org $Org).ExtensionData 
        $orgAdminUser 		= New-Object VMware.VimAutomation.Cloud.Views.User 
        $orgAdminUser.Name 	= $Name 
        $orgAdminUser.IsEnabled	= $Enabled
        #$orgAdminUser.IsExternal = "True"
        #Added from another file
        $orgAdminUser.IsExternal = $false
        $orgAdminUser.FullName 	= $FullName
        $orgAdminUser.Password 	= $Password
        #$vcloud = $DefaultCIServers[0].ExtensionData 
        #$orgAdminRole 		= $vcloud.RoleReferences.RoleReference | where {$_.Name -eq $Role} 
        $orgAdminRole 		= (Get-Org $org).ExtensionData.RoleReferences.RoleReference | where {$PSItem.Name -eq $role}
        #Write-Host -ForegroundColor Yellow orgAdminRole=$orgAdminRole
        $orgAdminUser.Role 	= $orgAdminRole 
        $user 			= $orgED.CreateUser($orgAdminUser) 
        Get-CIUser -Org $Org -Name $Name -Role $role
    } 
}    
$Org      ="NewOrg1"
$Name     ="Alexx4"
$role     ="Organization Administrator"
$FullName = "Alexx Dubel 4"
$Password = "P@ssw0rd"
#Get-CIUser -Org $Org -Name $Name -Role $role 
#if you wish to create user without Enabled status (Disabled).
New-CIUser -Name $Name -Role $role -FullName $FullName -Password $Password -Org $Org 
#if you wish to create user with Enabled status.
#New-CIUser -Name $Name -Role $role -Enabled -FullName $FullName -Password $Password -Org $Org 