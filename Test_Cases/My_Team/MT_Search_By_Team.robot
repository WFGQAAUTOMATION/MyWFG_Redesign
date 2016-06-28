*** Settings ***
Documentation    A test suite to search My Team by Team
...               Author: Tim Coffey
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, open My Team menu, search by team
...               and verify the results
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library
Suite Setup       Login to MyWFG.com
Test Setup        Show Hidden List Items with ID "selBaseType"
Test Template     Click on My Team Element, Select Team from Team Listbox, Then Verify Results
Test Teardown     Restore Hidden List Items with ID "selBaseType"
Suite Teardown    Close Browser

*** Variables ***

*** Test Cases ***                             Team
Choose Active Team from Team Listbox           'Active Team'
Choose SMD Base from Team Listbox              'SMD Base'
Choose Super Base from Team Listbox            'Super Base'
Choose Super Team from Team Listbox            'Super Team'
Choose Securities Team from Team Listbox       'Securities Team'
Choose Terminated from Team Listbox            'Terminated'

*** Keywords ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    And Verify A Link Named "Profile" Is On The Page
    Then Wait "2" Seconds
	And Click My Team

Click on My Team Element, Select Team from Team Listbox, Then Verify Results
	Then Wait "6" Seconds
	[Arguments]     ${team}
	Then run keyword if  ${team} == 'Active Team'   click element   xpath=.//*[@id='selBaseType']/option[@value='3']
	Then run keyword if  ${team} == 'SMD Base'   click element   xpath=.//*[@id='selBaseType']/option[@value='0']
	Then run keyword if  ${team} == 'Super Base'   click element   xpath=.//*[@id='selBaseType']/option[@value='1']
	Then run keyword if  ${team} == 'Super Team'   click element   xpath=.//*[@id='selBaseType']/option[@value='2']
	Then run keyword if  ${team} == 'Securities Team'   click element   xpath=.//*[@id='selBaseType']/option[@value='4']
	Then run keyword if  ${team} == 'Terminated'   click element   xpath=.//*[@id='selBaseType']/option[@value='5']
	Then Wait "5" Seconds
	And Click Button named "Search"
	Then Wait "5" Seconds
	Then run keyword if  ${team} == 'Active Team'   element should be visible   xpath=//*[@id='hierarchyDataTable']//span[contains(text(),'1')]
	Then run keyword if  ${team} == 'SMD Base'   element should be visible   xpath=//*[@id='hierarchyDataTable']//span[contains(text(),'1')]
	Then run keyword if  ${team} == 'Super Base'    element should be visible   xpath=//*[@id='hierarchyDataTable']//span[contains(text(),'1')]
	Then run keyword if  ${team} == 'Super Team'   element should be visible   xpath=//*[@id='hierarchyDataTable']//span[contains(text(),'1')]
	Then run keyword if  ${team} == 'Securities Team'   element should be visible   xpath=//*[@id='hierarchyDataTable']//span[contains(text(),'1')]
	Then run keyword if  ${team} == 'Terminated'   element should be visible   xpath=//*[@id='hierarchyDataTable']//span[contains(text(),'1')]
	And Click Link with ID "myTeam-back-btn"
	Then Wait "5" Seconds

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