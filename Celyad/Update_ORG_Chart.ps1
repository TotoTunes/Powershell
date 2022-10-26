$import = Import-Csv -Path "C:\temp\202210-Employees-new-org-chart.csv" -Delimiter ";" -Header Name,Title,Department,Manager,Company

$user = $import[1]
