*** Settings ***
Documentation     A test suite to click MyWFG LifeLine Archive, verify the message and close Archive
...               Author: Isabella Fayner
...               Creation Date: 06/06/2016
...
...               This test will log into MyWFG, click My Business button, click My LifeLine,
...               click Archive link, verify the message and close Archive
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library
Library           DatabaseLibrary

Suite Teardown    Close Browser

*** Variables ***

*** Test Cases ***
Connect to Database
    Connect To Database Using Custom Params    pymssql    host='${HOSTNAME}', database='${WFG_DATABASE}'

Select Agent and Login to MyWFG.com
    ${AgentID}    query    SELECT Top 1 AgentID FROM [WFGOnline].[dbo].[WFGLLNotifications] WHERE NotificationID = 1;
    ${AgentCodeNo}    query    SELECT AgentCodeNumber FROM [WFGCompass].[dbo].[agAgent] WHERE AgentID = $ ${AgentID[0][0]};
    Given browser is opened to login page
    When user "${AgentCodeNo[0][0]}" logs in with password "${VALID_PASSWORD}"
    Then Home Page for any Agent Should Be Open
    Verify A Link Named "Business" Is On The Page
    sleep   3s

Click My Business button
    Click Link with ID "myBusinessTabDesktop"
    sleep    2s

Click My Life Line button
    Click element using href "/Wfg.MyLifeline"
    sleep    3s

Click Archive Question Image using id
    Click Link With Name Contained "?"
    sleep    2s

Click Archive Image
    Click Link with ID "linkArchive"
    sleep    2s

Go My Profile Page to Log Out
    Click My Profile
    sleep    1s

Log Out of MyWFG
    Log Out of MyWFG
    sleep    1s

Close opened Browser
    Close Browser

Disconnect from SQL Server
    Disconnect From Database


*** Keywords ***




