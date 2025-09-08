Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "User Information"
$form.Size = New-Object System.Drawing.Size(450, 600)  # Increased height
$form.StartPosition = "CenterScreen"

# Uniform width for all textboxes
$textboxWidth = 250

# Create labels
$labelFirstName = New-Object System.Windows.Forms.Label
$labelFirstName.Location = New-Object System.Drawing.Point(20, 20)
$labelFirstName.Size = New-Object System.Drawing.Size(100, 20)
$labelFirstName.Text = "First Name:"
$form.Controls.Add($labelFirstName)

$labelLastName = New-Object System.Windows.Forms.Label
$labelLastName.Location = New-Object System.Drawing.Point(20, 60)
$labelLastName.Size = New-Object System.Drawing.Size(100, 20)
$labelLastName.Text = "Last Name:"
$form.Controls.Add($labelLastName)

$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Location = New-Object System.Drawing.Point(20, 100)
$labelUsername.Size = New-Object System.Drawing.Size(100, 20)
$labelUsername.Text = "Username:"
$form.Controls.Add($labelUsername)

$labelStreet = New-Object System.Windows.Forms.Label
$labelStreet.Location = New-Object System.Drawing.Point(20, 180)
$labelStreet.Size = New-Object System.Drawing.Size(100, 20)
$labelStreet.Text = "Street:"
$form.Controls.Add($labelStreet)

$labelPOBox = New-Object System.Windows.Forms.Label
$labelPOBox.Location = New-Object System.Drawing.Point(20, 220)
$labelPOBox.Size = New-Object System.Drawing.Size(100, 20)
$labelPOBox.Text = "PO Box:"
$form.Controls.Add($labelPOBox)

$labelCity = New-Object System.Windows.Forms.Label
$labelCity.Location = New-Object System.Drawing.Point(20, 260)
$labelCity.Size = New-Object System.Drawing.Size(100, 20)
$labelCity.Text = "City:"
$form.Controls.Add($labelCity)

$labelState = New-Object System.Windows.Forms.Label
$labelState.Location = New-Object System.Drawing.Point(20, 300)
$labelState.Size = New-Object System.Drawing.Size(100, 20)
$labelState.Text = "State:"
$form.Controls.Add($labelState)

$labelZipCode = New-Object System.Windows.Forms.Label
$labelZipCode.Location = New-Object System.Drawing.Point(20, 340)
$labelZipCode.Size = New-Object System.Drawing.Size(100, 20)
$labelZipCode.Text = "Zip Code:"
$form.Controls.Add($labelZipCode)

$labelCountry = New-Object System.Windows.Forms.Label
$labelCountry.Location = New-Object System.Drawing.Point(20, 380)
$labelCountry.Size = New-Object System.Drawing.Size(100, 20)
$labelCountry.Text = "Country:"
$form.Controls.Add($labelCountry)

$labelWebsite = New-Object System.Windows.Forms.Label
$labelWebsite.Location = New-Object System.Drawing.Point(20, 420)
$labelWebsite.Size = New-Object System.Drawing.Size(100, 20)
$labelWebsite.Text = "Website:"
$form.Controls.Add($labelWebsite)

$labelFax = New-Object System.Windows.Forms.Label
$labelFax.Location = New-Object System.Drawing.Point(20, 460)
$labelFax.Size = New-Object System.Drawing.Size(100, 20)
$labelFax.Text = "Fax:"
$form.Controls.Add($labelFax)

# Create textboxes with uniform width and prefilled values
$textBoxFirstName = New-Object System.Windows.Forms.TextBox
$textBoxFirstName.Location = New-Object System.Drawing.Point(130, 20)
$textBoxFirstName.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$form.Controls.Add($textBoxFirstName)

$textBoxLastName = New-Object System.Windows.Forms.TextBox
$textBoxLastName.Location = New-Object System.Drawing.Point(130, 60)
$textBoxLastName.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$form.Controls.Add($textBoxLastName)

$textBoxUsername = New-Object System.Windows.Forms.TextBox
$textBoxUsername.Location = New-Object System.Drawing.Point(130, 100)
$textBoxUsername.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$form.Controls.Add($textBoxUsername)

