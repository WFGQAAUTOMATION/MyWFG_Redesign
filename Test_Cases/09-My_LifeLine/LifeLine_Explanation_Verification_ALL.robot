*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine Explanation image
...               Author: Isabella Fayner
...               Creation Date: 06/23/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline, clicks LifeLine
...               task Explanation image and verifies the message of all Life Line IDs
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
Long Term Care Renewal                      13
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
#      Open Browser To Login Page

Connect to Database and Select Agent
    Close Browser
    sleep    1s
    Open Browser To Login Page
    [Arguments]    ${Notification_ID}
    ${Agent_CodeNo}    Database_Library.Get_LifeLine_Explanation_Agent_ID    ${Notification_ID}    ${HOSTNAME}
    ...    ${WFG_DATABASE}

    ${html_ID}    Database_Library.Get_LifeLine_Explanation_Info    ${Agent_CodeNo}    ${Notification_ID}    ${STATE}
    ...    ${HOSTNAME}    ${WFG_DATABASE}

    Set Suite Variable    ${Agent_CodeNo}
    Set Suite Variable    ${html_ID}
    Set Suite Variable    ${Notification_ID}

    ${AgentNo_Length}=    Get Length    ${Agent_CodeNo}

    Run Keyword If    ${AgentNo_Length} > 4    Login to MyWFG.com, Open LifeLine and Get LifeLine Task Explanation
    ...    ELSE
    ...    log    This LifeLine task doesn't exist

Login to MyWFG.com, Open LifeLine and Get LifeLine Task Explanation
    User "${Agent_CodeNo}" logs in with password "${VALID_PASSWORD}"
    Home Page for any Agent Should Be Open
    sleep    2s
    Verify A Link Named "Business" Is On The Page
    sleep    2s
    Click Link with ID "myBusinessTabDesktop"
    sleep    2s
    Click element using href "/Wfg.MyLifeline"
    sleep    3s
    #********* Click Question image next to Life Line task   ***********
    click element  xpath=.//*[@id='QuestionMark-${html_ID}']
    sleep    3s
    Compare Life Line Explanation Messages    ${Notification_ID}
    sleep    1s
    Log Out of MyWFG
    sleep    2s
    Close Browser

Compare Life Line Explanation Messages
    [Arguments]    ${Notification_ID}
    # ***********  Retrive Explanation description from database  *****************
    ${SQL_Text}    Database_Library.Get_LifeLine_Explanation_Description    ${Notification_ID}
    ...    ${HOSTNAME}    ${WFG_DATABASE}
    # ***********  Replace &#8217 ASCI character to " ' " *************************
    ${SQL_Text}=    Replace String    ${SQL_Text}    &#8217    '
    # ***********  Remove </br> from Explanation String ***************************
    ${SQL_Text}=    Remove String    ${SQL_Text}    </br>
    # ***********  Get Explanation description from Web page  *********************
    sleep    1s
    ${Webpage_Text}=    Get Text Where ID Contains "popover"
    # ***********  Replace ’ character with ' in order to compare explanations ****
    ${Webpage_Text}=    Replace String    ${Webpage_Text}    ’    '
    # ***********  Remove <br> from Explanation String  ***************************
    ${Webpage_Text}=    Remove String    ${Webpage_Text}    <br>
    # ***********  Remove <br/> from Explanation String  **************************
    ${Webpage_Text}=    Remove String    ${Webpage_Text}    <br/>
    # ***********  Verify the text of explanantion  *******************************
    Run Keyword If    ${Notification_ID} == 12
    ...    Run Keyword And Continue On Failure    Should Contain     ${Webpage_Text}    ${SQL_Text}
    Run Keyword If    ${Notification_ID} != 12
    ...    Run Keyword And Continue On Failure    Should be equal    ${Webpage_Text}    ${SQL_Text}

Close Browser and Finish Test
    Close Browser



