\
# AD User Automation Lab

This is a lab project for automating the creation of Active Directory users, Organizational Units (OUs), and groups using PowerShell and CSV files.

## 🔧 Features

- Bulk user creation via `users.csv`
- Automatic OU creation if not exists
- Group creation and user assignment
- Logging to `user_creation_log.txt`
- Modular and testable PowerShell script

## 📁 Project Structure

```
AD-User-Automation/
│
├── NewCreateUsers.ps1          # PowerShell script for automation
├── users.csv                   # CSV with user data
├── user_creation_log.txt       # Execution log
└── README.md                   # Project documentation
```

## 🚀 How to Use

1. Ensure Active Directory module is installed and available.
2. Place the files in a suitable directory, e.g. `C:\\LAB-SCRIPTS\\`
3. Run the script as administrator:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
.\NewCreateUsers.ps1
```

4. Check the log file (`user_creation_log.txt`) for results.

## 🧪 Sample users.csv Format

```csv
FirstName,LastName,Username,OU,Group
Alice,Johnson,ajohnson,HR,HR-Team
Bob,Smith,bsmith,IT,IT-Team
```

## 📌 Notes

- Default password: `DemoUser123!`
- AD domain assumed to be: `lab.local`
- OUs will be created under the root domain
- Users will be added to groups, which are created if missing

## 🛡️ For Learning and Lab Use Only

This is intended for training and lab environments — not for production without adjustments.
