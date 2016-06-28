*** Settings ***
Documentation    A test suite to search My Team by Zip Code
...               Author: Tim Coffey
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, open My Team menu, search by Zip Code
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

Enter Zip Code and Click Search
	Then input "91789" in the "zipField" field
	And Click Button named "Search"

Verify Results List
	Then Then element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'11HLY')]

*** Keywords ***
