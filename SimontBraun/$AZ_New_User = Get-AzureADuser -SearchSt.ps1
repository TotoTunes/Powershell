$AZ_New_User = Get-AzureADuser -SearchString $username
$AZ_Example_user = Get-AzureADUser -SearchString $example

$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list) {
    $typ = Get-MsolGroup -ObjectId $group.ObjectId
    Write-host $typ.DisplayName "is AD synced" -ForegroundColor Blue -BackgroundColor White
    
    try {
            
      Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -verbose
       Write-Host "adding Azure AD group" -ForegroundColor Yellow
       Write-Host "user has been added to $typ.DisplayName"  -ForegroundColor Yellow
    }
    catch {
      Add-DistributionGroupMember -Identity $group.Mail -Member $AZ_New_User.UserPrincipalName
      Write-Host "adding DL" -ForegroundColor Yellow
      Write-Host "user has been added to $typ.DisplayName"  -ForegroundColor Yellow
    }
}