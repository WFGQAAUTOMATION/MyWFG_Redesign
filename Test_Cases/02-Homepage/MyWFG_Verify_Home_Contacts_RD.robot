*** Settings ***
Documentation     A test suite to check home office contacts page.
...
...               This test will log into MyWFG and
...               verify the Home Office Contacts page.
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Test Teardown

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open

Click on Menu
	And Click Redesigned Menu
	Then Wait "5" Seconds

Click TFA > TFA Admin > TFA Home Office Contacts
	And Click Link Named "TFA"
	Then Click Link Named "TFA Administration"
	Then Click Link Named "TFA Home Office Contacts"

Check Info on Home Office Contacts page
    And Find "Home Office Contacts" On Webpage
    And Find "770.246.9889" On Webpage
    And Find "416.225.2121" On Webpage
#    And Find "678.474.4208" On Webpage

Log Out and Close Browser
    Then log out of mywfg
    And close browser

*** Keywords ***
