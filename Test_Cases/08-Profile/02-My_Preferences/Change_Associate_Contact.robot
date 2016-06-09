*** Settings ***
Documentation     A test suite to change the associate contact
...               Author: Isabella Fayner
...               Creation Date: 05/22/2016
...
...               This test will log into MyWFG, open My Profile menu, verify the page
...               and changes Associate Contact information
Metadata          Version   0.1
Resource          ../../../Resources/Resource_Login.robot
Resource          ../../../Resources/Resource_Webpage.robot
Library           ../../../Resources/Testing_Library.py
Library           ../../../Resources/MyLibrary.py
Library           Selenium2Library

#Suite Teardown     Close Browser

*** Variables ***
${ELEMENT_ID}      Contact Settings
${ADDRESS}         1234 Main Street
${CITY}            Duluth
${STATE}           CO
${ZIP}             30309
${VERIFY_TEXT}     Thank you for submitting your home address change

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep   2s

Go to My Profile Page
    Go To My Profile
    sleep    5s

Verify Webpage and Click Contact Settings
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Edit Contact Settings button for Cancel
    Click Button using id "btnContact-Edit"
    sleep   3s

Click Cancel button
    Click Button using id "btn-Contact-Cancel"
    sleep    3s

Click Edit Contact button for Edit
    Click Button using id "btnContact-Edit"
    sleep   3s

Change Associate Contact Home Address
    Input "${ADDRESS}" in the "txtAddress1" Field With ID
    sleep    1s

Change Associate Contact City
    Input "${CITY}" in The "txtCity" Field With ID
    sleep    2s

Change Associate Contact Zip Code
    Input "${ZIP}" in The "txtZip" Field With ID
    sleep    2s

Change Associate Contact State by Name
	Show Hidden List Items with ID "ddlStates"
	select from list by label  xpath=//select[@id='ddlStates']  ${STATE}
	Restore Hidden List Items with ID "ddlStates"

Click Save Changes Button
    Click Button using id "btn-Contact-Save"
    sleep    2s

Verify Associate Contact Change
    Find "${VERIFY_TEXT}" On Webpage

Go My Profile Page to Log Out
    Go To My Profile
    sleep    2s

Log Out of MyWFG
    Log Out of MyWFG

Close opened Browser
    Close Browser


*** Keywords ***

