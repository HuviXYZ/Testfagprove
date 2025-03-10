# definerer $RootOU 
$rootOU = "OU=windwave,DC=windwave,DC=ad" 
# lager Root OU / WindWave
New-ADOrganizationalUnit -Name "windwave" -Path "DC=windwave,DC=ad"
# lager under OU under RootOU / WindWave OU
New-ADOrganizationalUnit -Name "Users" -Path $rootOU
New-ADOrganizationalUnit -Name "Computers" -Path $rootOU
New-ADOrganizationalUnit -Name "Groups" -Path $rootOU
New-ADOrganizationalUnit -Name "Servers" -Path $rootOU
redircmp "OU=Computers,OU=windwave,DC=windwave,DC=ad" # redirecter computers til nylig laget Computers OU 
#Lager underOU for Users
New-ADOrganizationalUnit -Name "Scientists" -Path "OU=Users,$rootOU"
New-ADOrganizationalUnit -Name "Administrative Staff" -Path "OU=Users,$rootOU"
# Definerer adminou, under rootOU/windwave
$adminOU = "OU=Admin,$rootOU"
# Lager admin ou under root ou
New-ADOrganizationalUnit -Name "Admin" -Path $rootOU
# lager under OU under Admin OU
New-ADOrganizationalUnit -Name "Users" -Path $adminOU
New-ADOrganizationalUnit -Name "Groups" -Path $adminOU





Deaktiver Accedential deletion

# Define the root OU
$rootOU = "OU=Bedrift,DC=joker,DC=ad"
# List of OUs to disable protection
$ouList = @(
     $rootOU,
    "OU=Users,$rootOU",
    "OU=Computers,$rootOU",
    "OU=Groups,$rootOU",
    "OU=Servers,$rootOU",
    "OU=Admin,$rootOU",
    "OU=Users,OU=Admin,$rootOU",
    "OU=Groups,OU=Admin,$rootOU"
)
# Disable protection against accidental deletion for each OU
foreach ($ou in $ouList) {
    Set-ADOrganizationalUnit -Identity $ou -ProtectedFromAccidentalDeletion $false
}
