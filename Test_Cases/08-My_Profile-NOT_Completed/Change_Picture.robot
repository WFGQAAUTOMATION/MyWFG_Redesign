*** Settings ***
Documentation    A test suite to upload or change the photo on Profile page
...              Author: Isabella Fayner
...              Creation Date: 06/06/2016
...
...               This test will log into MyWFG, open Profile menu and
...               upload or change profile photo
Metadata          Version   0.1
Resource          ../../Resources/Resource_Login.robot
Resource          ../../Resources/Resource_Webpage.robot
Library           ../../Resources/Testing_Library.py
Library           Selenium2Library

Suite Teardown     Close Browser

*** Variables ***

${ELEMENT_ID}      Contact Settings

*** Test Cases ***

Login to MyWFG.com
    Given browser is opened to login page
    When user "${PREF_USER_ID}" logs in with password "${VALID_PASSWORD}"
    Then Home Page Should Be Open
    Verify A Link Named "Profile" Is On The Page
    sleep   2s

Go to My Profile Page
    Click My Profile
    sleep    2s
    Click Link with ID "myProfile"
    sleep    2s


#************ Not Done from HERE **********************************

Verify Webpage and Click Picture Image
    Find "${ELEMENT_ID}" On Webpage
    Click Link With Name Contained "${ELEMENT_ID}"
    sleep    2s

Click Delete Photo button for Cancel
    Click Object Named "Delete Photo"

Confirm Cancel to keep the picture
    Click Cancel on Alert

Click Delete Photo button
    click element   //a[@id='agentimage-delete']

Confirm Delete to delete the picture
    sleep    2s
    Click Ok on Alert

Click Upload Photo button for OK
    sleep   2s
    Click button named "Upload Photo"

Click OK button
    sleep  10s
    Click element   xpath=//span[@class="ui-button-text"][contains(text(),'Ok')]

Click Upload Photo button for Cancel
    sleep   2s
    Click Button named "Upload Photo"

Select Frame for Cancel
    select frame where id is "agentImageUploaderContainer"

Click Cancel button
    click button named "Cancel"

Click Upload Photo button
    sleep   2s
    Click Button named "Upload Photo"

Select Frame for Continue
    select frame where id is "agentImageUploaderContainer"

Click Agree checkbox
    select checkbox where id is "chkAgree"

Click Continue button
    click button named "Continue"

Click Browse button
    Click image where ID is "Image"
    sleep    10s   # when sleeps choose the file from File Uploader and close it

Click Upload button
    Click button named "Upload"
    sleep    3s
Click Continue and confirm upload
    Click button named "Continue"

Close Uploader and Log Out of MyWFG
    Click image where ID is "dialogClose"
    sleep   2s
    Log Out of MyWFG


*** Keywords ***


