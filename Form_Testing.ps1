[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#begin to draw forms
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Computer Pinging Tool"
$Form.Size = New-Object System.Drawing.Size(300, 150)
$Form.StartPosition = "CenterScreen"

$Form.KeyPreview = $True
$Form.Add_KeyDown({ if ($_.KeyCode -eq "Enter")
        { $x = $ListBox.SelectedItem; $Form.Close() } })
$Form.Add_KeyDown({ if ($_.KeyCode -eq "Escape")
        { $Form.Close() } })

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Size(5, 5)
$label.Size = New-Object System.Drawing.Size(240, 30)
$label.Text = "Type any computer name to test if it is on the network and can respond to ping"
$Form.Controls.Add($label)

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Size(5, 40)
$textbox.Size = New-Object System.Drawing.Size(120, 20)
$textbox.Text = "Select source PC:"
$Form.Controls.Add($textbox)
 
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(140, 38)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = "OK"
$OKButton.Add_Click($ping_computer_click)
$Form.Controls.Add($OKButton)
 
$result_label = New-Object System.Windows.Forms.label
$result_label.Location = New-Object System.Drawing.Size(5, 65)
$result_label.Size = New-Object System.Drawing.Size(240, 30)
$result_label.Text = "Results will be listed here"
$Form.Controls.Add($result_label)


$ping_computer_click = { 
    function pingTO {
        $ComputerName = $textBox.Text.ToString()
        if (Test-Connection $ComputerName -quiet -Count 2) {
            Write-Host -ForegroundColor Green "Computer $ComputerName has network connection"
        }
        Else {
            Write-Host -ForegroundColor Red "Computer $ComputerName does not have network connection"
        }
    }
}

#Show form
$Form.Topmost = $True
$Form.Add_Shown({ $Form.Activate() })
[void] $Form.ShowDialog()