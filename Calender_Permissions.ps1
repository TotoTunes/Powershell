$mailboxen = get-mailbox -Filter * | Select-Object Name,UserPrincipalName
$u = Read-Host "Enter email of user who needs access"

foreach ($m in $mailboxen) 
{
   try {
    $box = $m.UserPrincipalName +":\Calendar"
    Add-MailboxFolderPermission -Identity $box -User $u -AccessRights Reviewer -ErrorAction SilentlyContinue
   }
   catch {
    { 
        try {
            $box = $m.UserPrincipalName +":\Agenda"
            Add-MailboxFolderPermission -Identity $box -User $u -AccessRights Reviewer -ErrorAction SilentlyContinue
            }
        catch {
            {
                $box = $m.UserPrincipalName +":\Calendrier"
                Add-MailboxFolderPermission -Identity $box -User $u -AccessRights Reviewer
            }
        }
    }
   }
}