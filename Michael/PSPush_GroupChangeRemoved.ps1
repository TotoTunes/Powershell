  
<#	
	.NOTES
	===========================================================================
	 Created on:   	12/13/2018 3:57 PM
	 Created by:   	Bradley Wyatt
	 Filename:     	PSPush_GroupChange.ps1
	===========================================================================
	.DESCRIPTION
		Sends a Teams notification via webhook when a monitored group membership changes. Set up a scheduled task to trigger on event ID 4728. 
#>

$Groups2Monitor = @(
	"Domain Admins"
	"Enterprise Admins"
	"Accounting"
)

#Teams webhook url
$uri = "https://outlook.office.com/webhook/51a78a53-9d4f-4170-ac50-78c16debb000@dfa9281b-2c3f-4e5a-9d7f-68527cdf9008/IncomingWebhook/f34fc948aa7d4a2b85c1578468d69b85/27271b1d-5ef1-4dc1-bf1b-68e8c8480c96"

#Image on the left hand side, here I have a regular user picture
$ItemImage = 'https://www.merrimack.edu/live/image/gid/162/width/808/height/808/19902_user-plus-circle_2.rev.1548946186.png'

$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'

$event = Get-EventLog -LogName Security -InstanceId 4729 | Select-object -First 1
$GroupSID = $Event | Select-Object -Expand Message | Select-String '(?<=group:\s+security id:\s+)\S+' | Select-Object -Expand Matches | Select-Object -Expand Value
$UserAdded = $Event | Select-Object -Expand Message | Select-String '(?<=member:\s+security id:\s+)\S+' | Select-Object -Expand Matches | Select-Object -Expand Value


If (($Groups2Monitor.Contains((Get-ADGroup -Identity $GroupSID).Name)) -eq $True)
{
	$AddedUser = Get-ADUser -Identity $UserAdded -Properties *
	$GroupChange = Get-ADGroup -Identity $GroupSID -Properties *
	$Section = @{
		activityTitle = "$($GroupChange.Name)"
		activitySubtitle = "$($GroupChange.Description)"
		activityText  = "The Account, '$($AddedUser.Name)' was removed from the group, '$($GroupChange.Name)' "
		activityImage = $ItemImage
		facts		  = @(
			@{
				name  = 'Last Modified'
				value = $GroupChange.whenChanged
			},
			@{
				name  = 'Old User:'
				value = $AddedUser.UserPrincipalName
			},
			@{
				name  = 'Group Type:'
				value = [string]($GroupChange.GroupCategory)
			},
			@{
				name  = 'Group Scope:'
				value = [string]($GroupChange.GroupScope)
			}
		)
	}
	$ArrayTable.add($section)
}


$body = ConvertTo-Json -Depth 8 @{
	title = "Monitored Group Change - Notification"
	text  = "An old user was removed from $($GroupChange.Name)"
	sections = $ArrayTable
	
}
Write-Host "Sending notification POST" -ForegroundColor Green
Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'