*** Settings ***
Documentation    A test suite to search My Team by Last Name
...               Author: Tim Coffey
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, open My Team menu, search by Last Name
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

Enter Last Name and Click Search
	Then input "ESCOBEDO" in the "hierarchyLastNameField" field
	And Click Button named "Search"

Verify Results List
	Then Element "ESCOBEDO" Should Be Present

*** Keywords ***
