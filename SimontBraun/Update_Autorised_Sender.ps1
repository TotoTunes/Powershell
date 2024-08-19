$DL = Read-Host "What is the name of the DL?"
$names = Get-ADGroupMember -Identity $DL
foreach ($n in $names) {
Write-Host $n
    Set-ADGroup -Identity "Liste Comite de Direction" -Add @{authOrig=$n.distinguishedName}
}