$textBoxStreet = New-Object System.Windows.Forms.TextBox
$textBoxStreet.Location = New-Object System.Drawing.Point(130, 180)
$textBoxStreet.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxStreet.Text = "Avenue Louise 250"
$form.Controls.Add($textBoxStreet)

$textBoxPOBox = New-Object System.Windows.Forms.TextBox
$textBoxPOBox.Location = New-Object System.Drawing.Point(130, 220)
$textBoxPOBox.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxPOBox.Text = "10"
$form.Controls.Add($textBoxPOBox)

$textBoxCity = New-Object System.Windows.Forms.TextBox
$textBoxCity.Location = New-Object System.Drawing.Point(130, 260)
$textBoxCity.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxCity.Text = "Brussels"
$form.Controls.Add($textBoxCity)

$textBoxState = New-Object System.Windows.Forms.TextBox
$textBoxState.Location = New-Object System.Drawing.Point(130, 300)
$textBoxState.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxState.Text = "Bruxelles-Capitale"
$form.Controls.Add($textBoxState)

$textBoxZipCode = New-Object System.Windows.Forms.TextBox
$textBoxZipCode.Location = New-Object System.Drawing.Point(130, 340)
$textBoxZipCode.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxZipCode.Text = "1050"
$form.Controls.Add($textBoxZipCode)

$textBoxCountry = New-Object System.Windows.Forms.TextBox
$textBoxCountry.Location = New-Object System.Drawing.Point(130, 380)
$textBoxCountry.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxCountry.Text = "BE"
$form.Controls.Add($textBoxCountry)

$textBoxWebsite = New-Object System.Windows.Forms.TextBox
$textBoxWebsite.Location = New-Object System.Drawing.Point(130, 420)
$textBoxWebsite.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxWebsite.Text = "www.simontbraun.eu"
$form.Controls.Add($textBoxWebsite)

$textBoxFax = New-Object System.Windows.Forms.TextBox
$textBoxFax.Location = New-Object System.Drawing.Point(130, 460)
$textBoxFax.Size = New-Object System.Drawing.Size($textboxWidth, 20)
$textBoxFax.Text = "+32 2 522 17 90"
$form.Controls.Add($textBoxFax)

# Create the "Check Username" button below the username field
$buttonCheckUsername = New-Object System.Windows.Forms.Button
$buttonCheckUsername.Location = New-Object System.Drawing.Point(130, 130)
$buttonCheckUsername.Size = New-Object System.Drawing.Size($textboxWidth, 25)
$buttonCheckUsername.Text = "Check Username"
$buttonCheckUsername.BackColor = [System.Drawing.Color]::LightBlue
$buttonCheckUsername.Add_Click({
    $username = $textBoxUsername.Text
    if ($username) {
        [System.Windows.Forms.MessageBox]::Show("Checking username: $username", "Info")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a username.", "Error")
    }
})
$form.Controls.Add($buttonCheckUsername)

# Create "Create User" and "Cancel" buttons at the bottom, centered
$buttonCreateUser = New-Object System.Windows.Forms.Button
$buttonCreateUser.Location = New-Object System.Drawing.Point(100, 520)
$buttonCreateUser.Size = New-Object System.Drawing.Size(120, 30)
$buttonCreateUser.Text = "Create User"
$buttonCreateUser.BackColor = [System.Drawing.Color]::Green
$buttonCreateUser.ForeColor = [System.Drawing.Color]::White
$buttonCreateUser.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("User created successfully!", "Success")
})
$form.Controls.Add($buttonCreateUser)

$buttonCancel = New-Object System.Windows.Forms.Button
$buttonCancel.Location = New-Object System.Drawing.Point(230, 520)
$buttonCancel.Size = New-Object System.Drawing.Size(120, 30)
$buttonCancel.Text = "Cancel"
$buttonCancel.BackColor = [System.Drawing.Color]::Red
$buttonCancel.ForeColor = [System.Drawing.Color]::White
$buttonCancel.Add_Click({
    $form.Close()
})
$form.Controls.Add($buttonCancel)

# Show the form
$form.ShowDialog()
