function GrantMailboxAccess ($u) {

'this script will add Send As and Full access right'
$user = $u
$mailbox = Read-Host -Prompt 'Shared mailbox'
Add-MailboxPermission -Identity $mailbox -User $user -AccessRights FullAccess -InheritanceType All -AutoMapping $true
Add-RecipientPermission -Identity $mailbox -Trustee $user -AccessRights SendAs
$Continue = Read-Host -Prompt "Do you want to add another mailbox?(Y/N)"

if ($Continue -eq "Y") {
    GrantMailboxAccess($user)
}

}

$user = Read-Host -prompt "Enter the user email who needs acces"
GrantMailboxAccess($user)
