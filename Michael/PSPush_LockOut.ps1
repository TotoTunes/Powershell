<#	
	.NOTES
	===========================================================================
	 Created on:   	12/13/2018 3:57 PM
	 Created by:   	Bradley Wyatt
	 Filename:     	PSPush_LockedOutUsers.ps1
	===========================================================================
	.DESCRIPTION
		Sends a Teams notification via webhook of a recently locked out user. Set up a scheduled task to trigger on event ID 4740. 
#>

#Teams webhook url
$uri = "https://itanywherenet.webhook.office.com/webhookb2/51a78a53-9d4f-4170-ac50-78c16debb000@dfa9281b-2c3f-4e5a-9d7f-68527cdf9008/IncomingWebhook/84c7749a27c9485ca008dfc244be076f/27271b1d-5ef1-4dc1-bf1b-68e8c8480c96"

#Image on the left hand side, here I have a regular user picture
$ItemImage = 'https://img.icons8.com/color/1600/circled-user-male-skin-type-1-2.png'

$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'

$Event = Get-EventLog -LogName Security -InstanceId 4740 | Select-object -First 1
[string]$Item = $Event.Message
$Item.SubString($Item.IndexOf("Caller Computer Name"))
$sMachineName = $Item.SubString($Item.IndexOf("Caller Computer Name"))
$sMachineName = $sMachineName.TrimStart("Caller Computer Name :")
$sMachineName = $sMachineName.TrimEnd("}")
$sMachineName = $sMachineName.Trim()
$sMachineName = $sMachineName.TrimStart("\\")

$RecentLockedOutUser = Search-ADAccount -server ODIN01.hbe.local -LockedOut | Get-ADUser -Properties badpwdcount, lockoutTime, lockedout, emailaddress | Select-Object badpwdcount, lockedout, Name, EmailAddress, SamAccountName, @{ Name = "LockoutTime"; Expression = { ([datetime]::FromFileTime($_.lockoutTime).ToLocalTime()) } } | Sort-Object LockoutTime -Descending | Select-Object -first 1

$RecentLockedOutUser | ForEach-Object {
	
	$Section = @{
		activityTitle = "$($_.Name)"
		activitySubtitle = "$($_.EmailAddress)"
		activityText  = "$($_.Name)'s account was locked out at $(($_.LockoutTime).ToString("hh:mm:ss tt")) and may require additional assistance"
		activityImage = $ItemImage
		facts		  = @(
			@{
				name  = 'Lockout Source:'
				value = $sMachineName
			},
			@{
				name  = 'Lock-Out Timestamp:'
				value = $_.LockoutTime.ToString()
			},
			@{
				name  = 'Locked Out:'
				value = $_.lockedout
			},
			@{
				name  = 'Bad Password Count:'
				value = $_.badpwdcount
			},
			@{
				name  = 'SamAccountName:'
				value = $_.SamAccountName
			}
		)
	}
	$ArrayTable.add($section)
}

$body = ConvertTo-Json -Depth 8 @{
	title = "Locked Out User - Notification"
	text  = "$($RecentLockedOutUser.Name)'s account got locked out at $(($RecentLockedOutUser.LockoutTime).ToString("hh:mm:ss tt"))"
	sections = $ArrayTable
	
}
Write-Host "Sending lockedout account POST" -ForegroundColor Green
Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
