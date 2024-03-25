#!/bin/zsh

#########################################################################################
# License information
#########################################################################################
# Copyright 2024 Jamf Professional Services

# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
# to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

#########################################################################################
## This script is heavily based on the DEPNotify-Starter 
## https://github.com/jamf/DEPNotify-Starter
#########################################################################################
## Version 0.1.0 Created by David Raabe, Jamf Professional Services
#########################################################################################

#########################################################################################
# General Information
#########################################################################################
# This script is designed to make implementation of Swift Dialog very easy with limited
# scripting knowledge. The section below has variables that may be modified to customize
# the end user experience. DO NOT modify things in or below the CORE LOGIC area unless
# major testing and validation is performed.

# More information at: https://github.com/swiftDialog/swiftDialog

#########################################################################################
# Testing Mode
#########################################################################################
# Testing flag will enable the following things to change:
# Auto removal of BOM files to reduce errors
# Sleep commands instead of policies or other changes being called
# Quit Key set to command + control + x
  testingMode=true # Set variable to true or false

#########################################################################################
# General Appearance
#########################################################################################
# Flag the app to open fullscreen or as a window
  fullScreen=true # Set variable to true or false

#########################################################################################
# Custom Self Service Branding
#########################################################################################
# Flag for using the custom branding icon from Self Service and Jamf Pro
# This will override the banner image specified above. If you have changed the
# name of Self Service, make sure to modify the Self Service name below.
# Please note, custom branding is downloaded from Jamf Pro after Self Service has opened
# at least one time. The script is designed to wait until the files have been downloaded.
# This could take a few minutes depending on server and network resources.
selfServiceCustomBranding=true # Set variable to true or false

# Number of seconds to wait (seconds) for the Self Service custon icon.
selfServiceCustomWait=30

# Banner image can be 600px wide by 100px high. Images will be scaled to fit
# If this variable is left blank, the generic image will appear. If using custom Self
# Service branding, please see the Customized Self Service Branding area below
  dialogIcon="https://cdn.icon-icons.com/icons2/2699/PNG/512/jamf_logo_icon_169602.png"


# Update the variable below replacing "Organization" with the actual name of your organization. 
# Example "ACME Corp Inc."
  orgName="Organization"

# Main heading that will be displayed under the image
# If this variable is left blank, the generic banner will appear
  bannerTitle="Welcome to $orgName"
	
# Update the variable below replacing "email helpdesk@company.com" with the actual plaintext instructions 
# for your organization. Example "call 555-1212" or "email helpdesk@company.com"
  supportContactDetails="email helpdesk@company.com"
  
# Paragraph text that will display under the main heading. For a new line, use \n
# If this variable is left blank, the generic message will appear. Leave single
# quotes below as double quotes will break the new lines.
  mainText='Thanks for choosing a Mac at '$orgName'! We want you to have a few applications and settings configured before you get started with your new Mac. This process should take 10 to 20 minutes to complete. \n \n If you need additional software or help, please visit the Self Service app in your Applications folder or on your Dock.'

# Initial Start Status text that shows as things are firing up
  initialStartStatus="Initial Configuration Starting..."

# Text that will display in the progress bar
  installCompleteStatus="Configuration Complete!"

# Text that will display inside the alert once policies have finished
    completeButtonText="Get Started!"
# Option for dropdown alert box
    completeAlertText="Your Mac is now finished with initial setup and configuration. Press $completeButtonText to get started!"
# Options if not using dropdown alert box
    completeMainText='Your Mac is now finished with initial setup and configuration.'


#########################################################################################
# Trigger to be used to call the policy
#########################################################################################
# Policies can be called be either a custom trigger or by policy id.
# Select either event, to call the policy by the custom trigger,
# or id to call the policy by id.
	policyTrigger="event"

#########################################################################################
# Policy Variable to Modify
#########################################################################################
# The policy array must be formatted "Progress Bar text,customTrigger". These will be
# run in order as they appear below.
  policyArray=(
    "Installing Adobe Creative Cloud,adobeCC"
    "Installing Adobe Reader,adobeReader"
    "Installing Chrome,chrome"
    "Installing Firefox,firefox"
    "Installing Zoom,zoom"
    "Installing NoMAD,nomad"
    "Installing Office,msOffice"
    "Installing Webex,webex"
    "Installing Critical Updates,updateSoftware"
  )

#########################################################################################
## Computer Name
#########################################################################################
settingComputerName=true
computerNameTitle="Setting Your Computer Name"

