*** Settings ***
Documentation     A test suite to check leadership.
...
...               This test will log into MyWFG and
...               verify the Leadership.
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Test Teardown
Force Tags        Dev_Sanity

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    And Verify A Link Named "Home" Is On The Page

Navigate to Home Office Leadership
    Then Hover Over "Home"
    Then Wait "3" Seconds
    Then click link     xpath=//a[contains(@href, '/wfg-home-office-executive-leadership')]

Check Leadership Names
    And Find "Joe DiPaola" On Webpage
    And Find "Richard Williams" On Webpage
    And Find "Susan Davies" On Webpage
    And Find "Leesa Easley" On Webpage
    And Find "John Joseph" On Webpage

Log Out and Close Browser
    Then log out of mywfg
    And close browser

*** Keywords ***
