*** Settings ***
Documentation    A test suite to set up or cancel electronic 1099-MISC
...               Author: Isabella Fayner
...               Creation Date: 05/26/2016
...
...               This test will log into MyWFG, open My Profile menu, verify the page
...               and Opt_In/Opt-Out for electronic 1099-MISC
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library

Suite Teardown    Close Browser
Force Tags        Dev_Sanity


*** Variables ***

${ELEMENT_ID}         Electronic 1099-Misc
${DISCLOSURE_LINK}    Click here to view the Disclosure
${VERIFY_TEXT}        You have not Opted-In to receive your 1099-MISC electronically

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep    2s

#Go to My Profile Page
#    Click My Profile
#    sleep    2s
#    Click Link with ID "myProfile"
#    sleep    2s

Go to My Profile Page
    Go To My Profile
    sleep    2s

Verify Webpage and Click Electronic 1099-Misc
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s
    Verify A Link Named "${DISCLOSURE_LINK}" Is On The Page
    sleep    2s

Run Opt In
    ${passed} =     run keyword and return status    Click button using id "btnElectronic-1099-OptIn"
    ${button_option} =    check_opt_in_option    ${passed}

    Run Keyword If    "${button_option}" == "Enabled"
    ...    Check Disclosure Options from Link
    Run Keyword If    "${button_option}" == "Enabled"
    ...    Check Disclosure Options from Button
    Run Keyword If    "${button_option}" == "Enabled"
    ...    Click Button using id "btnElectronic-1099-OptIn"
    Run Keyword If    "${button_option}" == "Enabled"
    ...    Run Enabled Case

Run Opt Out
    Click Button using ID "btnElectronic-1099-OptOut"
    sleep    2s
    Click Element with ID "myModalPopup-close" and class "btn-wfg btn-block btn-gray"
    sleep    2s
    Click Button using ID "btnElectronic-1099-OptOut"
    sleep    2s
    Click Element with ID "myModalPopup-close" and class "btn-wfg btn-block btn-primary"
    sleep    2s

Verify Opt-In Opt-Out Settings
    Find "${VERIFY_TEXT}" On Webpage
    sleep    1s

Log Out of MyWFG
    sleep    2s
    Log Out of MyWFG

Close opened Browser
    Close Browser

*** Keywords ***

Check Disclosure Options from Link
    Click link with name contained "${DISCLOSURE_LINK}"
    sleep    1s
    Scroll Page to Location Where Y equals "450"
    sleep    1s
    Click Button using id "btnDisagree"
    sleep    1s
    Scroll Page to Location Where Y equals "0"
    sleep    1s

Check Disclosure Options from Button
    Click Button using id "btnElectronic-1099-OptIn"
    sleep    1s
    Scroll Page to Location Where Y equals "450"
    sleep    1s
    Click Button using id "btnDisagree"
    sleep    1s
    Scroll Page to Location Where Y equals "0"
    sleep    1s

Run Enabled Case
    sleep   1s
    Scroll Page To Location    0    450
    Click Button using id "btnAgree"
    sleep   2s

