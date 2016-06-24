*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine Explanation image
...               Author: Isabella Fayner
...               Creation Date: 06/23/2016
...
...               This test will log into MyWFG, go to My Business/My Lifeline, clicks LifeLine
...               task Explanation image and verifies the message for one chosen Life Line ID
Metadata          Version   0.1
Resource          C:/Github_Projects/MyWFG_Redesign/Resources/Resource_Login.robot
Resource          C:/Github_Projects/MyWFG_Redesign/Resources/Resource_Webpage.robot
Library           C:/Github_Projects/MyWFG_Redesign/Resources/Testing_Library.py
Library           C:/Github_Projects/MyWFG_Redesign/Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary
Library           String

Suite Teardown     Close Browser

*** Variables ***

${Notification_ID}          4
${STATE}

*** Test Cases ***

Select Agent, Login to MyWFG.com, click LifeLine image and get LifeLine task Information
    ${Agent_CodeNo}    Database_Library.Get_LifeLine_Explanation_Agent_ID    ${Notification_ID}    ${HOSTNAME}
    ...    ${WFG_DATABASE}

    ${html_ID}    Database_Library.Get_LifeLine_Explanation_Info    ${Agent_CodeNo}    ${Notification_ID}    ${STATE}
    ...    ${HOSTNAME}    ${WFG_DATABASE}

    Given browser is opened to login page
    When user "${Agent_CodeNo}" logs in with password "${VALID_PASSWORD}"
    Then Home Page for any Agent Should Be Open
    sleep    2s
    Verify A Link Named "Business" Is On The Page
    sleep    2s

    Set Suite Variable    ${Agent_CodeNo}
    Set Suite variable    ${html_ID}

Click My Business button
    Click Link with ID "myBusinessTabDesktop"
    sleep    2s

Click My Life Line button
    Click element using href "/Wfg.MyLifeline"
    sleep    3s
    #********* Click Question image next to Life Line task   ***********
    click element  xpath=.//*[@id='tr-${html_ID}']/td[1]/a[2]
    sleep    2s

Compare Life Line Explanation Messages
    # ***********  Retrive Explanation description from database  *****************
    ${SQL_Text}    Database_Library.Get_LifeLine_Explanation_Description    ${Notification_ID}    ${HOSTNAME}
    ...    ${WFG_DATABASE}
    # ***********  Replace &#8217 ASCI character to " ' " *************************
    ${SQL_Text}=    Replace String    ${SQL_Text}    &#8217    '
    # ***********  Remove </br> from Explanation String ***************************
    ${SQL_Text}=    Remove String    ${SQL_Text}    </br>

    # ***********  Get Explanation description from Web page  *********************
    ${Webpage_Text}=    Get Text Where ID Contains "popover"

    # ***********  Replace ’ character with ' in order to compare explanations ****
    ${Webpage_Text}=    Replace String    ${Webpage_Text}    ’    '
    # ***********  Remove <br> from Explanation String  ***************************
    ${Webpage_Text}=    Remove String    ${Webpage_Text}    <br>
    # ***********  Remove <br/> from Explanation String  **************************
    ${Webpage_Text}=    Remove String    ${Webpage_Text}    <br/>
    # ***********  Verify the text of explanantion  *******************************
    Run Keyword If    ${Notification_ID} == 12
    ...    Should Contain     ${Webpage_Text}    ${SQL_Text}
    ...    ELSE
    ...    Should be equal    ${Webpage_Text}    ${SQL_Text}

Log Out of MyWFG
    Log Out of MyWFG


*** Keywords ***

