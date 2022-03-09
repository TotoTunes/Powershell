Set-Location -Path "C:\Users\thomas\OneDrive - IT Anywhere\Documenten\Github\Powershell"

$folders = Get-ChildItem -Directory

foreach ($fol in $folders) {

    Measure-Object -InputObject $fol -Sum Length | Select-Object Count,Sum
}
