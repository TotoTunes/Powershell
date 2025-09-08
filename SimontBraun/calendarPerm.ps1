$right=@("AvailabilityOnly","LimitedDetails","Reviewer","Editor")[2]
$logfile = "C:\_Scripts\calendarPermsission\calendarPerm.log"
$pwd1="01000000d08c9ddf0115d1118c7a00c04fc297eb01000000ea6d65c9dc1d3f4b99c29502172ac8c60000000002000000000003660000c00000001000000092f4d9b494453067221b544e502ba1780000000004800000a000000010000000e0c104c6c97c1a82668dff3bd6c9fd6b28000000ca16046ae58fafa5a0b765765d9244217b8b6862720d3ad7b7eb5c7919481fd3d2fbab5d5a87f5951400000000b2823cbd291da3293ace6e413d996005ecca24"


function writelog($s) {
    $d = Get-Date -Format "yyyyMMdd_HHmmss"
    $s = "$d $s"
    Write-Output $s
    Write-Output $s >> $logfile
}

remove-item $logfile -Force -ea SilentlyContinue -Confirm:$false


$securePassword = ConvertTo-SecureString -String $pwd1 -Force

#$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "calendarAdmin@simontbraun.eu", $pwd1
$cred = New-Object -TypeName System.Management.Automation.PSCredential ("calendarAdmin@simontbraun.eu", $securePassword)
 

# Connect to Exchange Online
Connect-ExchangeOnline -Credential $cred > $logfile

if ($?) {
    writelog "Connected"
    
    writelog "change calendar permissions"
    
    foreach ($mailbox in Get-Mailbox) {
        $cal = (Get-MailboxFolderStatistics -Identity $mailbox.UserPrincipalName | Where-Object { $_.FolderType -like "Calendar" }).FolderPath
        if ($cal) {
            $cal = $cal -replace ('/', '\')
            $calendar = $mailbox.UserPrincipalName + ":" + $cal
            writelog "$calendar Current permissions:"

            Get-MailboxFolderPermission -Identity $calendar >> $logfile
            writelog "setting permission for Default"
            $r1 = Add-MailboxFolderPermission -Identity $calendar -User "Default" -AccessRights $right -ea SilentlyContinue
            $r2 = Set-MailboxFolderPermission -Identity $calendar -User "Default" -AccessRights $right -ea SilentlyContinue
            $r3 = Get-MailboxFolderPermission -User "default" -Identity $calendar | Select-Object -ExpandProperty AccessRights
            writelog "$($calendar): Default=$($r3)"
        }
    }
} else {
    writelog "Connection error"
}

writelog "End"
