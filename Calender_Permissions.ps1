$mailboxen = get-mailbox -Filter * | Select-Object Name,UserPrincipalName
$u = "leslie@capricorn.be"

foreach ($m in $mailboxen) 
{
    $box = $m.UserPrincipalName +":\Calendar"
    Add-MailboxFolderPermission -Identity $box -User $u -AccessRights Reviewer
}