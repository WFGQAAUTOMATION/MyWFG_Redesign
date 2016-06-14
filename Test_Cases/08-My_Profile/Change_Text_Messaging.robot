*** Settings ***
Documentation      A test suite to set up or change Associate Text Messaging info
...                Author: Isabella Fayner
...                Creation Date: 05/27/2016
...
...                This test will log into MyWFG, open My Profile menu, verify the page
...                and set up or change Associate Text Messaging info
Metadata           Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library

#Suite Teardown     Close Browser

*** Variables ***
${ELEMENT_ID}        Text Messaging
${MOBILE_CARRIER}    AT&T
${CELL_PHONE}        7701234567
${DEVICE}            iPhone
${RECOGNITIONS}      NOT ALL
${VERIFY_TEXT}       You have successfully subscribed to WFG Text Message Service
${WARNING_MSG}       Please agree to the Terms and Conditions before enrolling in WFG Text messaging
${USER_ID}           26PDR

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
#**** ${PREF_USER_ID} and ${VALID_USER} don't work for Text Messaging (no Edit button) ***
#    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
#    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    When user "${USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep   2s

Go to My Profile Page
    Go To My Profile
    sleep    2s

Verify Webpage and Click Text Messaging
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    1s

Click Edit Text Messaging button for Cancel
    Click Button using id "TMDefault-Edit"
    sleep   1s

Click Cancel button
    Click Button using id "TMDefault-Cancel"
    sleep    1s

Click Edit Text Messaging button for Edit
    Click Button using id "TMDefault-Edit"
    sleep   1s

Edit Mobile Carrier List Box

#   Click List Box Named "MobileCarrierId" and select "${MOBILE_CARRIER}"\
    Click Object Named "Select Mobile Carrier" with span name
    Show Hidden List Items with ID "MobileCarrierId"
    Select from list by label  xpath=//select[@id='MobileCarrierId']  ${MOBILE_CARRIER}
    Restore Hidden List Items with ID "MobileCarrierId"
    sleep    1s

Edit Cell Phone Number
    Input "${CELL_PHONE}" in the "txtCellPhoneNumber" Field With ID
    sleep    1s

Verify Cell Phone Number
    Input "${CELL_PHONE}" in the "txtVerifyCellPhoneNumber" Field With ID
    sleep    1s

Edit Device List Box
     Click Object Named "Select Device Type" with span name
     Show Hidden List Items with ID "MobileDevice"
	 Select from list by label  xpath=//select[@id='MobileDevice']  ${DEVICE}
	 Restore Hidden List Items with ID "MobileDevice"
     sleep    1s

#*******************************************************************************
Scroll Down 1
    Scroll Page to Location Where Y equals "600"
    sleep    2s

Check Marketing Updates
    Select Checkbox Where ID is "MessageOption2"
    sleep    1s

Check Points and Commissions
    Select Checkbox Where ID is "MessageOption3"
    sleep    1s

Check Recognitions
    Run Keyword If    '${RECOGNITIONS}' == 'ALL'
    ...    Select Checkbox Where ID is "Recognitions"
    ...    ELSE
    ...    Select All Recognition Check Boxes
    sleep    1s

Check Outstanding Requirements
    Select Checkbox Where ID is "MessageOption12"
     sleep    1s

Check Commission Advances
    Select Checkbox Where ID is "MessageOption13"
    sleep    1s

Check Commission Charge Backs
    Select Checkbox Where ID is "MessageOption14"
    sleep    1s

Check I Have Read the Terms and Conditions
    Select Checkbox Where ID is "checkTerms"
    sleep    1s

Click Submit button
    Click Button using id "TMDefault-Submit"
    sleep    2s

Verify Subscription Change
    page should not contain    "${VERIFY_TEXT}"
#    Find "${VERIFY_TEXT}" On Webpage

Log Out of MyWFG
    sleep    4s
    Log Out of MyWFG

Close opened Browser
    Close Browser


*** Keywords ***

Select All Recognition Check Boxes
#   ***** Check New License Acquired *****
    Select Checkbox Where ID is "MessageOption4"
    sleep    1s
#   *****  Check First Personal Sale *****
    Select Checkbox Where ID is "MessageOption5"
    sleep    1s
#   ***** Check First Personal Recruit *****
    Select Checkbox Where ID is "MessageOption6"
    sleep    1s
#   ***** Check First Commission Check *****
    Select Checkbox Where ID is "MessageOption7"
    sleep    1s
#**************************************************
#   ***** Scroll Down 2 *****
    Scroll Page to Location Where Y equals "1300"
    sleep    1s
#   ***** Check Possible 3-3-30in first 30 days *****
    Select Checkbox Where ID is "MessageOption8"
    sleep    1s
#   ***** Check Earned Ring/Watch *****
    Select Checkbox Where ID is "MessageOption9"
    sleep    1s
#   ***** Check Earned Promotion *****
    Select Checkbox Where ID is "MessageOption10"
    sleep    1s
#   ***** Check Made the Leaders Bulletin *****
    Select Checkbox Where ID is "MessageOption11"
    sleep    1s
