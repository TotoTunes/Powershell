#Teams webhook url
$uri = "https://itanywherenet.webhook.office.com/webhookb2/51a78a53-9d4f-4170-ac50-78c16debb000@dfa9281b-2c3f-4e5a-9d7f-68527cdf9008/IncomingWebhook/3183b8c5f4f9472e9e9802a08466c310/27271b1d-5ef1-4dc1-bf1b-68e8c8480c96"

#Image on the left hand side, here I have a regular user picture
$ItemImage = 'https://img.icons8.com/color/1600/circled-user-male-skin-type-1-2.png'

#Get the date.time object for XX days ago
$90Days = (get-date).adddays(-90)

$InactiveUsersTable = New-Object 'System.Collections.Generic.List[System.Object]'
$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'

#If lastlogondate is not empty, and less than or equal to XX days and enabled
Get-ADUser -properties * -filter { (lastlogondate -like "*" -and lastlogondate -le $90days) -AND (enabled -eq $True) } | ForEach-Object{
	Write-Host "Working on $($_.Name)" -ForegroundColor White
	
	$LastLogonDate = $_.LastLogonDate
	$Today = (GET-DATE)
	
	
	
	$DaysSince = ((NEW-TIMESPAN �Start $LastLogonDate �End $Today).Days).ToString() + " Days ago"
	
	$obj = [PSCustomObject]@{
		
		'Name' = $_.name
		'LastLogon' = $DaysSince
		'LastLogonDate' = (($_.LastLogonDate).ToShortDateString())
		'EmailAddress' = $_.emailaddress
		'LockedOut' = $_.LockedOut
		'UPN'  = $_.UserPrincipalName
		'Enabled' = $_.Enabled
		'PasswordNeverExpires' = $_.PasswordNeverExpires
		'SamAccountName' = $_.SamAccountName
	}
	
	$InactiveUsersTable.Add($obj)
}
Write-Host "Inactive users $($($InactiveUsersTable).count)"



$InactiveUsersTable | ForEach-Object {
	
	$Section = @{
		activityTitle = "$($_.Name)"
		activitySubtitle = "$($_.EmailAddress)"
		activityText  = "$($_.Name)'s last logon was $($_.LastLogon)"
		activityImage = $ItemImage
		facts		  = @(
			@{
				name  = 'Last Logon Date:'
				value = $_.LastLogonDate
			},
			@{
				name  = 'Enabled:'
				value = $_.Enabled
			},
			@{
				name  = 'Locked Out:'
				value = $_.LockedOut
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
	title = "Inactive Users - Notification"
	text  = "There are $($ArrayTable.Count) users who have not logged in since $($90Days.ToShortDateString()) or earlier"
	sections = $ArrayTable
	
}
Write-Host "Sending inactive account POST" -ForegroundColor Green
Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'