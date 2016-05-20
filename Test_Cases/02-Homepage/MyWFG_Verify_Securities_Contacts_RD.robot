*** Settings ***
Documentation     A test suite to check Securities Home Office Contacts page.
...
...               This test will log into MyWFG and
...               verify the Securities Home Office Contacts page.
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Force Tags        Dev_Sanity

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open

Navigate to Securities Home Office Contacts
    Then Go To  http://${SERVER}/securitieshomeofficecontacts

Find Text On Webpage
    And Find "WFG Securities of Canada" On Webpage
    And Find "416.225.2121" On Webpage
    And Find "TFG Managers" On Webpage

Log Out
    Then log out of mywfg
    And close browser

*** Keywords ***
