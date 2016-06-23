*** Settings ***
Documentation    A test suite to customize the toolbox
...              Author: Tim Coffey
...              Creation Date: 06/21/2016
...
...               This test will log into MyWFG, open toolbox and
...               customize toolbox selections
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library
Suite Teardown    Close Browser

*** Variables ***
${button}=  get text  xpath=//div[3]/div/div/div[2]/a[1]/span

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    And Verify A Link Named "Profile" Is On The Page
    Then Wait "2" seconds

Click Toolbox Icon
	And Click Element with ID "my-toolbox"

Click Customize
	Then Wait "3" seconds
	And Click Element with ID "cutomize-myToolbox" using Javascript

Add Item
	Then Wait "2" seconds
	Then click element  xpath=//div[3]/div/div/div[2]/a[1]/div

Click Yes to Add
	Then Wait "2" seconds
	And Click Button named "Yes"

Verify Item was Added
	${added}=   get text  xpath=//div[3]/a[4]/span
	${added}=   convert to string  ${added}
	${button}=  convert to string  ${button}
	run keyword if  "${button}"=="${added}"     log  "Passed"

*** Keywords ***
