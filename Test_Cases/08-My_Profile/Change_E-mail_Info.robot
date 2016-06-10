*** Settings ***
Documentation     A test suite to set up or change the agent's email information
...               Author: Isabella Fayner
...               Creation Date: 05/24/2016
...
...               This test will log into MyWFG, open My Profile menu, verify the page
...               and change agents's personal email address
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library

Suite Teardown    Close Browser

*** Variables ***
${ELEMENT_ID}      Contact Settings
${NEW_EMAIL}       first.email@yahoo.com
${VERIFY_TEXT}     Your E-mail Address was successfully changed
${VERIFY_MSG}      Old email address and new email address are the same.

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep   3s

Go to My Profile Page
    Click My Profile
    sleep    2s
    Click Link with ID "myProfile"
    sleep    2s

Verify Webpage and Click Contact Settings
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Scroll Down
    Scroll Page to Location Where Y equals "800"

Click Edit Email button for Cancel
    Click Button using id "btnEmail-Edit"
    sleep   2s

Click Cancel button
    Click Button using id "btn-Email-Cancel"
    sleep    1s

Click Edit Email button for Edit
    Click Button using id "btnEmail-Edit"
    sleep    1s

Change Email address
    Input "${NEW_EMAIL}" in the "txtEmailAddress" Field With ID

Click Save Changes Button
    Click Button using id "btn-Email-Save"
    sleep    1s

Verify Email Change
    Find "${VERIFY_TEXT}" On Webpage

Go My Profile Page to Log Out
    Click My Profile
    sleep    1s

Log Out of MyWFG
    sleep    3s
    Log Out of MyWFG

Close opened Browser
    Close Browser


*** Keywords ***
