*** Settings ***
Documentation     A test suite to verify MyWFG LifeLine Green Notification Expiration
...               Author: Isabella Fayner
...               Creation Date: 06/24/2016
...
...               The purpose of this test is to verify that LifeLine records stay in
...               Green Notification section for 7 days and dismissed after that
Metadata          Version   0.1
Library           C:/Github_Projects/MyWFG_Redesign/Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary

*** Variables ***


*** Test Cases ***
Connect from Python file
    ${mydata}   Database_Library.Count_Total_Notifications    ${HOSTNAME}    ${WFG_DATABASE}
    Database_Library.LifeLine_Green_Notifications    ${mydata}    ${HOSTNAME}    ${WFG_DATABASE}
