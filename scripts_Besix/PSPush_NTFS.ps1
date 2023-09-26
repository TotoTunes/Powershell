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
$uri = "https://outlook.office.com/webhook/51a78a53-9d4f-4170-ac50-78c16debb000@dfa9281b-2c3f-4e5a-9d7f-68527cdf9008/IncomingWebhook/3c0056f8da034a16a9f5a7d92bf23cfc/27271b1d-5ef1-4dc1-bf1b-68e8c8480c96"

#Image on the left hand side, here I have a regular user picture
$ItemImage = 'http://pluspng.com/img-png/attention-sign-png--2400.png'

$ArrayTable = New-Object 'System.Collections.Generic.List[System.Object]'

	$Section = @{
		activityTitle = "File system structure"
		activitySubtitle = "Event 130"
		activityText  = "An event regarding the file system structure has been logged"
		activityImage = $ItemImage
	}
	$ArrayTable.add($section)

$body = ConvertTo-Json -Depth 8 @{
	title = "File system structure"
	text  = "An event regarding the file system structure has been logged"
	sections = $ArrayTable
	
}
Write-Host "Sending filesystemstructure POST" -ForegroundColor Green
Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
