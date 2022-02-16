Azzu
$AZ_New_User = Get-AzureADuser -SearchString "temp01"


$AZ_Example_user = Get-AzureADUser -SearchString "igennart" 
$group_list = Get-AzureADUserMembership -ObjectId $AZ_Example_user.ObjectId

foreach ($group in $group_list){
$group.DisplayName
$typ= Get-MsolGroup -SearchString $group.DisplayName
$typ
try {
    Add-AzureADGroupMember -ObjectID $group.objectId -RefObjectID $AZ_New_User.ObjectId -ErrorAction Stop -verbose
}
catch {
    Add-DistributionGroupMember -Identity $group.DisplayName -Member $AZ_New_User.UserPrincipalName
}

Pause
}