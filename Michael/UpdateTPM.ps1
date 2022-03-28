# Name: UpdateTPM.ps1
# Usage: UpdateTPM.ps1
# Description: 
#	Will check if the TPM is up to date, if not it will update the TPM.
#
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
# Get the target system's model. 
$TPM = get-TPM

# If the TPM revision is , and the TPM is not up to date. Update it.
if ( $TPM.ManufacturerVersion -eq "6.40" ) {
	
	# Update TPM
	Start-Process "\\hewbefs001.hbe.local\dist$\HP\TPM\TPM12_6.40.190.0\TPMConfig64.exe" -Wait
}

# If the TPM revision is , and the TPM is not up to date. Update it.
if ( $TPM.ManufacturerVersion -eq "6.41" ) {
	
	# Update TPM
	Start-Process "\\hewbefs001.hbe.local\dist$\HP\TPM\TPM12_6.41.197.0\TPMConfig64.exe" -Wait
}

# If the TPM revision is , and the TPM is not up to date. Update it.
if ( $TPM.ManufacturerVersion -eq "6.43" ) {
	
	# Update TPM
	Start-Process "\\hewbefs001.hbe.local\dist$\HP\TPM\TPM12_6.43.243.0\TPMConfig64.exe" -Wait
}