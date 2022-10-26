$import = Import-Csv -Path "C:\temp\202210-Employees-new-org-chart.csv" -Delimiter ";" -Header Name,Title,Department,Manager,Company

foreach ($l in $import) {

$user = $l
$names = $user.Name.Split()
$login = $names[0].Substring(0,1) + $names[1]
Write-Host $login
$AD= Get-ADUser -Identity $login

if ($l.Manager.Length -eq 0)
{
   Set-ADUser -Identity $login -Clear Manager
}
else {
$man = $user.Manager.Split()
$manager = $man[0].Substring(0,1) + $man[1]
  Set-ADUser -Identity $login -Manager $manager
}

if ($l.Department.Length -eq 0) 
{
     Set-ADUser -Identity $login -Clear Department
}
else
{
    Set-ADUser -Identity $login -Department $user.Department
}

if ($l.Title.Length -eq 0)
{
    Set-ADUser -Identity $login -Clear Title
}
else
{
    Set-ADUser -Identity $login -Title $user.Title 
}

Set-ADUser -Identity $login -Company $user.Company
pause
}
