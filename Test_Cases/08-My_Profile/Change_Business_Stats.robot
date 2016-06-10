*** Settings ***
Documentation      A test suite to change Associate Business Stats info
...                Author: Isabella Fayner
...                Creation Date: 06/02/2016
...
...                This test will log into MyWFG, open My Profile menu, verify the page
...                and change Associate Business Stats info
Metadata           Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library            Selenium2Library

#Suite Teardown     Close Browser

*** Variables ***
${ELEMENT_ID}        Business Stats
${BUS_PHILOSOPHY}    This is only my Philosophy
${BUS_STYLE}         Legacy
${PREVIOUS_CAREER}   QA Analyst
${STATUS}            Full-Time
${CHANNEL}           GREEN
${LANGUAGE}          Mandarin
${OPEN_TO_MAP}       No
${BUS_STATISTIC}     Yes
${VERIFY_TEXT}       Your Profile was Successfully changed!


*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
#    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep   2s

Go to My Profile Page
    Click My Profile
    sleep    2s
#   click link    xpath=(//a[contains(@href, '/profile')])[2]
    Click Link with ID "myProfile"
    sleep    2s

Verify Webpage and Click Business Stats
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    3s

Click Edit Business Stats button for Cancel
    Click Button using id "businessStats-Edit"
    sleep   1s

Click Cancel button
    Click Button using id "businessStats-TopCancel"
    sleep    1s

Click Edit Business Stats button for Edit
    Click Button using id "businessStats-Edit"
    sleep   1s

Edit Business Philosophy
    Input "${BUS_PHILOSOPHY}" in the "newPhilosophy" Field With ID
    sleep    1s

Edit Business Style List Box
    Show Hidden List Items with ID "newStyle"
	Select from list by label  xpath=//select[@id='newStyle']  ${BUS_STYLE}
	Restore Hidden List Items with ID "newStyle"
    sleep    1s

Edit Previoous Career
    Input "${PREVIOUS_CAREER}" in the "newCareer" Field With ID
    sleep    1s

Edit Status List Box
    Show Hidden List Items with ID "newStatus"
	Select from list by label  xpath=//select[@id='newStatus']  ${STATUS}
	Restore Hidden List Items with ID "newStatus"
    sleep    1s

#*******************************************************************************
Scroll Down 1
    Scroll Page to Location Where Y equals "600"
    sleep    2s

#Edit Channel List Box
#***** This List Box has 3 different scenarious ...
#***** 1. If agent is new, the channel is GREEN by default and test will fail
#***** 2. If channel is the same, different messages appear and test will fail
#***** 3. If channel changed to opposit, the test will go through
#    Click Object Named "Select" with span name
#    Show Hidden List Items with ID "newDivision"
#	 Select from list by label  xpath=//select[@id='newDivision']  ${CHANNEL}
#	 Restore Hidden List Items with ID "newDivision"
#    sleep    1s

Edit Language Spoken
    Input "${LANGUAGE}" in the "newLanguage" Field With ID
    sleep    1s

Edit Open to Map List Box
    Show Hidden List Items with ID "newMap"
	Select from list by label  xpath=//select[@id='newMap']  ${OPEN_TO_MAP}
	Restore Hidden List Items with ID "newMap"
    sleep    1s

Edit Display Business Statistics List Box
    Show Hidden List Items with ID "newStat"
	Select from list by label  xpath=//select[@id='newStat']  ${BUS_STATISTIC}
	Restore Hidden List Items with ID "newStat"
    sleep    1s

Click Save button
    Click Button using id "businessStats-BottomSave"
    sleep    1s

Verify Business Stats Successful Change
    Find "${VERIFY_TEXT}" On Webpage

Go My Profile Page to Log Out
    Click My Profile
    sleep    2s

Log Out of MyWFG
    Log Out of MyWFG

Close opened Browser
    Close Browser

*** Keywords ***
