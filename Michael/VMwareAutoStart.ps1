#Variables
$core = "10.8.16.1"
$3par = "10.8.17.76"
$user = "svc_startupscript"
$pass = "FtdqZELDWUr2^y4G*7iT*0#0EM5MkM"
$esx11 = "10.8.17.111"
$esx12 = "10.8.17.112"
$esx13 = "10.8.17.113"
$dsc = "10.8.17.1"
$dns = "10.8.17.63"
$vcenter = "10.8.17.100"
$navdb = "10.8.17.51"

#Test if network,3PAR and ESXs are online
DO {$Ping = Test-Connection $core -quiet}
Until ($Ping -eq $true)
DO {$Ping = Test-Connection $3par -quiet}
Until ($Ping -eq $true)
DO {$Ping = Test-Connection $esx11 -quiet}
Until ($Ping -eq $true)

#Import VMWare Powershell Module
Import-Module VMWare.PowerCLI

#Ignore ESX certificate warnings
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

#Disabled popup to connect to multiple ESXs
Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false 

#Connect to ESXs
Connect-VIServer -Server $esx11 -User $user -Password $pass
Connect-VIServer -Server $esx12 -User $user -Password $pass
Connect-VIServer -Server $esx13 -User $user -Password $pass

#Start domain controllers
Start-VM -VM dsc0*
DO {$Ping = Test-Connection $dsc -quiet}
Until ($Ping -eq $true)

#Start DNS servers
Start-VM -VM dns0*
DO {$Ping = Test-Connection $dns -quiet}
Until ($Ping -eq $true)

#Start vCenter
Start-VM -VM hewbevcsa01.hbe.local
DO {$Ping = Test-Connection $vcenter -quiet}
Until ($Ping -eq $true)


#Start Cisco ISE servers
Start-VM -VM ISE*

#Start FileServers
Start-VM -VM hewbefs00*

#Start DB servers
Start-VM -VM HEWBENAV01
DO {$Ping = Test-Connection $navdb -quiet}
Until ($Ping -eq $true)

#Start ERP Servers
Start-VM -VM HEWBENAV*
Start-VM -VM ERP*
Start-Sleep -s 60

#Start all other servers except normally PoweredOff servers
Start-VM -VM | Where-Object  { $_.Name -notlike 'CA01*' -and $_.Name -notlike 'PRX01*' -and $_.Name -notlike 'PRX02*' -and $_.Name -notlike '*TRS04'}