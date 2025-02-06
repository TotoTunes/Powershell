$users = Get-Mailbox -Resultsize Unlimited | Select-Object Name, UserPrincipalName

foreach ($user in $users) {
    $mailbox = $user.UserPrincipalName + ":\Calendar"
    try {
        Write-Host -ForegroundColor green Setting permission for $mailbox
        Set-MailboxFolderPermission -Identity $mailbox -User Default -AccessRights Reviewer -ErrorAction Stop
        Add-MailboxFolderPermission -Identity $mailbox -User Default -AccessRights Reviewer
        Get-MailboxFolderPermission -Identity $mailbox -User Default 
    }
    catch {

        try {
            $mailbox = $user.UserPrincipalName + ":\Agenda"
            Write-Host -ForegroundColor green Setting permission for $mailbox
            Set-MailboxFolderPermission -Identity $mailbox -User Default -AccessRights Reviewer -ErrorAction Stop
            Add-MailboxFolderPermission -Identity $mailbox -User Default -AccessRights Reviewer
            Get-MailboxFolderPermission -Identity $mailbox -User Default 
        }
        catch {
                    
            $mailbox = $user.UserPrincipalName + ":\Calendrier"
            Write-Host -ForegroundColor green Setting permission for $mailbox
            Set-MailboxFolderPermission -Identity $mailbox -User Default -AccessRights Reviewer -ErrorAction SilentlyContinue
            Add-MailboxFolderPermission -Identity $mailbox -User Default -AccessRights Reviewer -ErrorAction SilentlyContinue
            Get-MailboxFolderPermission -Identity $mailbox -User Default                     
        }
    }
}