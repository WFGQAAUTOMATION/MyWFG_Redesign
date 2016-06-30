*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine IUL Course Expiration dates
...               Author: Isabella Fayner
...               Creation Date: 06/20/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and verify
...               that MyWFG LifeLine IUL Course is displayed according to expiration dates
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

${Notification_ID}        11
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
    Run Keyword If    ${Notification_TypeID} == 1
    ...    Should be equal    Immediately    ${Webpage_DateDue.strip()}
    Run Keyword If    ${Notification_TypeID} == 1
    ...    log    IUL Course Red notification test Passed
    ...    ELSE IF    ${Notification_TypeID} == 2
    ...    log    IUL Course should never be displayed in Yellow notification!
    ...    ELSE IF    ${Notification_TypeID} == 3
    ...    log    Green Notification will be tested in separate component 'Green Notification Expiration'

Log Out of MyWFG
    Log Out of MyWFG

*** Keywords ***

Insert Temp Record Into LL_Notifications Table

#******* This record will be inserted if there is no data for a specific Life Line task.
#******* It will be deleted within 1 hour when "WFG Notifications" job runs in Model.

    Database_Library.Insert_Temp_Agent    ${Agent_ID}    ${Notification_ID}    ${STATE}    ${Notification_TypeID}
    ...    ${Date_Due}    ${Modified}    ${URL}    ${HOSTNAME}    ${WFG_DATABASE}