$path = "OU=Disabled Users,OU=VINCIPark,DC=vincibe,DC=lan"
$User = Read-host "Enter username to disable"
$ADObject = Get-ADUser -Identity $User

Write-Host $ADObject.Name "will be disabled"
Disable-ADAccount $User

$ADGroups = Get-ADPrincipalGroupMembership -Identity  $User | where {$_.Name -ne “Domain Users”}

$ADGroups | Export-Csv -Path C:\Temp\ADGroups\$User'.csv'
Write-Host "All AD groups have been exported to C:\Temp\ADgroups\username.csv"

Remove-ADPrincipalGroupMembership -Identity $User -MemberOf $AdGroups -confirm:$false -verbose

Write-Host $ADObject.Name "will be moved to the Disabled OU" -ForegroundColor Yellow
Get-ADUser $User | Move-ADObject -TargetPath $path