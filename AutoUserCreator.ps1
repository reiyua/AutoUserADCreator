# Copyright 2024 Rayyan Hodges, TAFE NSW, AlphaDelta
# Contact: rayyan.hodges@studytafensw.edu.au
# Program Name: AutoUserCreator
# Purpose of script: Create a batch set of user's using a CSV file containing a list of predetermined users.

# Import required PowerShell Modules
Import-Module ActiveDirectory

# Define temporary password which MUST be changed when the user first logs into the Active Directory.
$SecurePass = ConvertTo-SecureString -AsPlainText "Mypassword1" -Force

# Define the file path where the CSV file containing users is.
$csvfilepath = Read-Host - Prompt "Please enter the location of the CSV file containing the user list"

# Define variables for various columns within CSV file.
ForEach ($user in $users) {
$fname = $user.'First Name’
$lname = $user.'Last Name'
$jtitle = $user.'Job Title'
$OUpath = $user.'Organizational Unit' #Example entry: OU=Staff,OU=Manager,DC=alphadelta,DC=com

# Command to add user's to Active Directory.
New-ADUser -Name $fname -UserPrincipalName "$fname.$lname"
}
