$path = Read-Host "Enter path to file"
$list = Import-Csv -Path $path -Delimiter ";" -Header Name, First, Last, mail
$groupname = Read-Host "Enter group name"

foreach ($l in $list) {

    $n = $l.First + " " + $l.Last
    $m = $l.mail
 
    try {
        $ADObject = Get-ADObject -Filter 'mail -eq $m'
        Set-ADGroup -Identity $groupname -Add @{'member' = $ADObject.DistinguishedName }
    }

    catch {
        New-ADObject -Name $n -DisplayName $n -Type contact -Path "OU=Contacts,OU=Brussels,DC=reprobel,DC=be" -OtherAttributes @{'Proxyaddresses' = "SMTP:$m"; 'givenName' = $l.First; 'sn' = $l.Last; 'mail' = $m }
        $ADObject = Get-ADObject -Filter 'mail -eq $m'
        Set-ADGroup -Identity $groupname -Add @{'member' = $ADObject.DistinguishedName }
    }

 
}