*** Settings ***
Documentation    A test suite to search My Team by First Name
...               Author: Tim Coffey
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, open My Team menu, search by First Name
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

Enter First Name and Click Search
	Then input "MARIA" in the "hierarchyFirstNameField" field
	And Click Button named "Search"

Verify Results List
	Then Element "MARIA" Should Be Present

*** Keywords ***
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