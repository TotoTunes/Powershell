# Install the ImportExcel module if not already installed

if (-not (Get-Module -ListAvailable -Name ImportExcel)) {

    Install-Module -Name ImportExcel -Scope CurrentUser -Force

}
 
# Import the necessary modules

Import-Module ImportExcel

Import-Module ActiveDirectory
 
# Define the path to the Excel file

$excelFilePath = "\\braunbigwood.local\dfs\Public\IT\datasib_test.xlsx"
 
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

    $department = $row.Department
    
    $extension = $row.'IP Phone'

    $desk = $row.Office
 
    Write-Host "Processing user: $email"
 
    # Find the user in Active Directory by email

    $user = Get-ADUser -Filter {EmailAddress -eq $email} -Properties *
 
    if ($user) {

        Write-Host "Found user: $email"

        try {
        $user = Get-ADUser -Filter {EmailAddress -eq $email} -Properties * -ErrorAction Stop
        Write-Log "Found user: $email"

        # Update the attributes if they are not null
        try {
            if ($lawyerTitle) {
                Set-ADUser -Identity $user -Replace @{extensionAttribute10 = $lawyerTitle} -ErrorAction Stop
                Write-Log "Updated extensionAttribute10 for $email"
            }
            if ($title) {
                Set-ADUser -Identity $user -Replace @{extensionAttribute11 = $title} -ErrorAction Stop
                Set-ADUser -Identity $user -Description $title -ErrorAction Stop
                Set-ADUser -Identity $user -Title $title -ErrorAction Stop
                Write-Log "Updated extensionAttribute11, Description, and Title for $email"
            }
            if ($officePhone) {
                Set-ADUser -Identity $user -Replace @{telephoneNumber = $officePhone} -ErrorAction Stop
                Write-Log "Updated telephoneNumber for $email"
            }
            if ($extension) {
                Set-ADUser -Identity $user -Replace @{ipPhone = $extension} -ErrorAction Stop
                Write-Log "Updated ipPhone for $email"
            }
            if ($assistantPhone) {
                Set-ADUser -Identity $user -Replace @{telephoneAssistant = $assistantPhone} -ErrorAction Stop
                Write-Log "Updated telephoneAssistant for $email"
            }
            if ($telInSignature) {
                Set-ADUser -Identity $user -Replace @{extensionAttribute12 = $telInSignature} -ErrorAction Stop
                Write-Log "Updated extensionAttribute12 for $email"
            }
            if ($mobilePhone) {
                Set-ADUser -Identity $user -Replace @{mobile = $mobilePhone} -ErrorAction Stop
                Write-Log "Updated mobile for $email"
            }
            if ($mobileSharing) {
                Set-ADUser -Identity $user -Replace @{extensionAttribute13 = $mobileSharing} -ErrorAction Stop
                Write-Log "Updated extensionAttribute13 for $email"
            }
            if ($linkedIn) {
                Set-ADUser -Identity $user -Replace @{extensionAttribute14 = $linkedIn} -ErrorAction Stop
                Write-Log "Updated extensionAttribute14 for $email"
            }
            if ($company) {
                Set-ADUser -Identity $user -Replace @{extensionAttribute15 = $company} -ErrorAction Stop
                Write-Log "Updated extensionAttribute15 for $email"
            }
            if ($department) {
                Set-ADUser -Identity $user -Department $department -ErrorAction Stop
                Write-Log "Updated Department for $email"
            }
            if ($desk) {
                Set-ADUser -Identity $user -Office $desk -ErrorAction Stop
                Write-Log "Updated Office for $email"
            }
            Write-Log "All attributes updated successfully for user: $email"
        } catch {
            Write-Log "Failed to update attributes for user: $email. Error: $_" -Level "ERROR"
        }
    } catch {
        Write-Log "User not found: $email" -Level "WARNING"
    }
}
}
Write-Log "Script completed."