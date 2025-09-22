$list = Import-Csv -Path C:\temp\REP_contacts2.csv -Delimiter ";" -Header Email, Name, Name2, FirstName, LastName

foreach ($l in $list)
{
    $first = $l.firstname
    $last = $l.lastname
    $name = "$first $last"
    
    try {
        Add-DistributionGroupMember -Identity "IFRRO Central and South America members" -Member $l.Email
    }
    catch {
            New-MailContact -Name $name -FirstName $first -LastName $last -DisplayName $name -ExternalEmailAddress $l.Email
    Set-MailContact -Identity $name -EmailAddresses $l.Email  <#Do this if a terminating exception happens#>
      Add-DistributionGroupMember -Identity "IFRRO Central and South America members" -Member $l.Email
    }

    
}
