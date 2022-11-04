$path = Read-Host "enter path to CSV file"
$DL = Read-Host "Enter the name of the DL"
$list = Import-Csv -Path $path -Header Identity,Alias,ExternalDirectoryObjectId,EmailAddresses,ExternalEmailAddress,Name,PrimarySmtpAddress,ExchangeObjectID,Id,Guid -Delimiter ";"
   
foreach ($user in $list) 
{

    Add-DistributionGroupMember -Identity $DL -Member $user.Identity 
}