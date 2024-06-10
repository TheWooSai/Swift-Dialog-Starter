# Introduction

This script is designed to make implementation an onboarding splash screen with Swift Dialog very easy with limited scripting knowledge. The beginning portion of the script has variables that may be modified to customize the end user experience. DO NOT modify things in or below the CORE LOGIC area unless  major testing and validation is performed.

# Initial Testing

Install [Swift Dialog](https://github.com/swiftDialog/swiftDialog).
Download the swiftDialogStarter.zsh or clone this repo.
Make the script executable.
Ensure that testingMode is enabled `testingMode=true`
Run the script (requires sudo)

_The script makes no changes in testing mode by default.  Swift Dialog's default listening file is in a location that requires sudo to write to.  This will be updated in a future release (Probably /private/tmp)_

# Configuration

## Policy Triggers
The primary usage of this as an onboarding tool is policy execution and software installation.  The variable to look for is `policyArray`.  Each policy should have its own line.  
Policies can be called be either a custom trigger or by policy ID with the `policyTrigger` variable. Custom trigger is the default selection. Use "**event**" to use custom triggers.  Use "**id**" to use policy ID.

## Messaging
Swift Dialog allows us to provide messaging to our end users throughout the onboarding process.   The variables `orgName`, and `mainText` are the variables most likely to be modified.  orgName is used in a few places throughout the script, so it's encouraged to replace its default value with your organization's name.  