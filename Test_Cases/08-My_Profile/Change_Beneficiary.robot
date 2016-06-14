*** Settings ***
Documentation      A test suite to set up or change the agent's designated beneficiary
...                Author: Isabella Fayner
...                Creation Date: 05/23/2016
...
...                This test will log into MyWFG, open My Profile menu, verify the page
...                and set up or change agents's designated beneficiary
Metadata           Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library            Selenium2Library

Suite Teardown     Close Browser

*** Variables ***
${ELEMENT_ID}      Designated Beneficiary
${FIRST NAME}      Isabella
${LAST NAME}       Nguen
${PHONE}           6786659444
${RELATIONSHIP}    Sister
${ADDRESS 1}       12 Main Street
${ADDRESS 2}       APT. A25
${COUNTRY}         US
${STATE}           NY
${CITY}            New York
${ZIP}             30011
${VERIFY_TEXT}     Your designated beneficiary information was successfully changed


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

Verify Webpage and Click Designated Beneficiary
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Edit Designated Beneficiary button for Cancel
    Click Button using id "designated-beneficiary-Edit"
    sleep   3s

Click Cancel button
    Click Button using id "designated-beneficiary-CancelTop"
    sleep    3s

Click Edit Designated Beneficiary button for Edit
    Click Button using id "designated-beneficiary-Edit"
    sleep   3s

Change Beneficiary First Name
    Input "${FIRST NAME}" in the "txtFirstName" Field With ID
    sleep    1s

Change Beneficiary Last Name
    Input "${LAST NAME}" in the "txtLastName" Field With ID
    sleep    1s

Scroll Down
    Scroll Page to Location Where Y equals "800"

Change Beneficiary Phone
    Input "${PHONE}" in The "txtPhone" Field With ID
    sleep    1s

Change Benenficiary Relationship#
    Input "${RELATIONSHIP}" in The "txtRelationship" Field With ID
    sleep    1s

Change Beneficiary Address 1
    Input "${ADDRESS 1}" in the "txtAddress1" Field With ID
    sleep    1s

Change Beneficiary Address 2
    Input "${ADDRESS 2}" in the "txtAddress2" Field With ID
    sleep    1s

Change Beneficiary Country
     Show Hidden List Items with ID "ddlCountry"
	 Select from list by label  xpath=//select[@id='ddlCountry']  ${COUNTRY}
	 Restore Hidden List Items with ID "ddlCountry"
     sleep  3s

Change Beneficiary State
     Show Hidden List Items with ID "ddlStates"
	 Select from list by label  xpath=//select[@id='ddlStates']  ${STATE}
	 Restore Hidden List Items with ID "ddlStates"
     sleep    1s

Change Beneficiary City
    Input "${CITY}" in The "txtCity" Field With ID
    sleep    1s

Change Beneficiary Zip Code
    Input "${ZIP}" in The "txtZip" Field With ID
    sleep    1s

Click Save Changes Button
    Click Button using id "designated-beneficiary-SaveBottom"
    sleep    2s

Verify Beneficiary Change
    Find "${VERIFY_TEXT}" On Webpage

Log Out of MyWFG
    sleep    2s
    Log Out of MyWFG

Close opened Browser
    Close Browser

*** Keywords ***
