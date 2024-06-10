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

## Device Registration
Standardized User and Location, as well as asset tag fields are available via boolean toggles.  Fields are optional by default, but can be made required via additional toggles.  
Building and Department dropdowns will need to be populated manually.

## Computer Naming
There are three different options for computer naming.  
1. Use Device Registration to allow the user to name the computer and/or use other Device Registration fields to be part of the computer's name.
2. Define the computer name based on values the computer knows (eg. Serial Number), and predefined values. (Default naming convention is "mac-$compSerial").
3. A combination of both.  


# DEP Notify Starter Upgrade
This is intended to be a _spiritual successor_ to [DEPNotify-Starter](https://github.com/jamf/DEPNotify-Starter), and shares a lot of functionality with it.  It's also designed to be a relatively easy upgrade from DEPNotify-Starter, depending on how detailed your onboarding workflow is.  

## Policy Execution
If you're only using DEPNotify-Starter for policy execution, the upgrade is fairly simple.  Replace the contents of the messaging variables, and the `policyArray` (and `policyTrigger` if using IDs), and you should be good to go.  

## Device Registration
The device registration workflow has been completely redesigned, and will need to be rebuilt, but should be simplified and streamlined.  Registration fields to be populated are toggled with true/false flags, and can be made required via additional variables.  
At this time, there is no support for custom fields, but is on the roadmap for a future release.  

## Computer Naming
As there was no standardized computer naming configuration, any existing computer naming will need to be rebuilt, using the new Computer Name Section. 

## EULA
This functionality has been removed and is not planned.  
