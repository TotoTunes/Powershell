Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "User Input Form"
$form.Size = New-Object System.Drawing.Size(600, 300) # Width, Height
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle # Prevent resizing
$form.MaximizeBox = $false # Disable maximize button
$form.MinimizeBox = $false # Disable minimize button

# Create a label for the first input field
$label_firstname = New-Object System.Windows.Forms.Label
$label_firstname.Text = "Enter the First name:"
$label_firstname.Location = New-Object System.Drawing.Point(30, 30) # X, Y
$label_firstname.AutoSize = $true # Adjust size to fit text

# Create a text box for the first input field
$text_firstname = New-Object System.Windows.Forms.TextBox
$text_firstname.Location = New-Object System.Drawing.Point(150, 30)
$text_firstname.Size = New-Object System.Drawing.Size(200, 20)
$text_firstname.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right

# Create a label for the second input field
$label_lastname = New-Object System.Windows.Forms.Label
$label_lastname.Text = "Enter the last name:"
$label_lastname.Location = New-Object System.Drawing.Point(30, 60)
$label_lastname.AutoSize = $true

# Create a text box for the second input field
$text_lastname = New-Object System.Windows.Forms.TextBox
$text_lastname.Location = New-Object System.Drawing.Point(150, 60)
$text_lastname.Size = New-Object System.Drawing.Size(200, 20)
$text_lastname.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right

# Create a label for the third input field
$label_username = New-Object System.Windows.Forms.Label
$label_username.Text = "Enter the username:"
$label_username.Location = New-Object System.Drawing.Point(30, 90) # X, Y
$label_username.AutoSize = $true # Adjust size to fit text

# Create a text box for the third input field
$text_username = New-Object System.Windows.Forms.TextBox
$text_username.Location = New-Object System.Drawing.Point(150, 90)
$text_username.Size = New-Object System.Drawing.Size(200, 20)
$text_username.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right

# Create a label for the fourth input field
$label_ExampleUser = New-Object System.Windows.Forms.Label
$label_ExampleUser.Text = "Enter the example user:"
$label_ExampleUser.Location = New-Object System.Drawing.Point(30, 120) # X, Y
$label_ExampleUser.AutoSize = $true # Adjust size to fit text

# Create a text box for the fourh input field
$text_ExampleUser = New-Object System.Windows.Forms.TextBox
$text_ExampleUser.Location = New-Object System.Drawing.Point(150, 120)
$text_ExampleUser.Size = New-Object System.Drawing.Size(200, 20)
$text_ExampleUser.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right

# Create a check username button
$CheckButton = New-Object System.Windows.Forms.Button
$CheckButton.Text = "Check username"
$CheckButton.Location = New-Object System.Drawing.Point(370, 90)
$CheckButton.Size = New-Object System.Drawing.Size(100, 20)

# define action for Check Username button
$CheckButton.Add_Click({
$userlogin = $text_username.Text
CheckUsername($userlogin)
} )

# Create a submit button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Submit"
$submitButton.Location = New-Object System.Drawing.Point(150, 200)
$submitButton.Size = New-Object System.Drawing.Size(100, 30)

# Add controls to the form
$form.Controls.Add($label_firstname)
$form.Controls.Add($text_firstname)
$form.Controls.Add($label_lastname)
$form.Controls.Add($text_lastname)
$form.Controls.Add($submitButton)
$form.Controls.Add($label_username)
$form.Controls.Add($text_username)
$form.Controls.Add($label_ExampleUser)
$form.Controls.Add($test_ExampleUser)
$form.Controls.Add($CheckButton)

# Set the form's accept button (allows pressing Enter to submit)
$form.AcceptButton = $submitButton

# Show the form
$form.ShowDialog()

# After the form is closed, you can access the values if needed (e.g., if you closed the form on submit)
# For this example, the output is displayed within the form, so these lines are mostly for demonstration
# $finalName = $textBox1.Text
# $finalAge = $text_lastname.Text
# Write-Host "Form closed. Final Name: $finalName, Final Age: $finalAge"