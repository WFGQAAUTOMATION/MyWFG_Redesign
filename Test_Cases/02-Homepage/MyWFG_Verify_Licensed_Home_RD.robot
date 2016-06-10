*** Settings ***
Documentation     A test suite to check Licensed Home page.
...
...               This test will log into MyWFG and
...               verify the Licensed Home page.
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Force Tags        Dev_Sanity

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open

Click Licensed Home
    Then Go To  http://${SERVER}/new-licensed-home

Find Text On Webpage
    And Find "As a licensed associate" On Webpage
    And Find "iGO" On Webpage
    And Find "Become Appointed with a Company" On Webpage

Log Out
    Then log out of mywfg
    And close browser

*** Keywords ***
