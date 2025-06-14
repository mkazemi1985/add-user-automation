# Define path to log file
$logPath = "C:\LAB-SCRIPTS\user_creation_log.txt"
"===== User Creation Log - $(Get-Date) =====`n" | Out-File $logPath

# Import users from CSV file
$users = Import-Csv "C:\LAB-SCRIPTS\users.csv"

foreach ($user in $users) {
    $ouPath = "OU=$($user.OU),DC=lab,DC=local"

    # Check and create OU if not exists
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$($user.OU)'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $user.OU -Path "DC=lab,DC=local"
        "OU '$($user.OU)' created." | Out-File $logPath -Append
    } else {
        "OU '$($user.OU)' already exists. Skipped." | Out-File $logPath -Append
    }

    # Check and create user if not exists
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($user.Username)'" -ErrorAction SilentlyContinue)) {
        New-ADUser `
            -Name "$($user.FirstName) $($user.LastName)" `
            -SamAccountName $user.Username `
            -UserPrincipalName "$($user.Username)@lab.local" `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -AccountPassword (ConvertTo-SecureString "DemoUser123!" -AsPlainText -Force) `
            -Path $ouPath `
            -Enabled $true

        "User '$($user.Username)' created." | Out-File $logPath -Append
    } else {
        "User '$($user.Username)' already exists. Skipped." | Out-File $logPath -Append
    }

    # Check and create group if not exists
    if (-not (Get-ADGroup -Filter "Name -eq '$($user.Group)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $user.Group -Path "DC=lab,DC=local" -GroupScope Global -GroupCategory Security
        "Group '$($user.Group)' created." | Out-File $logPath -Append
    } else {
        "Group '$($user.Group)' already exists. Skipped." | Out-File $logPath -Append
    }

    # Add user to group if not already a member
    if (-not (Get-ADGroupMember $user.Group | Where-Object { $_.SamAccountName -eq $user.Username })) {
        Add-ADGroupMember -Identity $user.Group -Members $user.Username
        "User '$($user.Username)' added to group '$($user.Group)'." | Out-File $logPath -Append
    } else {
        "User '$($user.Username)' is already in group '$($user.Group)'. Skipped." | Out-File $logPath -Append
    }
}

"`nAll users processed successfully." | Out-File $logPath -Append
