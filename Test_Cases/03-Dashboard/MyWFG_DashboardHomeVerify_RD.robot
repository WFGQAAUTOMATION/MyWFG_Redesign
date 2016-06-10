*** Settings ***
Documentation     A test suite to check MyWFG Site.
...
...               This test will log into MyWFG and
...               verify the Dashboard Home.
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Force Tags        Dev_Sanity

*** Test Cases ***
Login to MyWFG.com
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open

Go to Dashboard Page
    Then Click Redesigned Menu
    Then Wait "3" Seconds
    And Click Link Named "Commissions & Reports"
    Then Wait "3" Seconds
    Then Click Link Named "Dashboard"
    Then Wait "3" Seconds

Verify Dashboard Page is Opened
    And Element Header "Dashboard" Should Be Present

Log Out and Close Browser
    Then log out of mywfg
    And close browser

*** Keywords ***
