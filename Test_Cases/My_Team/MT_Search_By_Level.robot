*** Settings ***
Documentation    A test suite to search My Team by Level
...               Author: Tim Coffey
...               Creation Date: 06/27/2016
...
...               This test will log into MyWFG, open My Team menu, search by level
...               and verify the results
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library
Suite Setup       Login to MyWFG.com
Test Setup        Show Hidden List Items with ID "selLevelFilter"
Test Template     Click on My Team Element, Select Level from Level Listbox, Then Verify Results
Test Teardown     Restore Hidden List Items with ID "selLevelFilter"
Suite Teardown    Close Browser

*** Variables ***

*** Test Cases ***                      Level
Choose All from Level Listbox           'All'
Choose TA from Level Listbox            'TA'
Choose A from Level Listbox             'A'
Choose SA from Level Listbox            'SA'
Choose MD from Level Listbox            'MD'
Choose SMD from Level Listbox           'SMD'
Choose EMD from Level Listbox           'EMD'
Choose CEO from Level Listbox           'CEO'
Choose EMC from Level Listbox           'EMC'

*** Keywords ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    And Verify A Link Named "Profile" Is On The Page
    Then Wait "2" Seconds
	And Click My Team

Click on My Team Element, Select Level from Level Listbox, Then Verify Results
	Then Wait "6" Seconds
	[Arguments]     ${level}
	Then run keyword if  ${level} == 'ALL'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='-1']
	Then run keyword if  ${level} == 'TA'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='01']
	Then run keyword if  ${level} == 'A'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='10']
	Then run keyword if  ${level} == 'SA'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='15']
	Then run keyword if  ${level} == 'MD'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='17']
	Then run keyword if  ${level} == 'SMD'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='20']
	Then run keyword if  ${level} == 'EMD'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='65']
	Then run keyword if  ${level} == 'CEO'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='70']
	Then run keyword if  ${level} == 'EMC'  click element  xpath=.//*[@id='selLevelFilter']/option[@value='87']
	Then Wait "5" Seconds
	And Click Button named "Search"
	Then Wait "5" Seconds
	Then run keyword if  ${level} == 'ALL'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'1')]
	Then run keyword if  ${level} == 'TA'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'TA')]
	Then run keyword if  ${level} == 'A'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'A')]
	Then run keyword if  ${level} == 'SA'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'SA')]
	Then run keyword if  ${level} == 'MD'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'MD')]
	Then run keyword if  ${level} == 'SMD'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'SMD')]
	Then run keyword if  ${level} == 'EMD'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'EMD')]
	Then run keyword if  ${level} == 'CEO'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'CEO')]
	Then run keyword if  ${level} == 'EMC'  element should be visible      xpath=//*[@id='hierarchyDataTable']//div[contains(text(),'EVC')]
	Then Wait "5" Seconds
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