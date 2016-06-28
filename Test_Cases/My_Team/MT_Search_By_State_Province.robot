*** Settings ***
Documentation    A test suite to search My Team by State/Province
...               Author: Tim Coffey
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, open My Team menu, search by State/Province
...               and verify the results
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library
Suite Teardown    Close Browser

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    And Verify A Link Named "Profile" Is On The Page
    Then Wait "2" Seconds
	And Click My Team

Enter State or Province and Click Search
	And Show Hidden List Items with ID "selLevelFilter"
	Then Wait "2" Seconds
	Then click element  xpath=//*[@id='selLevelFilter']/option[@value='70']
	Then Wait "2" Seconds
	Then Restore Hidden List Items with ID "selLevelFilter"
	Then Wait "2" Seconds
	And Show Hidden List Items with ID "stateField"
	Then Wait "2" Seconds
	And click element  xpath=//*[@id='stateField']/option[@value='5']
	Then Restore Hidden List Items with ID "stateField"
	Then Wait "2" Seconds
	And Click Button named "Search"

Verify Results List
	Then element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'11HLY')]

*** Keywords ***
