*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.
Library           Selenium2Library
Library           Testing_Library.py
Library           OperatingSystem


*** Variables ***
#${SERVER}            m-www.mywfg.com
#${BROWSER}           ff
#${DELAY}             0
#${VALID USER}        1200W
#${VALID PASSWORD}    81u3$ky
#${LOGIN URL}         https://${SERVER}/Users/Account/AccessDenied?ReturnUrl=%2f
#${WELCOME URL}       https://${SERVER}/
#${ERROR URL}         https://${SERVER}/Users/Account/LogOn?ReturnUrl=%2F

*** Keywords ***

#*****************************************************
#*****************************************************
######   NAVIGATION  ######
#*****************************************************

Click Menu Item "${menuitem}"
    Click Link    //a[contains(text(),'${menuitem}')]

#*****************************************************

Select Menu Item "${clickelement}"
    click element    xpath=//a[(text()='${clickelement}')]

#*****************************************************

Navigate to webpage
    click link  ${LinkName}

#*****************************************************

Go To My Profile
    click element    xpath=//span[contains(text(),'My profile')]
    click link    xpath=//a[@id='myProfile']

#*****************************************************

Log Out of MyWFG
    click element    xpath=//span[contains(text(),'My profile')]
	click link     xpath=//*[(text()='Log Out')]

#*****************************************************

Click Redesigned Menu
    click element  xpath=//a[@id='menu-toggle']

#*****************************************************

Click My Team
	click element    xpath=//span[contains(text(),'My team')]

#*****************************************************

Scroll Page to Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})

#*****************************************************

Scroll Page to Location Where Y equals "${y_location}"
    Execute JavaScript    window.scrollTo(0,${y_location})

#*****************************************************

Zoom out to "${zoomLevel}" (percentage)
	Execute javascript  document.body.style.zoom="${zoomLevel}"

#*****************************************************

Hover Over "${hoverover}"
    mouse over       xpath=//a[(text()='${hoverover}')]

#*****************************************************

Wait "${seconds}" Seconds
    set selenium implicit wait  ${seconds}

#*****************************************************

Click Ok on Alert
    confirm action

#*****************************************************

Click Cancel on Alert
     Choose Cancel On Next Confirmation
     sleep      3
     confirm action

#*****************************************************

Show Hidden List Items with ID "${hiddenID}"
    Execute JavaScript   document.getElementById('${hiddenID}').classList.remove("jcf-hidden")

#*****************************************************

Restore Hidden List Items with ID "${hiddenID}"
    Execute JavaScript   document.getElementById('${hiddenID}').classList.add("jcf-hidden")

#*****************************************************

Click OK Button On Java Dialog
    Execute JavaScript    window.close()

#*****************************************************
######   INTERACT ELEMENTS    ######
#*****************************************************
#*****************************************************

Click Object Named "${clickelement}" with span name
    click element    xpath=//span[contains(text(),'${clickelement}')]

#*****************************************************

Click Button named "${buttonname}"
    click button    xpath=//button[contains(text(),'${buttonname}')]

#*****************************************************

Click Button using style "${buttonstyle}"
    click button    xpath=//button[@style='${buttonstyle}']

#*****************************************************

Click Button using id "${buttonid}"
    click button    xpath=//button[@id='${buttonid}']

#*****************************************************

Click Button using name "${buttonname}"
    click button    xpath=//button[@name='${buttonname}']

#*****************************************************

Click Button using value "${buttonvalue}"
    click button    xpath=//button[@value='${buttonvalue}']

#*****************************************************

Click Element with ID "${elem_ID}" and class "${class}"
    click element    xpath=//*[@id='${elem_ID}'][@class='${class}']

#*****************************************************

Click Element with ID "${elem_ID}"
    click element    xpath=//*[@id='${elem_ID}']

#*****************************************************

Click Element with ID "${elem_ID}" using Javascript
	execute javascript  document.getElementById('${elem_ID}').click()

