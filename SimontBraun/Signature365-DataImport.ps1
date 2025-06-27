# Install the ImportExcel module if not already installed
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

# Import the necessary modules
Import-Module ImportExcel
Import-Module ActiveDirectory

# Define the path to the Excel file
$excelFilePath = "\\braunbigwood.local\dfs\Public\IT\datasib.xlsx"

# Read the Excel file
$data = Import-Excel -Path $excelFilePath

# Loop through each row in the Excel file
foreach ($row in $data) {
    $email = $row.'Email Address'
    $lawyerTitle = $row.'Lawyer Title'
    $title = $row.Title
    $officePhone = $row.'Office Phone'
    $assistantPhone = $row.'Assistant Phone'
    $telInSignature = $row.'Tel in signature'
    $mobilePhone = $row.'Mobile Phone'
    $mobileSharing = $row.'Mobile sharing'
    $linkedIn = $row.LinkedIn
    $company = $row.Company

    Write-Host "Processing user: $email"

    # Find the user in Active Directory by email
    $user = Get-ADUser -Filter {EmailAddress -eq $email} -Properties *

    if ($user) {
        Write-Host "Found user: $email"
        try {
            # Update the attributes if they are not null
            if ($lawyerTitle) { Set-ADUser -Identity $user -Replace @{extensionAttribute10= $lawyerTitle} }
            if ($title) { Set-ADUser -Identity $user -Replace @{extensionAttribute11= $title} }
            if ($title) { Set-ADUser -Identity $user -Description $title }
            if ($officePhone) { Set-ADUser -Identity $user -Replace @{telephoneNumber= $officePhone} }
            if ($assistantPhone) { Set-ADUser -Identity $user -Replace @{telephoneAssistant= $assistantPhone} }
            if ($telInSignature) { Set-ADUser -Identity $user -Replace @{extensionAttribute12= $telInSignature} }
            if ($mobilePhone) { Set-ADUser -Identity $user -Replace @{mobile= $mobilePhone} }
            if ($mobileSharing) { Set-ADUser -Identity $user -Replace @{extensionAttribute13= $mobileSharing} }
            if ($linkedIn) { Set-ADUser -Identity $user -Replace @{extensionAttribute14= $linkedIn} }
            if ($company) { Set-ADUser -Identity $user -Replace @{extensionAttribute15= $company} }
            Write-Host "Updated attributes for user: $email"
        } catch {
            Write-Host "Failed to update attributes for user: $email. Error: $_"
        }
    } else {
        Write-Host "User not found: $email"
    }
}