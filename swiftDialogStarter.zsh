#!/bin/zsh
## set -x

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
## Version 0.3.6 Created by David Raabe, Jamf Professional Services
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

## Sets timer between steps in testing mode
  sleepTestingMode=.2

## Defines if Swift Dialog attempts to install (if missing) in testing mode
  dialogInstallTestingMode=false

#########################################################################################
# General Appearance
#########################################################################################
# Flag the app to open fullscreen or as a window
  fullScreen=false # Set variable to true or false

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
  ORG_NAME="$orgName"
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

## Perform action on the finalization button depression
    performActionOnCompletion=false

## Variable to determine if this command should run in testing mode
    runCommandInTestingMode=false

## Variable for the commmand to run when the finalization button is pushed
## This will require testing if using a nonliteral statement, and may undergo changes in the future
    commandToPerform='say -v Zarvox A wolf remains a wolf, even if it has not eaten your sheep'


#########################################################################################
# Trigger to be used to call the policy
#########################################################################################
# Policies can be called be either a custom trigger or by policy id.
# Select either "event", to call the policy by the custom trigger,
# or "id" to call the policy by id.
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
settingComputerName=false
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
deviceRegistration=false

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

registrationTitle="Registering your Mac"
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

## Registration window title
    registrationDialogTitle="Register Your Mac at $orgName"


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
## CORE LOGIC - 
## DO NOT MODIFY BEYOND THIS POINT
## Here be Dragons!
#########################################################################################

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
  while [[ "$dockStatus" == "" ]]; do
    echo "Desktop is not loaded. Waiting."
    sleep 2
    dockStatus=$(pgrep -x Dock)
  done
  echo "Dock Loaded"
}

update_dialog () {
    logging "DIALOG: $1"
    echo "$1" >> "$dialogLogFile"
}


finish_dialog () {
    update_dialog "progresstext: $completeAlertText"
    sleep 1
    update_dialog "quit:"
    exit 0
}


requiredField(){
  inputValue=$1
  if [[ $inputValue == true ]];then
    echo ",required"
  else
    echo ""
  fi
}


registrationSetup(){
  ##  Usage: registrationSetup fieldType nameReg nameReq nameTitle nameListPrompt
  ## fieldType options are textfield, dropdown, radio
  fieldType=$1
  nameReg=$2
  nameReqRaw=$3
  nameTitle=$4
  nameListPrompt=$5

  nameReq=$(requiredField $nameReqRaw)

  case $fieldType in
    textfield)
      selectionType="--textfield"
      selectionValue=",prompt="
      ;;
    dropdown)
      selectionType="--selecttitle"
      selectionValue=" --selectvalues "
      ;;
    radio)
      selectionType="--selecttitle"
      nameReq=",radio$nameReq"
      selectionValue=" --selectvalues "
      ;;
    *)
      echo ""
      ;;
  esac

  if [[ $nameReg == true ]];then
    nameList=("$selectionType \"$nameTitle\"$nameReq$selectionValue\"$nameListPrompt\"")
  fi
  echo "$nameList"
}


registrationConfiguration(){
  ## Usage ex. registrationConfiguration tFTest flag regValue
  tFTest="$1"
  flag="$2"
  regValue="$3"

  if [[ $tFTest == true && "$regValue" != "" && "$regValue" != "\"\"" ]];then
    regOutput="$flag $regValue"
  else
    regOutput=""
  fi
  echo "$regOutput"
}


registrationCounterMath(){
  ## Usage registrationCounterMath "valueToBeEvaluated" "origNumber"
  valueToBeEvaluated="$1"
  origNumber=$2
  if [[ $valueToBeEvaluated == true ]];then
    increment='1'
  else
    increment='0'
  fi
  
  modNumber=$(($origNumber+$increment))
  echo "$modNumber"

}


installDialog() {
## Validate / install swiftDialog (Thanks, BIG-RAT, Setup-Your-Mac and @acodega!)

    # Get the URL of the latest PKG From the Dialog GitHub repo
    dialogURL=$(curl -L --silent --fail "https://api.github.com/repos/swiftDialog/swiftDialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")

    # Expected Team ID of the downloaded PKG
    expectedDialogTeamID="PWA5E9TQ59"

    logging "warning" "SwiftDilog not Installed. Installing swiftDialog..."

    # Create temporary working directory
    tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/dialog.$(date -j +%s)" )

    # Download the installer package
    /usr/bin/curl --location --silent "$dialogURL" -o "$tempDirectory/Dialog.pkg"

    # Verify the download
    teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/Dialog.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')

    # Install the package if Team ID validates
    if [[ "$expectedDialogTeamID" == "$teamID" ]]; then
        /usr/sbin/installer -pkg "$tempDirectory/Dialog.pkg" -target /
        sleep 2
        if [[ -f /usr/local/bin/dialog ]];then
          dialogVersion=$( /usr/local/bin/dialog --version )
          logging "success" "swiftDialog version ${dialogVersion} installed; proceeding..."
        else
          # Display a so-called "simple" dialog if Team ID fails to validate
          osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\r• Dialog Team ID verification failed\r\r" with title "SwiftDialog Starter: Error" buttons {"Close"} with icon caution'
          logging "error" "SwiftDialog has faild to install.  Please install SwiftDialog before proceeding"
          exit 1
        fi
    else
        # Display a so-called "simple" dialog if Team ID fails to validate
        osascript -e 'display dialog "Please advise your Support Representative of the following error:\r\r• Dialog Team ID verification failed\r\r" with title "SwiftDialog Starter: Error" buttons {"Close"} with icon caution'
        logging "error" "SwiftDialog has faild to install.  Please install SwiftDialog before proceeding"
        exit 1
    fi

    # Remove the temporary working directory when done
    /bin/rm -Rf "$tempDirectory"
}


