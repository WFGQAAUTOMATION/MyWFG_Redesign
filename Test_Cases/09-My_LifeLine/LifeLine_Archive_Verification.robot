*** Settings ***
Documentation     A test suite to view archived notifications and verify Dismiss Dates in Archive
...               Author: Isabella Fayner
...               Creation Date: 06/07/2016
...
...               This test will log into MyWFG, click My Business button, click My LifeLine, click
...               Archive link, verify  dismissed notifications and Dismiss Dates, and closes Archive
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

Suite Teardown    Close Browser

*** Variables ***

${Notification_ID}    4
${Dismiss_Index}      1
${Dismiss_Task}       Yes
${Agent_Info}

*** Test Cases ***

Select Agent, Login to MyWFG.com, Check Dismiss Notifications
    ${Agent_Info}    Database_Library.Get_lifeline_dismiss_notification_agent    ${Notification_ID}    ${HOSTNAME}
    ...    ${WFG_DATABASE}
    Browser is opened to login page
    User "${Agent_Info[0]}" logs in with password "${VALID_PASSWORD}"
    Home Page for any Agent Should Be Open
    sleep   3s
    Verify A Link Named "Business" Is On The Page
    sleep   3s

    Set Suite Variable    ${Agent_Info}

Click My Business button
    Click Link with ID "myBusinessTabDesktop"
    sleep    2s

Click My Life Line button
    Click element using href "/Wfg.MyLifeline"
    sleep    3s

Click Archive Question Image using id
    Click Link With Name Contained "?"
    sleep    2s

Verify Dismissed/Archived items
    Run Keyword If    ${Notification_ID} not in [4, 5, 6, 7]
    ...    log    Dismiss Reason doesn't exist for LifeLine Task " & ${NotificationID}
    Run Keyword If    ${Notification_ID} in [4, 5, 6, 7] and '${Dismiss_Task}' == 'No'
    ...    Confirm No to Dismiss for htmlID - ${Agent_Info[1]} and Dismiss Index - ${Dismiss_Index}
    ...    ELSE IF    ${Notification_ID} in [4, 5, 6, 7] and '${Dismiss_Task}' == 'Yes'
    ...    Confirm Yes to Dismiss for htmlID - ${Agent_Info[1]} and Dismiss Index - ${Dismiss_Index}
    ...    ELSE
    ...    log    I am in ELSE section for some reason

Click Archive Image
    sleep    2s
    Click Link with ID "linkArchive"
    sleep    2s

    # **************Check if the Due Date of the archived notification is correct*****
    #************Check if the Date when notification was archived  is correct. -->
    #-->Eliminate "Dismissed..." verbiage from the Dismiss Date statemet**************
    #************Check if the correct Dismiss reason was passed to Archive*************

Go My Profile Page to Log Out
    Click My Profile
    sleep    1s

Log Out of MyWFG
    Log Out of MyWFG
    sleep    1s

Close opened Browser
    Close Browser


*** Keywords ***
Confirm No to Dismiss for htmlID - ${htmlID} and Dismiss Index - ${Index}
    Click Object Named "Select dismiss reason" with span name
    sleep    1s
    Show Hidden List Items with ID "selDismissReason-${Agent_Info[1]}"
    Click Archive List Box With ID "selDismissReason-${Agent_Info[1]}" and select by index "${Dismiss_Index}"
    Restore Hidden List Items with ID "selDismissReason-${Agent_Info[1]}"
    sleep    2s
    Click Element with ID "myModalPopup-close" and class "btn-wfg btn-gray two-column-btn-block"
    log    Dismiss_Task is No

Confirm Yes to Dismiss for htmlID - ${htmlID} and Dismiss Index - ${Index}
#    Click Object Named "Select dismiss reason" with span name
    sleep    1s
    Show Hidden List Items with ID "selDismissReason-${Agent_Info[1]}"
    Click Archive List Box With ID "selDismissReason-${Agent_Info[1]}" and select by index "${Dismiss_Index}"
    Restore Hidden List Items with ID "selDismissReason-${Agent_Info[1]}"
    sleep    2s
    Click Element with ID "myModalPopup-close" and class "btn-wfg btn-primary two-column-btn-block"
    sleep    1s
    Click Element with ID "myModalPopup-close" and class "btn-wfg btn-primary btn-block"
    log    Dismiss_Task is Yes

