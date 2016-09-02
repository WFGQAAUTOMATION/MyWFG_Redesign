*** Settings ***
Documentation     The purpose of this test suite is retrieve agents who have assigned for recurring
...               E&O charges in order to unsubscribe them.
...               Author: Isabella Fayner
...               Creation Date: 07/15/2016
...
...               This test will log into MyWFG, click My Business button, click Admin, click
...               Payment Central, click E&O Payment and unsubscribes from E&O recurring payment
Metadata          Version   0.1
Resource          ../../../Resources/Resource_Login.robot
Resource          ../../../Resources/Resource_Webpage.robot
Library           ../../../Resources/Testing_Library.py
Library           ../../../Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary
Library           String
Library           DateTime

Suite Teardown    Close Browser

*** Variables ***

*** Test Cases ***

Select Agent, Login to MyWFG.com, Verify Business Link
# ***** Get specific Agent ID based on todays day in order to prevent duplications *****
    ${Today_Date}    Get Current Date
    ${Agent_Info}    Database_Library.Select_EO_Agent_To_Unsubscribe    ${EO_Country}    ${Today_Date}
    ...    ${WF_HOSTNAME}    ${WF_DATABASE}    ${DATA_REFRESH_DATE}

    Browser is opened to login page
    User "${Agent_Info}" logs in with password "${VALID_PASSWORD}"
    Home Page for any Agent Should Be Open
    sleep   3s
    Verify A Link Named "Business" Is On The Page
    sleep   3s

    Set Suite Variable    ${Agent_Info}

Click My Business Button
    Click Link with ID "myBusinessTabDesktop"
    sleep    2s

Click Admin LInk
    Click Link With Name Contained "Admin"
    sleep    3s

Click Payment Central link
    Click Link With Name Contained "Payment Central"
    sleep    2s

Click E&O Payment Element
    Click Element with ID "Wfg-EOPayment"
    sleep    2s

Click Unsubscribe Now Button for No
    Click Button using id "enoAddCart"
    sleep    2s

Confirm No to keep recurring payment
    Click Button named "No, keep recurring payment"
    sleep    2s
Click Unsubscribe Now Button for Yes
    Click Button using id "enoAddCart"
    sleep    2s

Confirm Yes to unsubscribe
    Click Button named "Yes, unsubscribe"
    sleep    2s

Log Out of MyWFG
    Log Out of MyWFG
    sleep    1s

Close opened Browser
    Close Browser


*** Keywords ***
browser is opened to login page
	Open Browser
	...     ${LOGIN_URL}
	...     browser=${Browser}
	...     alias=None
#	...     remote_url=http://161.179.246.65:4444/wd/hub
	...     remote_url=http://161.179.241.85:4444/wd/hub
	...     ff_profile_dir=${FF_PROFILE}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Login Page Should Be Open
