$user = Read-Host -Prompt 'User'
$mailbox = Read-Host -Prompt 'Shared mailbox'
Remove-MailboxPermission -Identity $mailbox -User $user -AccessRights FullAccess -InheritanceType All -Confirm:$false
Remove-RecipientPermission -Identity $mailbox -Trustee $user -AccessRights SendAs -Confirm:$false