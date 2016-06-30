*** Settings ***
Documentation    A test suite to verify that MyWFG LifeLine records are not duplictated
...
...               This test will connect to database and verify that MywFG LifeLine
...               records are not duplicated
Metadata          Version   0.1
Library           ../../Resources/Database_Library.py
Library           Selenium2Library
Library           DatabaseLibrary

*** Variables ***

*** Test Cases ***
Connect from Python file
    ${mydata}   Database_Library.Count_Total_Notifications    ${HOSTNAME}    ${WFG_DATABASE}
    Database_Library.LifeLine_Records_Duplications    ${mydata}    ${HOSTNAME}    ${WFG_DATABASE}
