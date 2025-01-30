


foreach ($user in $users)
{
   try {
    Write-Host -ForegroundColor green Setting permission for $($user.alias)
    Add-MailboxFolderPermission -Identity $($user.alias):\calendar -User Default -AccessRights Reviewer -ErrorAction SilentlyContinue
    Set-MailboxFolderPermission -Identity $($user.alias):\calendar -User Default -AccessRights Reviewer
   }
   catch {
    { 
        try {
            Write-Host -ForegroundColor green Setting permission for $($user.alias)
            Add-MailboxFolderPermission -Identity $($user.alias):\Agenda -User Default -AccessRights Reviewer -ErrorAction SilentlyContinue
            Set-MailboxFolderPermission -Identity $($user.alias):\Agenda -User Default -AccessRights Reviewer
            }
        catch {
            {
                Write-Host -ForegroundColor green Setting permission for $($user.alias)
                Add-MailboxFolderPermission -Identity $($user.alias):\Calendrier -User Default -AccessRights Reviewer -ErrorAction SilentlyContinue
                Set-MailboxFolderPermission -Identity $($user.alias):\Calendrier -User Default -AccessRights Reviewer
            }
        }
    }
   }
}
