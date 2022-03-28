$TargetPortalAddresses = @("10.8.16.61")
$LocaliSCSIAddress = "10.8.17.73"

Foreach ($TargetPortalAddress in $TargetPortalAddresses){
New-IscsiTargetPortal -TargetPortalAddress $TargetPortalAddress -TargetPortalPortNumber 3260 -InitiatorPortalAddress $LocaliSCSIAddress
}
 
New-MSDSMSupportedHW -VendorId MSFT2005 -ProductId iSCSIBusType_0x9
 
Foreach ($TargetPortalAddress in $TargetPortalAddresses){
Get-IscsiTarget | Connect-IscsiTarget -IsMultipathEnabled $false -TargetPortalAddress $TargetPortalAddress -InitiatorPortalAddress $LocaliSCSIAddress -IsPersistent $true
}
 
#Failover policy only via MPIO
Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy FOO

#Set offline disks online
Get-Disk | Where-Object IsOffline -Eq $True | Set-Disk -IsOffline $False
#If disk is ReadOnly, make it writable
Get-Disk | Where-Object IsReadOnly -Eq $True | Set-Disk -IsReadOnly $False
