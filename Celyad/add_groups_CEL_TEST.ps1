
$AZ_New_User = Get-AzureADuser -SearchString "temp01"


$AZ_Example_user = Get-AzureADUser -SearchString "igennart" 
$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list){
$group.Mail
$typ= Get-MsolGroup -SearchString $group.Mail
$typ
try {
    Write-Host "adding Azure AD group" -ForegroundColor Yellow
    Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -verbose
}
catch {
    Write-Host "adding DL" -ForegroundColor Yellow
    Add-DistributionGroupMember -Identity $group.DisplayName -Member $AZ_New_User.UserPrincipalName
}
finally {
    Write-Host "adding Teams Group" -ForegroundColor Yellow
    Add-UnifiedGroupLinks -Identity $group.Mail -LinkType "Members" -Links $AZ_New_User.Mail
}


Pause
}

#Get-AzureADUserMembership -ObjectId $user1ObjId |foreach { Add-AzureADGroupMember -ObjectId $_.ObjectId -RefObjectId $User2ObjId }