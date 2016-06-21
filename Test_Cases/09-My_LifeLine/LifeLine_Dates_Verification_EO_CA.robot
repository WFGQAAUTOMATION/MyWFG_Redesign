*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine E&O Expiration dates for Canada
...               Author: Isabella Fayner
...               Creation Date: 06/17/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and verify that MyWFG
...               LifeLine E&O notification for Canada is displayed according to expiration dates
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

${Notification_ID}        27
${Notification_TypeID}    1
${STATE}

*** Test Cases ***

Connect to Database
    Connect To Database Using Custom Params    pymssql    host='${HOSTNAME}', database='${WFG_DATABASE}'

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
#   This is for E&O dates verifications only
    ${NoticeID}    query    SELECT Top 1 NoticeID FROM [WFGWorkFlow].[dbo].[Agent_EandO_Collections] WHERE AgentID = '${Agent_Info[0]}' ORDER BY OpenDate Desc;

    ${Webpage_DateDue_Str}    Get Text    xpath=//*[@id='DueDate-${Agent_Info[1]}']
    ${DateDue_Length}    Get Length    ${Webpage_DateDue_Str}

#    ***** Convert date to match with database formate
    ${Webpage_DateDue}    Remove String     ${Webpage_DateDue_Str}     (Expired)
    ${Webpage_DateDue}    Replace String    ${Webpage_DateDue}    /    -

    Should be equal    ${Agent_Info[2].strip()}    ${Webpage_DateDue.strip()}

    ${Today_Date}    Get Current Date
    ${Dates_Diff}    Subtract Date From Date    ${Agent_Info[3]}    ${Today_Date}
#   ***** Convert Dates difference from sec into min then into hours and into days.
    ${Dates_Diff}    Evaluate    ${Dates_Diff}/60/60/24
    log    Days difference is ${Dates_Diff}

    Run Keyword If    ${Notification_TypeID} == 1 and ${DateDue_Length} > 12
    ...    log    (Expired) verbiage should NOT be added to the Due Date

    Run Keyword If     ${Notification_TypeID} == 1 and ${NoticeID[0][0]} in [3, 5, 6]
    ...    log    E&O Red Notification Test with NoticeID = ${NoticeID[0][0]} Passed
    ...    ELSE IF    ${Notification_TypeID} == 1
    ...    log    This E&O LifeLine task with NoticeID = ${NoticeID[0][0]} should NOT be in Red Notification

    Run Keyword If    ${Notification_TypeID} == 2 and ${NoticeID[0][0]} in [1, 2, 4]
    ...    log    E&O Yellow Notification Test with NoticeID = ${NoticeID[0][0]} Passed
    ...    ELSE IF    ${Notification_TypeID} == 2
    ...    log    This E&O LifeLine task with NoticeID = ${NoticeID[0][0]} should NOT be in Yellow Notification

    Run Keyword If    ${Notification_TypeID} == 3
    ...    log    Green Notification will be tested in separate component 'Green Notification Expiration'

Log Out of MyWFG
    Log Out of MyWFG

Disconnect from SQL Server
    Disconnect From Database

*** Keywords ***
