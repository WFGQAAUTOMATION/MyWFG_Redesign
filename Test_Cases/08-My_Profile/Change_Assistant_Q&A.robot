*** Settings ***
Documentation     A test suite to change the Assistant Q&A
...               Author: Isabella Fayner
...               Creation Date: 05/27/2016
...
...               This test will log into MyWFG, open My Profile menu, verify the page
...               and change the Assistant Q&A
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library

#Suite Teardown    Close Browser

*** Variables ***

${ELEMENT_ID}       Account Administration
${NEW_ASSIST_Q}     Who is this
${NEW_ASSIST_A}     This is me
${VERIFY_TEXT}      Your security question and answer has been changed successfully
${LINK_href}        Wfg.MyWfgLogin/Account/PassOrQNA

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep    1s

Go to My Profile Page
    Go To My Profile
    sleep    2s

Verify Webpage and Click Account Administration
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Account Administration Link to Change Assistant Q&A
    Click Link with "${LINK_href}"
    sleep    2s

Select Radio Button
    select radio button    SelectionType    2
    sleep    2s

Click Submit button
    Click Button using id "btnSubmit"
    sleep    2s

Enter Current MyWFG.com Password
    Input "${VALID_PASSWORD}" in the "wfgonlinepassword" Field With ID
    sleep    1s

Enter New Assistant Question
    Input "${NEW_ASSIST_Q}" in the "AssistantQuestion" Field With ID
    sleep    1s

Confirm New Assistant Question
    Input "${NEW_ASSIST_Q}" in the "AssistantQuestionConfirm" Field With ID
    sleep    1s

Enter New Assistant Answer
    Input "${NEW_ASSIST_A}" in the "AssistantAnswer" Field With ID
    sleep    1s

Confirm New Assistant Answer
    Input "${NEW_ASSIST_A}" in the "AssistantAnswerConfirm" Field With ID
    sleep    1s

Click Create Assistant Q&A
    Click Button using id "btnCreateAssistant"
    sleep    1s

Verify Assistant Q&A Change
    Find "${VERIFY_TEXT}" On Webpage
    sleep    1s

Click Return to Settings button
    Click Link With Name Contained "Return to Settings"
    sleep    2s

Log Out of MyWFG
    sleep    2s
    Log Out of MyWFG

Close opened Browser
    Close Browser

*** Keywords ***

