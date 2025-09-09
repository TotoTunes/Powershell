$list = Import-Csv -Path C:\temp\reprobel_contacts.csv -Delimiter ";" -Header Email, Name, Name2, FirstName, LastName

foreach ($l in $list)
{
    $first = $l.firstname
    $last = $l.lastname
    $name = "$first $last"
    
    New-MailContact -Name $name -FirstName $first -LastName $last -DisplayName $name -ExternalEmailAddress $l.Email
    Set-MailContact -Identity $name -EmailAddresses $l.Email  
}
