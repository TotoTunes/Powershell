#generate random strings 
Set-Location -Path "C:\temp\TEST"
$file = (65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_}

