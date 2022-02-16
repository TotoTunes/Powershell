
$list = Import-Csv -Path 'C:\Temp\User to Deactivate\Inventaris-adressen-personeelsleden_check-HR.csv' -header 'Personeelslid','emailadres','verwijderen' -Delimiter ';'
$listclean = ($list|? verwijderen -match "Yes").emailadres

foreach ($User in $listclean) {
$file = Get-ADUser -Filter{EmailAddress -eq $User}
$filename= $file.SamAccountName
$filename

$ADGroups = Get-ADPrincipalGroupMembership -Identity  $filename | where {$_.Name -ne “Utilisa. du domaine”}
$ADGroups | Export-Csv -Path C:\Temp\ADGroups\$filename'.csv'

Disable-ADAccount $filename
Get-ADUser $filename | Move-ADObject -TargetPath "OU=Disabled-Users,OU=Accounts,OU=BE,DC=vincipark,DC=net"


Remove-ADPrincipalGroupMembership -Identity $filename -MemberOf $AdGroups -confirm:$false -verbose
}