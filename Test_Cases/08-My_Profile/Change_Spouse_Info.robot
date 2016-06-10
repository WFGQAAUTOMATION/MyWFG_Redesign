*** Settings ***
Documentation     A test suite to add or change the Spouse Info
...               Author: Isabella Fayner
...               Creation Date: 05/25/2016
...
...               This test will log into MyWFG, open My Profile menu, verify the page
...               and add or change the Spouse Info
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library

Suite Teardown    Close Browser

*** Variables ***

${ELEMENT_ID}            Spouse Info
${SPOUSE_AGENT_NO}
${SPOUSE_FIRST_NAME}     SHARMILA
${SPOUSE_COMMON_NAME}    MILA
${SPOUSE_LAST_NAME}      CHEN
${VERIFY_TEXT}           Your spouse information was successfully changed

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

Verify Webpage and Click Spouse Info
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Edit Spouse Info button for Cancel
    Click Button using id "spouse-info-Edit"
    sleep    2s

Click Cancel button
    Click Button using id "spouse-info-CancelBottom"
    sleep    2s

Click Edit Spouse Info button for Edit
    Click Button using id "spouse-info-Edit"
    sleep    2s

Change Spouse First name
    Input "${SPOUSE_FIRST_NAME}" in the "txtFirstName" Field With ID
    sleep    1s

Change Spouse Common name
    Input "${SPOUSE_COMMON_NAME}" in the "txtCommonName" Field With ID
    sleep    1s

Change Spouse Last name
    Input "${SPOUSE_LAST_NAME}" in the "txtLastName" Field With ID
    sleep    1s

Click Save Changes Button
    Click Button using id "spouse-info-SaveBottom"
    sleep    1s

Verify Spouse Info Settings
    Find "${VERIFY_TEXT}" On Webpage
    sleep    2s

Go My Profile Page to Log Out
    Click My Profile
    sleep    1s

Log Out of MyWFG
    sleep    2s
    Log Out of MyWFG

Close opened Browser
    Close Browser

*** Keywords ***

