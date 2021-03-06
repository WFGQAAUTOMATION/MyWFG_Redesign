*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine CA Agency Agreement Expiration dates
...               Author: Isabella Fayner
...               Creation Date: 06/17/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and verify that MyWFG
...               LifeLine CA Agency Agreement notifications are displayed according to expiration dates
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           ../../Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary
Library           String
Library           DateTime

Suite Teardown     Close Browser

*** Variables ***

${Notification_ID}        22
${Notification_TypeID}    1
${Agent_ID}               919824
${Date_Due}               2016-12-31 11:22:33.444
${Modified}               2016-07-01 12:34:56.789
${URL}                    1
${STATE}

*** Test Cases ***

Select Agent and Login to MyWFG.com and Check LifeLine

   ${Agent_Info}    Database_Library.Find_LifeLine_Agent    ${Notification_ID}    ${Notification_TypeID}
    ...    ${STATE}    ${HOSTNAME}    ${WFG_DATABASE}

    ${AgentNo}=    Get Length    ${Agent_Info[0]}

    Run Keyword If    ${AgentNo} < 4    Insert Temp Record Into LL_Notifications Table
    sleep    2s
    ${Agent_Info}    Database_Library.Find_LifeLine_Agent    ${Notification_ID}    ${Notification_TypeID}
    ...    ${STATE}    ${HOSTNAME}    ${WFG_DATABASE}

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
    ...    log    Canada Agency Agreement Red notification was displayed too early
    ...    ELSE IF     ${Notification_TypeID} == 1 and ${Dates_Diff} <= 15
    ...    log    Canada Agency Agreement Red notification test Passed

    Run Keyword If    ${Notification_TypeID} == 2 and ${Dates_Diff} <= 15
    ...    log    Canada Agency Agreement Yellow notification should be a Red notification
    ...    ELSE IF    ${Notification_TypeID} == 2 and ${Dates_Diff} > 60
    ...    log    Canada Agency Agreement Yellow notification was displayed too early
    ...    ELSE IF    ${Notification_TypeID} == 2 and ${Dates_Diff} > 15
    ...    log    Canada Agency Agreement Yellow notification test Passed

    Run Keyword If    ${Notification_TypeID} == 3
    ...    log    Green Notification will be tested in separate component 'Green Notification Expiration'


Log Out of MyWFG
    Log Out of MyWFG

*** Keywords ***

Insert Temp Record Into LL_Notifications Table

#******* This record will be inserted if there is no data for a specific Life Line task.
#******* It will be deleted within 1 hour when "WFG Notifications" job runs in Model.

    Database_Library.Insert_Temp_Agent    ${Agent_ID}    ${Notification_ID}    ${STATE}    ${Notification_TypeID}
    ...    ${Date_Due}    ${Modified}    ${URL}    ${HOSTNAME}    ${WFG_DATABASE}

browser is opened to login page
	Open Browser
	...     ${LOGIN_URL}
	...     browser=${Browser}
	...     alias=None
	...     remote_url=http://161.179.241.85:4444/wd/hub
	...     ff_profile_dir=${FF_PROFILE}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Login Page Should Be Open