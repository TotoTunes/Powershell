<#
	.SYNOPSIS
	The short description of the function.
	
	.DESCRIPTION
	The long description of the function.

    .PARAMETER name
    The name of the computer we are examining

    .PARAMETER type
    The name of the computer we are examining

	.EXAMPLE
	InputSanitation_Text -name "name" -type "Laptop"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)][string]$name,
    [Parameter(Mandatory = $true)][string]$type
)

switch ($type) {
    "Laptop" { 
        if ($name.Substring(0) -eq "L") {
            Write-Host "New laptop will be created"
        }
        else {
            throw
        }
     }
     "Workstation" {
        if ($name.Substring(0) -eq "W") {
            Write-Host "New workstation will be created"
        }
        else {
            throw
        }
     }
     "Server" {
        if ($name.Substring(0) -eq "S") {
            Write-Host "New server will be created"
        }
        else {
            throw
        }
     }
}