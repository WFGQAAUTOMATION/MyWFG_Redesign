*** Settings ***
Documentation     A test suite with a single Gherkin style test.
...
...               This test is functionally identical to the example in
...               valid_login.txt file.
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Test Teardown     Close Browser
Force Tags        Dev_Sanity

*** Test Cases ***

Valid Login
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    And Click Redesigned Menu
	Then Wait "5" Seconds

Valid Login - Click Menu Item
    Given browser is opened to login page
    When user "${VALID_USER}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Then Click Redesigned Menu
    And Wait "5" Seconds

    ${welcome}=     element should be visible  xpath=//*[@class="hopscotch-title"]
    Then run keyword if   ${welcome}  click element  css=button.hopscotch-bubble-close.hopscotch-close

#    Then Click Element  css=button.hopscotch-bubble-close.hopscotch-close
    Then Wait "5" Seconds
    And Click Link Named "Events & Recognition"
	Then Wait "5" Seconds

Invalid Login - Bad Password
    Given Browser is opened to login page
    When User "${VALID_USER}" logs in with password "none"
    Then Login Should Have Failed
	Then Wait "5" Seconds

Invalid Login - Bad Username
    Given Browser is opened to login page
    When User "invalid" logs in with password "${VALID_PASSWORD}"
    Then Login Should Have Failed
	Then Wait "5" Seconds

*** Keywords ***
Browser is opened to login page
    Open browser to login page

User "${username}" logs in with password "${password}"
    Input username        ${username}
    Input password        ${password}
    Click Button    ${SUBMIT_LOGIN}

Login Should Have Failed
    Location Should Contain    ${ERROR_URL}
    Title Should Be       ${LOGIN_TITLE}

