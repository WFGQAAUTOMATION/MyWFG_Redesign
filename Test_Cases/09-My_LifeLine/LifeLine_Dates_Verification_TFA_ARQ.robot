*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine TFA Annual Registration Questionaire Expiration dates
...               Author: Isabella Fayner
...               Creation Date: 06/21/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and verify that
...               MyWFG  TFA Annual Registration Questionaire notifications are displayed
...               according to dates
Metadata          Version   0.1
Resource          C:/Github_Projects/MyWFG_Redesign/Resources/Resource_Login.robot
Resource          C:/Github_Projects/MyWFG_Redesign/Resources/Resource_Webpage.robot
Library           C:/Github_Projects/MyWFG_Redesign/Resources/Testing_Library.py
Library           C:/Github_Projects/MyWFG_Redesign/Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary
Library           String
Library           DateTime

Suite Teardown     Close Browser

*** Variables ***

${Notification_ID}        24
${Notification_TypeID}    1
${STATE}

*** Test Cases ***

Select Agent and Login to MyWFG.com and Check LifeLine
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
    sleep    3s
    ${Webpage_DateDue}    Get Text    xpath=//*[@id='DueDate-${Agent_Info[1]}']

#    ***** Convert date to match with database formate
    ${Webpage_DateDue}    Remove String     ${Webpage_DateDue}     (Expired)
    ${Webpage_DateDue}    Replace String    ${Webpage_DateDue}    /    -

    Should be equal    ${Agent_Info[2].strip()}    ${Webpage_DateDue.strip()}

    ${Today_Date}    Get Current Date
    ${Dates_Diff}    Subtract Date From Date    ${Agent_Info[3]}    ${Today_Date}
#   ***** Convert Dates difference from sec into min then into hours and into days.
    ${Dates_Diff}    Evaluate    ${Dates_Diff}/60/60/24
    log    Days difference is ${Dates_Diff}

    Run Keyword If     ${Notification_TypeID} == 1 and ${Dates_Diff} > 15
    ...    log    TFA Annual Registration Questionaire Red notification was displayed too early
    ...    ELSE IF     ${Notification_TypeID} == 1 and ${Dates_Diff} <= 15
    ...    log    TFA Annual Registration Questionaire Red notification test Passed

    Run Keyword If    ${Notification_TypeID} == 2 and ${Dates_Diff} <= 15
    ...    log    TFA Annual Registration Questionaire Yellow notification should be a Red notification
    ...    ELSE IF    ${Notification_TypeID} == 2 and ${Dates_Diff} > 60
    ...    log    TFA Annual Registration Questionaire Yellow notification was displayed too early
    ...    ELSE IF    ${Notification_TypeID} == 2 and ${Dates_Diff} > 15
    ...    log    TFA Annual Registration Questionaire Yellow notification test Passed

    Run Keyword If    ${Notification_TypeID} == 3
    ...    log    Green Notification will be tested in separate component 'Green Notification Expiration'


Log Out of MyWFG
    Log Out of MyWFG

*** Keywords ***

