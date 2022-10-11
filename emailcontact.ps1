$first = Read-Host "Enter the firstname"
$last = Read-Host "Enter the lastname"
$name = "$first $last"
$internalMail = Read-Host "Enter the internal email adress"
$ExMail = Read-Host "Enter the External mail"

New-MailContact -Name $name -FirstName $first -LastName $last -DisplayName $name -ExternalEmailAddress $ExMail
Set-MailContact -Identity $name -EmailAddresses $internalMail