computerNamingConvention(){
  ## Preset variables 
  compSerial="$serialNumber"
  compBuilding="$regBuilding"
  compDepartment="$regDepartment"
  compAssetTag="$regAssetTag"
  compUsername="$regUserName"
  compEmailAddress="$regEmailAddress"
  compFullName="$regFullName"
  compComputerName="$regComputerName"

  ## Ex. computerName="Jamf-$compSerial-$compAssetTag-PS"
  computerName="mac-$compSerial"

  ## Returns Computer Name
  echo "$computerName"
}

#########################################################################################
## Device Registration
#########################################################################################
deviceRegistration=true
registrationTitle="Registering your Mac"

## Set registration fields
buildingReg=true
departmentReg=true
assetTagReg=true
usernameReg=true
emailReg=true
FullNameReg=true
computerReg=true

## Set required registration fields
buildingReq=false
departmentReq=false
assetTagReq=false
usernameReq=false
emailReq=false
FullNameReq=false
computerReq=false

assetTagPromptTitle="Asset Tag"
userNamePromptTitle="User Name"
emailAddressPromptTitle="Email Address"
fullNamePromptTitle="Full name"
computerNamePromptTitle="Computer Name"

buildingVarTitle="Building"
departmentVarTitle="Department"
assetTagVarTitle="Asset Tag"
userNameVarTitle="User Name"
emailAddressVarTitle="Email Address"
fullNameVarTitle="Full Name"
computerNameVarTitle="Computer Name"

## List of departments, comma separated
  departmentList="Marketing, IT, Support, Development, Things, Stuff, Timmy"

## List of buildings, comma separated
  buildingList="Amsterdam, Katowice, Eau Claire, Minneapolis"

## Registration button text
  registrationButtonText="Register your Computer"

#########################################################################################
# Caffeinate / No Sleep Configuration
#########################################################################################
# Flag script to keep the computer from sleeping. BE VERY CAREFUL WITH THIS FLAG!
# This flag could expose your data to risk by leaving an unlocked computer wide open.
# Only recommended if you are using fullscreen mode and have a logout taking place at
# the end of configuration (like for FileVault). Some folks may use this in workflows
# where IT staff are the primary people setting up the device. The device will be
# allowed to sleep again once the DEPNotify app is quit as caffeinate is looking
# at DEPNotify's process ID.
  noSleep=false

#########################################################################################
# Variables used by script
#########################################################################################

jamfPath="/usr/local/jamf/bin/jamf"

### swiftDialog Variables
dialogLogFile="/var/tmp/dialog.log"
dialogPath="/usr/local/bin/dialog"
dialogTitle="$bannerTitle"

## Get Serial Number
serialNumber="$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')"

## Get logged in User and User ID
currentUser="$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )"
currentUserID=$( /usr/bin/id -u "$currentUser" )

## dialogInstallerLog: Location of this script's log **DO NOT CHANGE**
dialogInstallerLog="/var/log/dialogInstallerLog.log"

## Finds Self Service App
selfServiceAppName=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path)

## Command file location 
customCommandFile="/private/tmp/dialog.log"

## Dialog variables
dialogHeightPerItem=55
dialogWidth=650
iconSize=120

declare -a theStepTitle
declare -a theStepCommand
declare -a registrationValues

#########################################################################################
## Functions used by script
#########################################################################################

lowerCase(){
  ## usage "lowercase <string to lower the case>"
  originText=$1
  lowerText=$(echo "$originText" | tr '[:upper:]' '[:lower:]')
  echo "$lowerText"
}

checkForDock(){
dockStatus=$(pgrep -x Dock)
echo "Waiting for Desktop"
while [ "$dockStatus" == "" ]; do
	echo "Desktop is not loaded. Waiting."
	sleep 2
	dockStatus=$(pgrep -x Dock)
done
}