logging () {
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
## DO NOTHING UNTIL DOCK IS LOADED
#########################################################################################

checkForDock

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
currentUserHomeFolder="$(dscl . -read /Users/"$currentUser" NFSHomeDirectory | awk '{print $NF}')"

## dialogInstallerLog: Location of this script's log **DO NOT CHANGE**
dialogInstallerLog="/var/log/dialogInstallerLog.log"

## Finds Self Service App
selfServiceAppName=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path)

## Command file location 
customCommandFile="/private/tmp/dialog.log"

## Dialog variables
dialogHeightPerItem="55"
dialogWidth="820"
dialogHeightInitial="180"
iconSize="120"

declare -a theStepTitle
declare -a theStepCommand
declare -a registrationValues
declare -a registrationList

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
performActionOnCompletion="$(lowerCase $performActionOnCompletion)"
runCommandInTestingMode="$(lowerCase $runCommandInTestingMode)"

buildingReq="$(lowerCase $buildingReq)"
departmentReq="$(lowerCase $departmentReq)"
assetTagReq="$(lowerCase $assetTagReq)"
usernameReq="$(lowerCase $usernameReq)"
emailReq="$(lowerCase $emailReq)"
FullNameReq="$(lowerCase $FullNameReq)"
computerReq="$(lowerCase $computerReq)"


regCount="0"
regCount=$(registrationCounterMath "$buildingReg" "$regCount")
regCount=$(registrationCounterMath "$departmentReg" "$regCount")
regCount=$(registrationCounterMath "$assetTagReg" "$regCount")
regCount=$(registrationCounterMath "$usernameReg" "$regCount")
regCount=$(registrationCounterMath "$emailReg" "$regCount")
regCount=$(registrationCounterMath "$FullNameReg" "$regCount")
regCount=$(registrationCounterMath "$computerReg" "$regCount")

registrationList+=($(registrationSetup "dropdown" "$buildingReg" "$buildingReq" "$buildingVarTitle" "$buildingList"))
registrationList+=($(registrationSetup "dropdown" "$departmentReg" "$departmentReq" "$departmentVarTitle" "$departmentList"))
registrationList+=($(registrationSetup "textfield" "$assetTagReg" "$assetTagReq" "$assetTagVarTitle" "$assetTagPromptTitle"))
registrationList+=($(registrationSetup "textfield" "$usernameReg" "$usernameReq" "$userNameVarTitle" "$userNamePromptTitle"))
registrationList+=($(registrationSetup "textfield" "$emailReg" "$emailReq" "$emailAddressVarTitle" "$emailAddressPromptTitle"))
registrationList+=($(registrationSetup "textfield" "$FullNameReg" "$FullNameReq" "$fullNameVarTitle" "$fullNamePromptTitle"))
registrationList+=($(registrationSetup "textfield" "$computerReg" "$computerReq" "$computerNameVarTitle" "$computerNamePromptTitle"))

if [[ $fullScreen == true ]];then
  fullScreenDiag="--blurscreen"
else
  fullScreenDiag=""
fi

if [[ ! -f /usr/local/bin/dialog ]];then
  if [[ $testingMode != false && $dialogInstallTestingMode != true ]];then
    logging "warning" "SwiftDilog not Installed. Your configuration doesn't install SwiftDialog"
    logging "Please install SwiftDialog or change the variable on line 54"
    exit 1
  elif [[  $testingMode == false || $dialogInstallTestingMode == true ]];then 
    logging "warning SwiftDilog not Installed. Installing swiftDialog..."
    installDialog
  fi
else
  logging "SwiftDialog is installed.  Proceeding"
fi 

## Getting Self Service Custom Branding Icon from Jamf Pro
if [[ $selfServiceCustomBranding != false ]];then 
	open "$selfServiceAppName"
	until [[ -f /Users/$currentUser/Library/Application\ Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png ]] || [[ $selfServiceCustomWait == 0 ]];do
		sleep 1
		selfServiceCustomWait=$(($selfServiceCustomWait-1))
	done
  if [[ $selfServiceCustomWait -gt 0 ]];then
  	dialogIcon=$(/usr/libexec/PlistBuddy -c "print :com.jamfsoftware.selfservice.brandinginfo:iconURL" /Users/"$currentUser"/Library/Preferences/com.jamfsoftware.selfservice.mac.plist)
  fi
  
  kill $(pgrep $(basename "$selfServiceAppName"))
