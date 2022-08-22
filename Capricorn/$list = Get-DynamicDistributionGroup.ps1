$list = Get-DynamicDistributionGroup
foreach ($i in $list) {

    $file = $i.Name
    Get-DynamicDistributionGroupMember -Identity $i.Name | export-csv -path "C:\temp\$file.csv" -notypeinformation
}