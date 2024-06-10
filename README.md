# Introduction

This script is designed to make implementation an onboarding splash screen with Swift Dialog very easy with limited scripting knowledge. The beginning portion of the script has variables that may be modified to customize the end user experience. DO NOT modify things in or below the CORE LOGIC area unless  major testing and validation is performed.

# Initial Testing

Install [Swift Dialog](https://github.com/swiftDialog/swiftDialog).
Download the swiftDialogStarter.zsh or clone this repo.
Make the script executable.
Ensure that testingMode is enabled `testingMode=true`
Run the script (requires sudo)
    - The script makes no changes in testing mode by default.  Swift Dialog's default listening file is in a location that requires sudo to write to.  This will be updated in a future release (Probably /private/tmp)