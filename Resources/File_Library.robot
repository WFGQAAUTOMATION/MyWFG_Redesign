*** Settings ***
Documentation    Suite description
Resource  Resource_Webpage.robot

*** Test Cases ***
Copy Folder
	Copy Directory  C:\\GitHub_Files\\MyWFG_Model_Tim\\Login_Log     O:\\BusinessSupport\\Jenkins_Reports

*** Keywords ***