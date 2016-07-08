*** Settings ***
Documentation     The purpose of this test suite is to choose E&O payment option on the Payment Central
...               and add item to the shopping cart for the agent without E&O balance
...               Author: Isabella Fayner
...               Creation Date: 06/30/2016
...
...               This test will log into MyWFG, click My Business button, click Admin, click
...               Payment Central, click E&O Payment and subscribe for E&O recurring payments
...               for the agent without E&O balance
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

Select Agent, Login to MyWFG.com, Check Dismiss Notifications
# ***** Get specific Agent ID based on todays day in order to prevent duplications *****
    ${Today_Date}    Get Current Date
    ${Agent_Info}    Database_Library.Select_EO_Agent_Without_Balance    ${EO_Country}    ${Today_Date}
    ...    ${WF_HOSTNAME}    ${WF_DATABASE}

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

Click Authorize and Add to Cart Button
    Click Button using id "enoAddCart"
    sleep    3s

Log Out of MyWFG
    Log Out of MyWFG
    sleep    1s

Close opened Browser
    Close Browser


*** Keywords ***

