*** Settings ***
Documentation    A test suite to search My Team by City
...               Author: Tim Coffey
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, open My Team menu, search by City
...               and verify the results
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library
Library           FakerLibrary
Library           BuiltIn

#Suite Teardown    Close Browser

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open

Click on Menu
	And Click Redesigned Menu
	Then Wait "5" Seconds

Click Admninistration > BOSS Electronic Forms
	And Click Link Named "Administration"
	Then Click Link Named "BOSS Electronic Forms"
	Then Wait "5" Seconds

Click Direct Deposit US
	Then click link     xpath=//*[@id='chooseFormList']//a[contains(text(),'Direct Deposit Authorization Agreement Form - US')]
#	Then Click Link Named "Direct Deposit Authorization Agreement Form - US"
	Then Wait "5" Seconds

Click Continue
	Then Scroll Page to Location Where Y equals "1000"
	Then wait until page contains element   xpath=//div[@id='divInformationButton']/div/div/div[2]/button   30
	And click element        xpath=//div[@id='divInformationButton']/div/div/div[2]/button
#	xpath=//div[@id="divInformationButton"]//*[@id='btnInfoContinue']
#	And Click Button using id "btnInfoContinue"
	Then Wait "5" Seconds
#
#Enter Answer into Challenge Field
#	Then Input "wfg" in the "ChallengeAnswer_DirectDeposit" Field With ID
#	And Click Button named "Submit"
#
#Click Continue on Instruction Page
#	Then Scroll Page to Location Where Y equals "500"
#	And Click Button named "Continue"
#
#	Then Scroll Page to Location Where Y equals "500"
#	And Select Radio Button with ID "AccountType" and value "Savings"
#	Then Select Radio Button with ID "AccountOwner" and value "Individual"
#	Then Input "${name}" in The "NameOnAccount" Field
#	Then Input "147852369" in The "RoutingNum" Field
#	Then Input "147852369" in The "ConfirmRoutingNum" Field
#	And Input "147852369" in The "ConfirmRoutingNum" Field
#	Then Input "147852369123456" in The "AccountNum" Field
#	Then Input "147852369123456" in The "ConfirmAccountNum" Field
#	Then Click Button named "Continue"

#Fill out Depository Info
#	${bankname}=        FakerLibrary.Company
#	${phonenumber}=     FakerLibrary.Phone Number
#	${streetaddress}=   FakerLibrary.Street Address
#	${city}=            FakerLibrary.City
#	${state}=           FakerLibrary.State
#	${zip}=             FakerLibrary.ZipCode
#	${firstname}=       FakerLibrary.First Name
#	${lastname}=        FakerLibrary.First Name
#	${name}=    Catenate   ${firstname}    ${lastname}
#	Then Scroll Page to Location Where Y equals "-500"
#	And Input "${bankname}" in The "BankName" Field
#	Then Input "${phonenumber}" in The "BankPhone" Field
#	Then Input "${streetaddress}" in The "BankStreetAddress" Field
#	Then Input "${city}" in The "BankCity" Field
#	And Show Hidden List Items with ID "BankState"
#	Then Wait "2" Seconds
#	Then Click List Box Named "BankState" and select "${state}"
#	Then Restore Hidden List Items with ID "BankState"
#	Then Input "${zip}" in The "BankZip" Field
*** Keywords ***
