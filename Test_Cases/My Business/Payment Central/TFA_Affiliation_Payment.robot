*** Settings ***
Documentation     The purpose of this test suite is to choose TFA Affiliation option on the
...               Payment Central, add item to the shopping cart and make a payment for the
...               agent witth TFA Affiliation balance
...               Author: Isabella Fayner
...               Creation Date: 08/08/2016
...
...               This test will log into MyWFG, click My Business button, click Admin, click Payment Central,
...               click E&O Payment and subscribe for E&O recurring payments for the agent with E&O balance
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
    ${Agent_Info}    Database_Library.Select_TFA_Affiliation_Agent    ${Today_Date}
    ...    ${COMP_HOSTNAME}    ${COMP_DATABASE}

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

Click TFA Affiliation Element
    Click Element with ID "Wfg-TfaAffiliationPayment"
    sleep    2s

Click Add to Cart Button
    Click Element with ID "AddBalanceToCart"
    sleep    2s

Click View Cart Button and Click Close Button
    Show Hidden List Items with ID "hidPaymentType"
    Click Element with class "dropDown"
    sleep    2s
    Click Element with class "dropDown"
    Restore Hidden List Items with ID "hidPaymentType"
    sleep    2s

Click View Cart Button and Click Continue Button
    Show Hidden List Items with ID "hidPaymentType"
    Click Element with class "dropDown"
    sleep    2s
    Click Button using ID "btnCheckOut"
#   Restore Hidden List Items with ID "hidPaymentType"
    sleep    2s

Click Pay Now Button
    Click Button using ID "btnPayNow"
    sleep    2s

Insert Credit Card Info
    Input "${CC_NUMBER}" in the "cc_number" Field With ID
    #sleep    1s
    Input "${CC_EXP_MONTH}" in the "expdate_month" Field With ID
    #sleep    1s
    Input "${CC_EXP_YEAR}" in the "expdate_year" Field With ID
    #sleep    1s
    Input "${CC_FIRST_NAME}" in the "first_name" Field With ID
    #sleep    1s
    Input "${CC_LAST_NAME}" in the "last_name" Field With ID
    #sleep    1s
    Input "${CC_ADDRESS1}" in the "billingAddress1" Field With ID
    #sleep    1s
    Input "${CC_ADDRESS2}" in the "billingAddress2" Field With ID
    #sleep    1s
    Input "${CC_CITY}" in the "billingCity" Field With ID
    #sleep    1s
    Click List Box With ID "billingState" and select "${CC_STATE}"
    #sleep    1s
    Input "${CC_ZIP}" in the "billingZip" Field With ID
    #sleep    1s
    Input "${CC_PHONE_NUMBER}" in the "phone_number" Field With ID
    #sleep    1s

Click Credit Card Pay Now Button
    Click Element with ID "btn_pay_cc"
    sleep    2s

Click COMPLETE TRANSACTION Link
    Click Link Named "CLICK TO COMPLETE TRANSACTION!"

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
