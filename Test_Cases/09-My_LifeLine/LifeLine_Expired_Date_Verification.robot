*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine Expired date
...               Author: Isabella Fayner
...               Creation Date: 06/22/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and verify that
...               MyWFG LifeLine Expired date is shown correctly
...
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

${Notification_ID}        4
${Notification_TypeID}    2
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
    ${Webpage_DateDue_Str}    Get Text    xpath=//*[@id='DueDate-${Agent_Info[1]}']
    ${DateDue_Length}    Get Length    ${Webpage_DateDue_Str}

    ${Expired_Date}    Fetch From Right    ${Webpage_DateDue_Str}    (
    ${Today_Date}    Get Current Date

    ${Dates_Diff}    Run Keyword If    ${Notification_ID} not in [11, 12]
    ...    Subtract Date From Date    ${Agent_Info[3]}    ${Today_Date}

#   ***** Convert Dates difference from sec into min then into hours and into days.
    ${Dates_Diff}    Run Keyword If    ${Notification_ID} not in [11, 12]
    ...    Evaluate    ${Dates_Diff}/60/60/24

#   ***** IUL Course and Annuity Course don't display the date, display "Immediately" instead
#   ***** License Renewal LifeLine notifications always "Expired" in Red
    Run Keyword If    ${Notification_TypeID} == 2
    ...    log    Expired Date Verification is not applicable for NotificationID = 2
    ...    ELSE IF    ${Notification_ID} in [11, 12] and '${Webpage_DateDue_Str.strip()}' == 'Immediately'
    ...    log    Expired Date Due verification Passed for IUL or Annuity Courses
    ...    ELSE IF    ${Notification_ID} in [4, 5] and '${Expired_Date}' == 'Expired)'
    ...    log    Expired Date Due verification Passed for License Renewal
    ...    ELSE IF    ${Notification_ID} in [2,3,6,7,9,10,13,23,25] and ${Dates_Diff} <= 0 and ${DateDue_Length} > 12
    ...    log    1 Expired Date Due verification Passed for AMLR or AMLC or LTCR or IRS 8233 or App/Aff Renewal
    ...    ELSE IF    ${Notification_ID} in [2,3,6,7,9,10,13,23,25] and ${Dates_Diff} > 0 and ${DateDue_Length} < 12
    ...    log    2 Expired Date Due verification Passed for AMLR or AMLC or LTCR or IRS 8233 or App/Aff Renewal
    ...    ELSE IF     ${Notification_TypeID} == 1
    ...    log    Expired Date Due verification Passed
    ...    ELSE
    ...    log    Didn't identify any option

Log Out of MyWFG
    Log Out of MyWFG

*** Keywords ***
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