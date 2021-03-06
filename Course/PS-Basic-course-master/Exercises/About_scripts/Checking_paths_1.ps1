#requires -runasadministrator
#requires -module Hyper-V

[cmdletbinding()]
param(
[Parameter(Mandatory=$true)][String]$iso,
[Parameter(Mandatory=$true)][String]$name,
[Parameter(Mandatory=$true)][String]$switchname,
[Switch]$startVM=$true,
[String]$location = "C:\Virtual Machines"
)

if( (Test-Path $location))
{
write-Verbose "Location exists!"
}
else
{
throw "Please select an existing location!"
}

if(-not (Test-Path $iso))
{
throw "Please select an existing ISO!"
}

$vhdxname = Join-Path ( Join-Path ( Join-Path $location $name ) "HDs") "$name.vhdx"

New-VM -Name $name `
-MemoryStartupBytes 1GB `
-Path $location `
-Generation 2 `
-SwitchName $switchname `
-NewVHDPath $vhdxname `
-NewVHDSizeBytes 40GB `
-BootDevice CD

Get-VM -Name $name | Get-VMDvdDrive | Set-VMDvdDrive -Path $iso.FullName

Get-VM -Name $name | Set-VMMemory -DynamicMemoryEnabled $true -MaximumBytes 2GB -MinimumBytes 256MB

if($startVM)
{
Write-Verbose "Starting the VM"
Get-VM -Name $name | Start-VM
}
