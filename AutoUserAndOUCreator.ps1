# Copyright 2024 Rayyan Hodges, M Salim Olime, TAFE NSW, AlphaDelta
# Contact: rayyan.hodges@studytafensw.edu.au, mohammad.olime1@tafensw.edu.au
# Program Name: AutoUserAndOUCreator
# Purpose of script: Create a batch set of user's and OU's using a CSV file containing a list of predetermined users and OU's.
# Other notes: Orginally created by M Salim Olime (Salim), my teacher as part of our class with my assigned modification of creating batch OU's within the script.

# Import required PowerShell modules
import-module ActiveDirectory
#Specify User Principal Name (Active Directory Domain Forest Name)
$UPN = "alphadelta.com"
#Get user to specify path of the CSV file containing user info to be added into the Active Directory.
$fpath = Read-Host -Prompt "Please enter the path to your CSV file:"
echo $fpath
$fusers = Import-Csv $fpath
#Set tempoary password to "Pa$$w0rd1" which the user will be required to change when they first login.
$fsecPass = ConvertTo-SecureString -AsPlainText "Pa$$w0rd1" -Force

# Create OU's to be placed in Active Directory (My contribution)
foreach ($ou in $fous) {
    $name = $ou.OuName
    $path = $ou.OuPath
    New-ADOrganizationalUnit -Name $name -Path $path
}

# Create user within already created OU
ForEach ($user in $fusers) {
    $fname = $user.fName
    $lname = $user.lName
    $jtitle = $user.jTitle
    $OUpath = $user.OU
    echo $fname $lname $jtitle $OUpath
    New-ADUser -SamAccountName = $fname.$lname -UserPrincipalName "$fname@alphadelta.com" -Path $OUpath -AccountPassword $fsecPass -Enabled $true -PassThru
    }
