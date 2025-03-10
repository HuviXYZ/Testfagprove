Add-Type -AssemblyName System.Windows.Forms

# Function to create a new user
function New-ADUserFromGUI {
    param (
        [string]$Name,
        [string]$Username,
        [string]$OU,
        [bool]$AddToGroup
    )

    $password = $Username.Substring(0, 2) + "UiB2025!" + $Username.Substring($Username.Length - 2)

    # Create the user
    New-ADUser -Name $Name -SamAccountName $Username -UserPrincipalName "$Username@windwave.space" -Path $OU -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true
    [System.Windows.Forms.MessageBox]::Show("Created user: $Name with username: $Username in OU: $OU", "User Created")

    # Add user to group if checkbox is checked
    if ($AddToGroup) {
        Add-ADGroupMember -Identity "M365 Premium" -Members $Username
        [System.Windows.Forms.MessageBox]::Show("Added user: $Username to group: M365 Business Premium license", "Group Updated")
    }
}

# Define the Organizational Units
$adminOU = "OU=Administrative Staff,OU=Users,OU=windwave,DC=Windwave,DC=ad"
$scientistOU = "OU=Scientists,OU=Users,OU=windwave,DC=Windwave,DC=ad"

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Create New User"
$form.Size = New-Object System.Drawing.Size(350, 300)

# Create labels and textboxes for user input
$labelName = New-Object System.Windows.Forms.Label
$labelName.Text = "Full Name:"
$labelName.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($labelName)

$textBoxName = New-Object System.Windows.Forms.TextBox
$textBoxName.Location = New-Object System.Drawing.Point(120, 20)
$textBoxName.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBoxName)

$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Text = "Username:"
$labelUsername.Location = New-Object System.Drawing.Point(10, 60)
$form.Controls.Add($labelUsername)

$textBoxUsername = New-Object System.Windows.Forms.TextBox
$textBoxUsername.Location = New-Object System.Drawing.Point(120, 60)
$textBoxUsername.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBoxUsername)

$labelOU = New-Object System.Windows.Forms.Label
$labelOU.Text = "OU:"
$labelOU.Location = New-Object System.Drawing.Point(10, 100)
$form.Controls.Add($labelOU)

$comboBoxOU = New-Object System.Windows.Forms.ComboBox
$comboBoxOU.Items.AddRange(@("Administrative Staff", "Scientists"))
$comboBoxOU.Location = New-Object System.Drawing.Point(120, 100)
$comboBoxOU.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($comboBoxOU)

# Create checkbox for group addition
$checkBoxGroup = New-Object System.Windows.Forms.CheckBox
$checkBoxGroup.Text = "Add to M365 Business Premium license"
$checkBoxGroup.Location = New-Object System.Drawing.Point(120, 140)
$form.Controls.Add($checkBoxGroup)

# Create the button to create the user
$buttonCreate = New-Object System.Windows.Forms.Button
$buttonCreate.Text = "Create User"
$buttonCreate.Location = New-Object System.Drawing.Point(120, 180)
$buttonCreate.Add_Click({
    $name = $textBoxName.Text
    $username = $textBoxUsername.Text
    $ou = if ($comboBoxOU.SelectedItem -eq "Administrative Staff") { $adminOU } else { $scientistOU }
    $addToGroup = $checkBoxGroup.Checked
    New-ADUserFromGUI -Name $name -Username $username -OU $ou -AddToGroup $addToGroup
})
$form.Controls.Add($buttonCreate)

# Show the form
$form.ShowDialog()