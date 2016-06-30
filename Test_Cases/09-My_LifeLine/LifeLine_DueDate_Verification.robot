*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine Due date
...               Author: Isabella Fayner
...               Creation Date: 06/22/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and verify \
...               MyWFG LifeLine Due Date
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
${Notification_TypeID}    1
${STATE}
${PROVINCE}

*** Test Cases ***

Select Agent and Login to MyWFG.com
    ${Agent_Info}=    Run Keyword If    ${Notification_ID} in [4, 7, 13]
    ...    Database_Library.Find_LifeLine_Agent    ${Notification_ID}    ${Notification_TypeID}    ${LL_STATE}
    ...    ${HOSTNAME}    ${WFG_DATABASE}
    ...    ELSE IF    ${Notification_ID} == 5
    ...    Database_Library.Find_LifeLine_Agent    ${Notification_ID}    ${Notification_TypeID}    ${PROVINCE}
    ...    ${HOSTNAME}    ${WFG_DATABASE}
    ...    ELSE
    ...    Database_Library.Find_LifeLine_Agent    ${Notification_ID}    ${Notification_TypeID}    ${STATE}
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

#   ***** Get Due Date from the web page
    ${Webpage_DateDue_Str}    Get Text    xpath=//*[@id='DueDate-${Agent_Info[1]}']
    ${DateDue_Length}    Get Length    ${Webpage_DateDue_Str}

#    ***** Convert date to match with database formate
    ${Webpage_DateDue}    Remove String     ${Webpage_DateDue_Str}     (Expired)
    ${Webpage_DateDue}    Replace String    ${Webpage_DateDue}    /    -

    Should be equal    ${Agent_Info[2].strip()}    ${Webpage_DateDue.strip()}

    Run Keyword If    ${Agent_Info[2].strip()} == ${Webpage_DateDue.strip()}
    ...    log    Date Due verification Passed.
    ...    ELSE
    ...    log    Date Due verification Failed.

Log Out of MyWFG
    Log Out of MyWFG

*** Keywords ***

