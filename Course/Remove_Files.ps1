[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $path
)
$path = "C:\Users\thomas\Downloads"
$folders = Get-ChildItem -Path $path -File -Recurse -Force | Select-Object FullName,LastAccessTime

foreach ($file in $folders) {

    if ($file.LastAccessTime -lt ((Get-Date).AddDays(-10))) {
        $file | Format-Table
        Remove-Item -Path $file.FullName -WhatIf
    }
}


Get-ChildItem -Path $path -Filter -Recurse -Force | where {$_.LastAccessTime -lt (Get-Date).AddDays(-10)} | Remove-Item -WhatIf