findSelfService(){
	for appTitle in /Applications/* ; do
		bundleID=$(/usr/bin/plutil -extract CFBundleIdentifier raw "$appTitle/Contents/info.plist")
		if [[ $bundleID == com.jamfsoftware.selfservice.mac ]];then
			theApp=$(echo "$appTitle"| awk 'BEGIN{FS="/"} {print $NF}')
			appName="$theApp"

		fi
	done
	echo "$appName"
}

update_dialog () {
    log_it "DIALOG: $1"
    echo "$1" >> "$dialogLogFile"
}

finish_dialog () {
    update_dialog "progresstext: $completeAlertText"
    sleep 1
    update_dialog "quit:"
    exit 0
}

requiredField(){
if [[ $inputValue == true ]];then
  echo ",required"
else
  echo ""
fi
}

log_it () {
  timeStamp=$(date -j +%H:%M)
    if [[ ! -z "$1" && -z "$2" ]]; then
        logEvent="INFO"
        logMessage="$1"
    elif [[ "$1" == "warning" ]]; then
        logEvent="WARN"
        logMessage="$2"
    elif [[ "$1" == "success" ]]; then
        logEvent="SUCCESS"
        logMessage="$2"
    elif [[ "$1" == "error" ]]; then
        logEvent="ERROR"
        logMessage="$2"
    fi

    if [[ ! -z "$logEvent" ]]; then
        echo ">>[dialogInstallerLog.sh] :: $logEvent [$timeStamp] :: $logMessage" >> "$dialogInstallerLog"
    fi
}

#########################################################################################
## Initialization
#########################################################################################

## formatting variables to lowercase
selfServiceCustomBranding="$(lowerCase $selfServiceCustomBranding)"
testingMode="$(lowerCase $testingMode)"
noSleep="$(lowerCase $noSleep)"
deviceRegistration="$(lowerCase $deviceRegistration)"
buildingReg="$(lowerCase $buildingReg)"
departmentReg="$(lowerCase $departmentReg)"
assetTagReg="$(lowerCase $assetTagReg)"
usernameReg="$(lowerCase $usernameReg)"
emailReg="$(lowerCase $emailReg)"
FullNameReg="$(lowerCase $FullNameReg)"
computerReg="$(lowerCase $computerReg)"

buildingReq="$(lowerCase $buildingReq)"
departmentReq="$(lowerCase $departmentReq)"
assetTagReq="$(lowerCase $assetTagReq)"
usernameReq="$(lowerCase $usernameReq)"
emailReq="$(lowerCase $emailReq)"
FullNameReq="$(lowerCase $FullNameReq)"
computerReq="$(lowerCase $computerReq)"

if [[ $buildingReg == true ]];then
  buildingReq=$(requiredField $buildingReq)
  registrationList+=("--selecttitle \"$buildingVarTitle\"$buildingReq --selectvalues \"$buildingList\"")
fi

if [[ $departmentReg == true ]];then
  departmentReq=$(requiredField $departmentReq)
  registrationList+=("--selecttitle \"$departmentVarTitle\"$departmentReq --selectvalues \"$departmentList\"")
fi

if [[ $assetTagReg == true ]];then
  assetTagReq=$(requiredField $assetTagReq)
  registrationList+=("--textfield \"$assetTagVarTitle\"$assetTagReq,prompt=\"$assetTagPromptTitle\"")
fi

if [[ $usernameReg == true ]];then
  usernameReq=$(requiredField $usernameReq)
  registrationList+=("--textfield \"$userNameVarTitle\"$usernameReq,prompt=\"$userNamePromptTitle\"")
fi

if [[ $emailReg == true ]];then
  emailReq=$(requiredField $emailReq)
  registrationList+=("--textfield \"$emailAddressVarTitle\"$emailReq,prompt=\"$emailAddressPromptTitle\"")
fi

if [[ $FullNameReg == true ]];then
  FullNameReq=$(requiredField $FullNameReq)
  registrationList+=("--textfield \"$fullNameVarTitle\"$FullNameReq,prompt=\"$fullNamePromptTitle\"")
fi

if [[ $computerReg == true ]];then
  computerReq=$(requiredField $computerReq)
  registrationList+=("--textfield \"$computerNameVarTitle\"$computerReq,prompt=\"$computerNamePromptTitle\"")
fi

## Getting Self Service Custom Branding Icon from Jamf Pro
if [[ $selfServiceCustomBranding != false ]];then 
	open "$selfServiceAppName"
	until [[ -f /Users/$currentUser/Library/Application\ Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png ]] || [[ $selfServiceCustomWait == 0 ]];do
		sleep 1
		selfServiceCustomWait=$(($selfServiceCustomWait-1))
	done
  echo "$selfServiceCustomWait"
  if [[ $selfServiceCustomWait -gt 0 ]];then
  	dialogIcon=$(/usr/libexec/PlistBuddy -c "print :com.jamfsoftware.selfservice.brandinginfo:iconURL" /Users/"$currentUser"/Library/Preferences/com.jamfsoftware.selfservice.mac.plist)
  fi
  
  kill $(pgrep $(findSelfService))
fi

## Installing SwiftDialog if not installed
## Find working code to do this
if [[ $deviceRegistration == true ]];then
  theStepTitle+=("\"$registrationTitle\"")
fi

if [[ $settingComputerName == true ]];then
  theStepTitle+=("\"$computerNameTitle\"")
fi

for policy in "${policyArray[@]}";do
  titleItem="$(echo "$policy" | cut -d ',' -f1)"
  triggerItem="$(echo "$policy" | cut -d ',' -f2)"
  policyArrayTitle+=($titleItem)
  policyArrayCommand+=($triggerItem)
  theStepTitle+=("\"$titleItem\"")
  theStepCommand+=("\"$triggerItem\"")
done

policyArrayLength="${#theStepTitle[@]}"

dialogConfigRegister=(
    "--title \"$dialogTitle\""
    "--icon \"$dialogIcon\""
    "--button1text \"Register your Mac\""
    "--position centre"
    "--message \"$mainText\""
    "--messagefont \"size=16\""
    "--ontop"
    "${registrationList}"
)

dialogConfigSplash=(
    "--blurscreen"
    "--title \"$dialogTitle\""
    "--icon \"$dialogIcon\""
    "--button1text \"\""
    "--button1disabled"
    "--message \"$mainText\""
    "--messagefont \"size=16\""
    "--position centre"
    "${theStepTitle[@]/#/--listitem }"
)

###################################################
## Main
###################################################

rm "$dialogLogFile"
eval "$dialogPath" "${dialogConfigSplash[*]}" & sleep 1

for (( i=0; $i<=policyArrayLength; i++ )); do
    update_dialog "listitem: index: $i, status: pending"
done

if [[ $deviceRegistration == "true" ]];then
  ## Device Registration
  update_dialog "listitem: title: $registrationTitle, status: wait"
  sleep 1
  registrationRaw=$(eval "$dialogPath" "${dialogConfigRegister[*]}")
  update_dialog "activate:"


  regBuilding="$(echo "$registrationRaw"  | grep "$buildingVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regDepartment="$(echo "$registrationRaw"  | grep "$departmentVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regAssetTag="$(echo "$registrationRaw"  | grep "$assetTagVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regUserName="$(echo "$registrationRaw"  | grep "$userNameVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regEmailAddress="$(echo "$registrationRaw"  | grep "$emailAddressVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regFullName="$(echo "$registrationRaw"  | grep "$fullNameVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regComputerName=$(echo "$registrationRaw"  | grep "$computerNameVarTitle" |grep -v index | awk -F ": " '{print $NF}')

if [[ $buildingReg == true ]];then
  registrationValues+="-building $regBuilding"
fi

if [[ $departmentReg == true ]];then
  registrationValues+="-department $regDepartment"
fi

if [[ $assetTagReg == true ]];then
  registrationValues+="-assetTag \"$regAssetTag\""
fi

if [[ $usernameReg == true ]];then
  registrationValues+="-endUsername \"$regUserName\""
fi

if [[ $emailReg == true ]];then
  registrationValues+="-email \"$regEmailAddress\""
fi

if [[ $FullNameReg == true ]];then
  registrationValues+="-realname \"$regFullName\""
fi

  ## do stuff here

  if [[ $testingMode != "false" ]];then
    echo "$jamfPath recon $registrationValues"
    sleep 1
  else
    eval $jamfPath recon $registrationValues 2>&1 | tee -a "$dialogInstallerLog" 
  fi
  update_dialog "listitem: title: $registrationTitle, status: success"
fi

if [[ $settingComputerName == "true" ]];then
  update_dialog "listitem: title: $computerNameTitle, status: wait"
  macName=$(computerNamingConvention)
  if [[ $testingMode != "false" ]];then
    echo "$jamfPath setComputerName -name \"$macName\""
    sleep 1
  else
    $jamfPath setComputerName -name \"$macName\" 2>&1 | tee -a "$dialogInstallerLog" 
    sleep 1
  fi
  update_dialog "listitem: title: $computerNameTitle, status: success"
fi

for (( i=1; $i<policyArrayLength; i++ )); do
    currentTitle="$policyArrayTitle[$i]"
    currentCommand="$policyArrayCommand[$i]"

    log_it "$currentTitle.."
    update_dialog "listitem: title: $currentTitle, status: wait"

    if [[ $testingMode != "false" ]];then
      echo "/usr/local/jamf/bin/jamf policy -event $currentCommand" ## 2>&1  | tee -a "$dialogInstallerLog"
      sleep 1
    else
      /usr/local/jamf/bin/jamf policy -event $currentCommand 2>&1 | tee -a "$dialogInstallerLog"
    fi

    log_it "success" "Trigger $currentCommand was successfully executed."
    update_dialog "listitem: title: $currentTitle, status: success"

done

update_dialog "button1text: Finish"
update_dialog "message: $completeAlertText"
update_dialog "button1: enable"
