*** Settings ***
Documentation     A test suite to change the Recognition Settings
...               Author: Isabella Fayner
...               Creation Date: 05/25/2016
...
...               This test will log into MyWFG, open My Prfile menu, verify the page
...               and set up or change Recognition Settings
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library
Force Tags        Dev_Sanity

Suite Teardown    Close Browser

*** Variables ***

${ELEMENT_ID}          Recognition Settings
${RECOGNITION NAME}    Isabella & Roman
${VERIFY_TEXT}         Your recognition settings was successfully changed

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

Verify Webpage and Click Recognition Settings
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Edit Recognition Settings for Cancel
    Click Button using id "recognitionSettings-Edit"
    sleep   2s

Click Cancel button
    Click Button using id "recognitionSettings-CancelTop"
    sleep    2s

Click Edit Recognition Settings button for Edit
    Click Button using id "recognitionSettings-Edit"
    sleep   2s

Change Recognition Settings number
    Input "${RECOGNITION NAME}" in the "txtRecognitionName" Field With ID
    sleep    1s

Click Save Changes Button
    Click Button using id "recognitionSettings-SaveTop"
    sleep    1s

Verify Recognition Settings
    Find "${VERIFY_TEXT}" On Webpage
    sleep    1s

Go My Profile Page to Log Out
    Click My Profile
    sleep    1s

Log Out of MyWFG
    sleep    2s
    Log Out of MyWFG

Close opened Browser
    Close Browser

*** Keywords ***
