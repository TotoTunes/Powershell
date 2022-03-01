#generate random strings 
Set-Location -Path "C:\temp\"
mkdir .\TEST
mkdir .\TEST2
for ($i = 0; $i -lt 5; $i++) {

    $file = (65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_}
    New-Item -Path C:\temp\TEST -Name "$file.txt" -ItemType File
    $files = Get-ChildItem -Path C:\temp\TEST -File
    foreach($f in $files) {
        Copy-Item -Path "C:\temp\TEST\$f" -Destination C:\temp\TEST2
    }
    
}

