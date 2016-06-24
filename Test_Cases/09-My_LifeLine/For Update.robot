*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine Annuity Course Expiration dates
...               Author: Isabella Fayner
...               Creation Date: 06/23/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline and verify that MyWFG
...               LifeLine Annuity Course notification is displayed according to expiration dates

Resource          C:/Github_Projects/MyWFG_Redesign/Resources/Resource_Login.robot
Resource          C:/Github_Projects/MyWFG_Redesign/Resources/Resource_Webpage.robot
Library           C:/Github_Projects/MyWFG_Redesign/Resources/Testing_Library.py
Library           C:/Github_Projects/MyWFG_Redesign/Resources/Database_Library.py

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



