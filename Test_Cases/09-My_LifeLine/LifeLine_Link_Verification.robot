*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine Links for each Life Line task
...               Author: Isabella Fayner
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and
...               verifies each  MyWFG LifeLine Link separately
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           ../../Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary
Library           String
Library           DateTime

Suite Teardown    Close Browser

*** Variables ***

${Notification_ID}        9
${Notification_TypeID}    1
${STATE}

*** Test Cases ***

Select Agent, Login to MyWFG.com, verify the LifeLine Link
    ${Agent_Info}    Database_Library.Find_LifeLine_Agent    ${Notification_ID}    ${Notification_TypeID}    ${STATE}
    ...    ${HOSTNAME}    ${WFG_DATABASE}
    Browser is opened to login page
    User "${Agent_Info[0]}" logs in with password "${VALID_PASSWORD}"
    Home Page for any Agent Should Be Open
    sleep    2s
    Verify A Link Named "Business" Is On The Page
    sleep    2s

    Set Suite Variable    ${Agent_Info}

Click My Business button
    Click Link with ID "myBusinessTabDesktop"
    sleep    2s

Click My Life Line button
    Click element using href "/Wfg.MyLifeline"
    sleep    2s
    Click element    xpath=//a[@id='Notice-${Agent_Info[1]}']
    sleep    5s

Log Out of MyWFG
    Log Out of MyWFG

*** Keywords ***