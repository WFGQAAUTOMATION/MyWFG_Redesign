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
	And Click Link Named "Admninistration"
	Then Click Link Named "BOSS Electronic Forms"

*** Keywords ***
Provided precondition
    Setup system under test