cd C:\temp\ConnectO365Services.ps1
$sharedmailbox = Read-Host -Prompt 'Enter the Shared Mailbox name'
$usermailbox = Read-Host -Prompt 'Enter the user email address'

$AutoMap = Read-Host -Prompt 'Do you want to remove automapping? (Y/N)'

if($AutoMap = 'Y') {
Add-MailboxPermission -Identity $sharedmailbox -User $usermailbox -AccessRights FullAccess -AutoMapping $false
Add-RecipientPermission $sharedmailbox -AccessRights sendas -Trustee $usermailbox
} 

else
 {
Add-MailboxPermission -Identity $sharedmailbox -User $usermailbox -AccessRights FullAccess -AutoMapping $true
Add-RecipientPermission $sharedmailbox -AccessRights sendas -Trustee $usermailbox
}

