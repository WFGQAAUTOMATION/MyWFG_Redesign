*** Settings ***
Documentation     A test suite to change the agent's phone numbers
...               Author: Isabella Fayner
...               Creation Date: 05/24/2016
...
...               This test will log into MyWFG, open My Profile menu, verify the page
...               and change Associate's phone numbers
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           String

Suite Teardown    Close Browser

*** Variables ***

${ELEMENT_ID}           Contact Settings
${HOME_PHONE}           770
${CELL_PHONE}           4049876543
${VERIFY_TEXT}          Your phones were successfully changed
${PHONE_WARNING_MSG}    phone must be a 10 digit number

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep   3s

Go to My Profile Page
    Go To My Profile
    sleep    2s

Verify Webpage and Click Contact Settings
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Edit Phones button for Cancel
    Click Button using id "btnPhones-Edit"
    sleep   1s

Click Cancel button
    Click Button using id "btn-Phones-Cancel"
    sleep    1s

Click Edit Phones button for Edit
    Click Button using id "btnPhones-Edit"
    sleep   1s

Change Home Phone number
    Input "${HOME_PHONE}" in the "txtHomePhone" Field With ID
    sleep    1s

Change Cell Phone number
    Input "${CELL_PHONE}" in the "txtCellPhone" Field With ID
    sleep    1s

Click Save Changes Button
    Click Button using id "btn-Phones-Save"
    ${PHONE_WARNING} =  Run Keyword And Return Status    Element Should Be Visible   id=associate-contact-error
    sleep    1s
    Run Keyword If    ${PHONE_WARNING}
    ...    Find "${PHONE_WARNING_MSG}" On Webpage
    Run Keyword If    ${PHONE_WARNING}
    ...    Click Button using id "btn-Phones-Cancel"
    ...    ELSE
    ...    Find "${VERIFY_TEXT}" On Webpage
    sleep    2s

Verify Phone Change
    Find "${VERIFY_TEXT}" On Webpage

Log Out of MyWFG
    sleep    3s
    Log Out of MyWFG

Close opened Browser
    Close Browser


*** Keywords ***
