
$AZ_New_User = Get-AzureADuser -SearchString "temp01"


$AZ_Example_user = Get-AzureADUser -SearchString "igennart" 
$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list) {
    $group.Mail
    $typ = Get-MsolGroup -ObjectId $group.ObjectId
    Write-host $typ.MailNickName
    if ($typ.DirSyncEnabled -eq $false) {
        try {
            Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -verbose
            Write-Host "adding Azure AD group" -ForegroundColor Yellow
        }
        catch {
            Add-DistributionGroupMember -Identity $group.Mail -Member $AZ_New_User.UserPrincipalName
            Write-Host "adding DL" -ForegroundColor Yellow
        }
    }

}

#Get-AzureADUserMembership -ObjectId $user1ObjId |foreach { Add-AzureADGroupMember -ObjectId $_.ObjectId -RefObjectId $User2ObjId }