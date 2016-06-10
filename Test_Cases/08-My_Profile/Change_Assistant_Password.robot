*** Settings ***
Documentation     A test suite to change the Assistant Password
...               Author: Isabella Fayner
...               Creation Date: 05/26/2016
...
...               This test will log into MyWFG, open My Profile menu, verify the page
...               and change the Assistant Password
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library

#Suite Teardown    Close Browser

*** Variables ***

${ELEMENT_ID}       Account Administration
${NEW_ASSIST_PWD}   assistpswd
${VERIFY_TEXT}      Your password has been changed successfully
${LINK_href}        Wfg.MyWfgLogin/Account/PassOrQNA

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep    1s

Go to My Profile Page
    Click My Profile
    sleep    2s
#   click link    xpath=(//a[contains(@href, '/profile')])[2]
    Click Link with ID "myProfile"
    sleep    2s

Verify Webpage and Click Account Administration
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Account Administration Link to Change Assistant Password
    Click Link with "${LINK_href}"
    sleep    3s

Click Submit button
    Click Button using id "btnSubmit"
    sleep    2s

Enter Current MyWFG.com Password
    Input "${VALID_PASSWORD}" in the "wfgonlinepassword" Field With ID
    sleep    1s

Enter New Assistant Password
    Input "${NEW_ASSIST_PWD}" in the "assistantPassword" Field With ID
    sleep    1s

Confirm New Assistant Password
    Input "${NEW_ASSIST_PWD}" in the "assistantpasswordconfirm" Field With ID
    sleep    1s

Click Create Assistant Password
    Click Button using id "btnCreateAssistantPassword"
    sleep    1s

Verify Assistant Password Change
    Find "${VERIFY_TEXT}" On Webpage
    sleep    1s

Click Return to Settings button
    Click Link With Name Contained "Return to Settings"
    sleep    2s

Go My Profile Page to Log Out
    Click My Profile
    sleep    2s

Log Out of MyWFG
    sleep    2s
    Log Out of MyWFG

Close opened Browser
    Close Browser

*** Keywords ***