fi

## Installing SwiftDialog if not installed
## Find something that works (look at the code that BIG-RAT found)

if [[ $deviceRegistration == true ]];then
  theStepTitle+=("\"$registrationTitle\"")
fi

if [[ $settingComputerName == true ]];then
  theStepTitle+=("\"$computerNameTitle\"")
fi

if [[ $performActionOnCompletion == true ]];then
  buttonCommandFinal="--button1shellaction \"spawn { $commandToPerform } &\""
##  buttonCommandFinal="--button1shellaction \"sleep 10\""
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

finalRegHeight=$(($dialogHeightInitial+200+$((15*$regCount))))
finalConfigHeight=$(($dialogHeightInitial+$((44*$policyArrayLength))))

if [[ $finalConfigHeight > $finalRegHeight ]];then
  finalRegHeight="$finalConfigHeight"
fi

dialogConfigRegister=(
    "--title \"$registrationDialogTitle\""
    "--icon \"$dialogIcon\""
    "--button1text \"Register your Mac\""
    "--position centre"
    "--message \"$mainText\""
    "--width \"$dialogWidth\""
    "--height \"$finalRegHeight\""
    "--messagefont \"size=16\""
    "--ontop"
    "${registrationList}"
)

dialogConfigSplash=(
    "$fullScreenDiag"
    "--title \"$dialogTitle\""
    "--icon \"$dialogIcon\""
    "--button1text \"\""
    "--button1disabled"
    "--width \"$dialogWidth\""
    "--height \"$finalConfigHeight\""
    "--message \"$mainText\""
    "--messagefont \"size=16\""
    "--position centre"
    \'$buttonCommandFinal\'
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

  ## Parse registration responses
  regBuilding="$(echo "$registrationRaw"  | grep "$buildingVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regDepartment="$(echo "$registrationRaw"  | grep "$departmentVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regAssetTag="$(echo "$registrationRaw"  | grep "$assetTagVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regUserName="$(echo "$registrationRaw"  | grep "$userNameVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regEmailAddress="$(echo "$registrationRaw"  | grep "$emailAddressVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regFullName="$(echo "$registrationRaw"  | grep "$fullNameVarTitle" |grep -v index | awk -F ": " '{print $NF}')"
  regComputerName=$(echo "$registrationRaw"  | grep "$computerNameVarTitle" |grep -v index | awk -F ": " '{print $NF}')

  ## Configure recon flags from registration
  registrationValues+=$(registrationConfiguration "$buildingReg" "-building" "$regBuilding")
  registrationValues+=$(registrationConfiguration "$departmentReg" "-department" "$regDepartment")
  registrationValues+=$(registrationConfiguration "$assetTagReg" "-assetTag" "$regAssetTag")
  registrationValues+=$(registrationConfiguration "$usernameReg" "-endUsername" "$regUserName")
  registrationValues+=$(registrationConfiguration "$emailReg" "-email" "$regEmailAddress")
  registrationValues+=$(registrationConfiguration "$FullNameReg" "-realname" "$regFullName")

  ## do stuff here

  if [[ $testingMode != "false" && $(echo $registrationValues| xargs) != "" ]];then
    echo "$jamfPath recon $registrationValues"
    logging "$jamfPath recon $registrationValues"
    sleep $sleepTestingMode
  elif [[ $testingMode == "false" && $(echo $registrationValues| xargs) != "" ]];then
    eval $jamfPath recon $registrationValues 2>&1 | tee -a "$dialogInstallerLog"
  else
    logging "warning" "No Registration values populated"
  fi
  update_dialog "listitem: title: $registrationTitle, status: success"
fi

if [[ $settingComputerName == "true" ]];then
  update_dialog "listitem: title: $computerNameTitle, status: wait"
  macName=$(computerNamingConvention)
  if [[ $testingMode != "false" ]];then
    echo "$jamfPath setComputerName -name \"$macName\""
    logging "$jamfPath setComputerName -name \"$macName\""
    sleep $sleepTestingMode
  else
    $jamfPath setComputerName -name "$macName" 2>&1 | tee -a "$dialogInstallerLog" 
  fi
  update_dialog "listitem: title: $computerNameTitle, status: success"
fi

for (( i=1; $i<=policyArrayLength; i++ )); do
    currentTitle="$policyArrayTitle[$i]"
    currentCommand="$policyArrayCommand[$i]"

    if [[ $currentCommand == "" ]];then
      continue
    fi

    logging "$currentTitle.."
    update_dialog "listitem: title: $currentTitle, status: wait"

    if [[ $testingMode != "false" ]];then
      echo "$jamfPath policy -"$policyTrigger" $currentCommand"
      sleep $sleepTestingMode
    else
      $jamfPath policy -"$policyTrigger" "$currentCommand" 2>&1 | tee -a "$dialogInstallerLog"
    fi

    logging "success" "Trigger $currentCommand was successfully executed."
    update_dialog "listitem: title: $currentTitle, status: success"

done


update_dialog "button1text: $completeButtonText"
update_dialog "message: $completeAlertText"
update_dialog "button1: enable"