#*****************************************************

Click Element using href "${href}"
    click link    xpath=//a[contains(@href, '${href}')]

#*****************************************************

Click Link Named "${clicklink}"
    click link    xpath=//a[contains(text(),'${clicklink}')]

#*****************************************************

Click Link With Name Contained "${clicklink}"
    click link    xpath=//a[contains(text(),'${clicklink}')]

#*****************************************************

Click Link where ID is "${Link_ID}"
    click link    xpath=//input[@id='${Link_ID}']

#*****************************************************

Click Link with "${href}"
    click link    xpath=//a[@href="${href}"]

#*****************************************************

Click Link with ID "${ID}"
    click link    xpath=//a[@id="${ID}"]

#*****************************************************

Input "${Text}" in The "${FieldName}" Field
    input text  xpath=//input[@name='${FieldName}']   ${Text}

#*****************************************************

Input "${Text}" in the "${Fieldname}" Field With ID
    input text  xpath=//input[@id='${FieldName}']   ${Text}

#*****************************************************

Select Radio Button with ID "${radio_ID}" and value "${value}"
	select radio button  xpath=//input[@id='${radio_ID}')][@value='${value}']

#*****************************************************

Select Checkbox Where ID is "${cbName}"
    select checkbox     xpath=//input[@id='${cbName}']

#*****************************************************

Select Frame Where ID is "${frameID}"
    log  ${frameID}
    select frame    xpath=//iframe[@id='${frameID}']

#*****************************************************

Click List Box Named "${SelectItem}" and select "${Item}"
    Select From List     xpath=//select[@name='${SelectItem}']  ${Item}

#*****************************************************

Click List Box With ID "${ItemID}" and select "${Item}"
    Select From List     xpath=//select[@id='${ItemID}']    ${Item}

#*****************************************************

Click List Box With ID "${ItemID}" and select by index "${Index}"
    Select From List By Index    xpath=//select[@id='${ItemID}']  ${Index}

#*****************************************************

Click Archive List Box With ID "${ItemID}" and select by index "${Index}"

    Select From List By Index    xpath=//*[@id='${ItemID}']  ${Index}

#*****************************************************

Click image where ID is "${ImageID}"
    click image     xpath=//input[@id='${ImageID}']

#*****************************************************

Click image named "${Image}"
    click image     xpath=//input[@name='${Image}']

#*****************************************************

Click image using img where ID is "${ImageID}"
    click image     xpath=//img[@id='${ImageID}']

#*****************************************************
######   FIND/VERIFY ELEMENTS      ######
#*****************************************************
#*****************************************************

Verify A Link Named "${linkname}" Is On The Page
    wait until page contains element    xpath=//a[contains(text(),'${linkname}')]   30s

#*****************************************************

Find "${textonpage}" On Webpage
    page should contain    ${textonpage}

#*****************************************************

Find "${AgentID}" in the Results List
    element should be visible    xpath=//a[@href="javascript:showAgentReports('${AgentID}')"]

#*****************************************************

Element "${elementname}" Should Be Present
    element should be visible    //*[contains(text(),'${elementname}')]

#*****************************************************

Verify Title on the page "${titlename}"
    Title Should Be     ${titlename}

#*****************************************************

Find Element on the Page "${element_id}"
    Page Should Contain Element    xpath=.//*[@id='${element_id}']

#*****************************************************

Elements should be equal ${Compare_Text} ${Webpage_Text}
    Should be equal    ${Compare_Text}    ${Webpage_Text}

#*********************************************************************************

Zoom out to "${zoomLevel}" (percentage)
	Execute javascript  document.body.style.zoom="${zoomLevel}"

#*********************************************************************************

Get Text Where ID Contains "${Element_ID}"
    ${Text}=    Get Text    xpath=//*[contains(@id,'${Element_ID}')]
    [Return]    ${Text}

#**********************************************************************************
