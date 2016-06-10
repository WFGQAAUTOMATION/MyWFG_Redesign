*** Settings ***
Documentation     A test suite to check Vision and Mission page.
...
...               This test will log into MyWFG and
...               verify the Vision and Mission page.
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Force Tags        Dev_Sanity

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open

Navigate to Vision and Mission
    Then Go To  http://${SERVER}/vision-and-mission

Find Text On Webpage
    And Find "WFG Vision" On Webpage
    And Find "WFG Mission" On Webpage

Log Out
    Then Log Out of MyWFG
    And Close Browser

*** Keywords ***
