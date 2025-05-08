$users = Get-Mailbox -Resultsize Unlimited
foreach ($user in $users)
{
   
    Write-Host -ForegroundColor green Setting permission for $($user.alias)
    Add-MailboxFolderPermission -Identity "$($user.alias):\Calendar" -User Default -AccessRights Reviewer -ErrorAction SilentlyContinue
    Set-MailboxFolderPermission -Identity "$($user.alias):\Calendar" -User Default -AccessRights Reviewer
   
}