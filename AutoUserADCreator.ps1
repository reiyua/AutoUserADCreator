# Copyright 2024 Rayyan Hodges, M Salim Olime, TAFE NSW, AlphaDelta
# Contact: rayyan.hodges@studytafensw.edu.au, mohammad.olime1@tafensw.edu.au
# Program Name: AutoUserAndOUCreator
# Purpose of script: Create a batch set of user's within an existing OU using a CSV file containing a list of predetermined users and OU's.
# Other Notes: My job is to create simple checks to avoid issues such as duplicate users.

# Import required PowerShell modules
import-module ActiveDirectory

#Specify User Principal Name (Active Directory Domain Forest Name)
$UPN = "alphadelta.com"

#Get user to specify path of the CSV file containing user info to be added into the Active Directory.
$fpath = Read-Host -Prompt "Please enter the path to your CSV file:"

# Check if CSV file exists with the path specified by the end-user
# If so, error out the program with generic error stating so. (RAYYAN Contribution)
if (-not (Test-Path $fpath)) {
    Write-Host "CSV file does not exist. Exiting script."
    exit
}

# Display path to file given by end-user
echo $fpath

#Import users from CSV file.
$fusers = Import-Csv $fpath
#Set tempoary password to "Pa$$w0rd1" which the user will be required to change when they first login.
$fsecPass = ConvertTo-SecureString -AsPlainText "Pa$$w0rd1" -Force


# Create user within already created OU
ForEach ($user in $fusers) {
    $fname = $user.fName
    $lname = $user.lName
    $jtitle = $user.jTitle
    $OUpath = $user.OU
    echo $fname $lname $jtitle $OUpath
    New-ADUser -SamAccountName = $fname.$lname -UserPrincipalName "$fname@alphadelta.com" -Path $OUpath -AccountPassword $fsecPass -Enabled $true -PassThru
    }

       # Check if user already exists within OU. Skip if so with message stating so. (RAYYAN Contribution)
    if (Get-ADUser -Filter "SamAccountName -eq '$fname.$lname'") {
        Write-Host "User $fname.$lname already exists. Skipping."
    } else {
        New-ADUser -SamAccountName "$fname.$lname" -UserPrincipalName "$fname@$UPN" -Path $OUpath -AccountPassword $fsecPass -Enabled $true -PassThru
    }
}

#Print message stating the program has completed succsessfully, and to prompt them to press any key to close the program. (RAYYAN Contribution)

Read-Host -Prompt "User creation completed, press any key to close the window."

