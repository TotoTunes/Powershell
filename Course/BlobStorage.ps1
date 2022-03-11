<#
Scripts om files te uploaden naar azure

dingen die we nodig hebben: 
- Resource group 
- storage account
- container
- blob

#>

$azureLocation = "Germany West"
$resourceGroupName = "PowerShellCourse"
$storageContainterName = " "

New-AzResourcegroup -Location $azureLocation -Name $resourceGroupName

New-AzStoreAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -SkuName Standard_LRS -Location $azureLocation

New-AzStorageContainer -Name $storageContainterName -Permission Off -Context $storageAccountName.Context

set-AzStorageBlobContent