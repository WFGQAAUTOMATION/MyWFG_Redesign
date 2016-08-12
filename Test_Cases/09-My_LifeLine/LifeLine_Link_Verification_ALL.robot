*** Settings ***
Documentation    A test suite to verify MyWFG LifeLine Links for all Lire Line tasks
...               Author: Isabella Fayner
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, clicks MyWFG Lifeline and
...               verifies all MyWFG LifeLine Link together
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           ../../Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary
Library           String

#Suite Setup      Open Browser and Start Data Driven Test
Test Template     Connect to Database and Select Agent
Suite Teardown    Close Browser and Finish Test

*** Variables ***

${STATE}

*** Test Cases ***                      NotificationID
US E&O/TFA Balance Due                      1
AML Renewal - US                            2
AML Renewal - CA                            3
License Renewal - US                        4
License Renewal - CA                        5
Appointment Renewal                         6
Affiliation Renewal                         7
TFG New Rep Training Course                 8
AML Course - US                             9
AML Course - CA                             10
IUL Course                                  11
Annuity Course                              12
#Long Term Care Renewal                      13
TFG New IAR Training Course                 14
2015 TFA Firm Element Supervisor            15
2015 TFA Firm Element RR                    16
2015 TFA AML                                17
2015 TFA Firm Element General Sec           18
2015 TFA Firm Element IAR                   19
2015 TFA ACM                                20
FINRA,State Securities,IAR Renewal          21
Canada Agency Agreement                     22
Mutual Fund License Renewal                 23
TFA Annual Regulatory Questionaire          24
IRS 8233 Form                               25
FINRA Regulatory Education Course           26
CA E&O Balance Due                          27

*** Keywords ***
#Open Browser and Start Data Driven Test
#     Open Browser To Login Page

Connect to Database and Select Agent
    Open Browser To Login Page
    [Arguments]    ${Notification_ID}
    ${Agent_CodeNo}    Database_Library.Get_LifeLine_Explanation_Agent_ID    ${Notification_ID}
    ...    ${HOSTNAME}    ${WFG_DATABASE}

    ${html_ID}    Database_Library.Get_LifeLine_Link_html_Id    ${Agent_CodeNo}    ${Notification_ID}    ${STATE}
    ...    ${HOSTNAME}    ${WFG_DATABASE}

    Set Suite Variable    ${Agent_CodeNo}
    Set Suite Variable    ${html_ID}
    Set Suite Variable    ${Notification_ID}

    ${AgentNo_Length}=    Get Length    ${Agent_CodeNo}

    Run Keyword If    ${AgentNo_Length} > 4    Login to MyWFG.com, Open LifeLine and Click LifeLine link
    ...    ELSE
    ...    log    This LifeLine task doesn't exist

Login to MyWFG.com, Open LifeLine and Click LifeLine link
    User "${Agent_CodeNo}" logs in with password "${VALID_PASSWORD}"
    Home Page for any Agent Should Be Open
    sleep    2s
    Verify A Link Named "Business" Is On The Page
    sleep    2s
    Click Link with ID "myBusinessTabDesktop"
    sleep    2s
    Click element using href "/Wfg.MyLifeline"
    sleep    2s
    #********************* Click Life Line Link  *********************
    Click Link With ID "Notice-${html_ID}"
    sleep    2s
    Log Out of MyWFG
    sleep    2s
    Close Browser

Close Browser and Finish Test
    Close Browser

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