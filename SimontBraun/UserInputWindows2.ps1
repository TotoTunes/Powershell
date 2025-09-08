Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "User Information"
$form.Size = New-Object System.Drawing.Size(500, 250)  # Wider form
$form.StartPosition = "CenterScreen"

# Create labels
$labelFirstName = New-Object System.Windows.Forms.Label
$labelFirstName.Location = New-Object System.Drawing.Point(20, 20)
$labelFirstName.Size = New-Object System.Drawing.Size(80, 20)
$labelFirstName.Text = "First Name:"
$form.Controls.Add($labelFirstName)

$labelLastName = New-Object System.Windows.Forms.Label
$labelLastName.Location = New-Object System.Drawing.Point(20, 60)
$labelLastName.Size = New-Object System.Drawing.Size(80, 20)
$labelLastName.Text = "Last Name:"
$form.Controls.Add($labelLastName)

$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Location = New-Object System.Drawing.Point(20, 100)
$labelUsername.Size = New-Object System.Drawing.Size(80, 20)
$labelUsername.Text = "Username:"
$form.Controls.Add($labelUsername)

# Create textboxes
$textBoxFirstName = New-Object System.Windows.Forms.TextBox
$textBoxFirstName.Location = New-Object System.Drawing.Point(120, 20)
$textBoxFirstName.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBoxFirstName)

$textBoxLastName = New-Object System.Windows.Forms.TextBox
$textBoxLastName.Location = New-Object System.Drawing.Point(120, 60)
$textBoxLastName.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBoxLastName)

$textBoxUsername = New-Object System.Windows.Forms.TextBox
$textBoxUsername.Location = New-Object System.Drawing.Point(120, 100)
$textBoxUsername.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBoxUsername)

# Create the "Check Username" button
$buttonCheckUsername = New-Object System.Windows.Forms.Button
$buttonCheckUsername.Location = New-Object System.Drawing.Point(330, 100)  # Adjusted position
$buttonCheckUsername.Size = New-Object System.Drawing.Size(150, 25)  # 150px wide
$buttonCheckUsername.Text = "Check Username"
$buttonCheckUsername.Add_Click({
    $username = $textBoxUsername.Text
    if ($username) {
        [System.Windows.Forms.MessageBox]::Show("Checking username: $username", "Info")
        # Add your username validation logic here
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a username.", "Error")
    }
})
$form.Controls.Add($buttonCheckUsername)

# Show the form
$form.ShowDialog()
