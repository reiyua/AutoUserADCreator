# Copyright 2024 Rayyan Hodges, M Salim Olime, TAFE NSW, AlphaDelta
# Contact: rayyan.hodges@studytafensw.edu.au, mohammad.olime1@tafensw.edu.au
# Program Name: AutoUserADCreator
# Purpose of script: Create a batch set of user's within an existing OU using a CSV file containing a list of predetermined users and OU's.
# Other Notes: My job is to create simple checks to avoid issues such as duplicate users.
# Other Notes: Credit is given for parts I have contributed to the script.

# Import required PowerShell modules
import-module ActiveDirectory

#Specify User Principal Name (Active Directory Domain Forest Name) (Rayyan Modified to allow for user to enter their own forest name)
$UPN = Read-Host -Prompt "Please enter the Active Directory Forest name (example.com)"

#Get user to specify path of the CSV file containing user info to be added into the Active Directory.
$fpath = Read-Host -Prompt "Please enter the path to your CSV file containing user info to be added to the OU's within the Active Directory Domain Forest:"

# Check if CSV file exists with the path specified by the end-user
# If so, error out the program with generic error stating so. (RAYYAN Contribution)
# This uses the "Test-Path" cmdlet which tests if the path actually exists and can be read by the system.
# Source for code (https://www.itechguides.com/powershell-check-if-file-exists/#:~:text=If%20(Test%2DPath%20%2DPath%20E%3A%5Creports%5Cprocesses.txt%20)%20%7B%0ACopy%2DItem%20%2DPath%20E%3A%5Creports%5Cprocesses.txt%20%2DDestination%20C%3A%5Creports%0A%7D)
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
       # Source for code (https://morgantechspace.com/2016/11/check-if-ad-user-exists-with-powershell.html)
    if (Get-ADUser -Filter "SamAccountName -eq '$fname.$lname'") {
        Write-Host "User $fname.$lname already exists. Skipping."
    } else {
        New-ADUser -SamAccountName "$fname.$lname" -UserPrincipalName "$fname@$UPN" -Path $OUpath -AccountPassword $fsecPass -Enabled $true -PassThru
    }
}

# Print message stating the program has completed succsessfully, and to prompt them to press any key to close the program. (RAYYAN Contribution)
# Source for code (https://www.thomasmaurer.ch/2021/01/how-to-add-sleep-wait-pause-in-a-powershell-script/#:~:text=Read%2DHost%20%2DPrompt%20%22Press%20any%20key%20to%20continue...%22)

Read-Host -Prompt "User creation completed, press any key to close the window."

