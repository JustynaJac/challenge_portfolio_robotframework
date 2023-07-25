*** Settings ***
Library         SeleniumLibrary

Documentation   Suite description #automated tests for scout website

*** Variables ***
${LOGIN URL}        https://scouts-test.futbolkolektyw.pl/en
${BROWSER}       Chrome
${SIGNINBUTTON}     xpath=//button/span[1]
${SIGNOUTBUTTON}          xpath=//ul[2]//div[@role='button'][2]
${EMAILINPUT}       xpath=//*[@id='login']
${PASSWORDINPUT}        xpath=//*[@id='password']
${MAINPAGEBUTTON}     xpath=//ul[1]//div[@role='button'][1]
${INVALID DATA CAPTION}     xpath=//span[contains(@class, 'caption')]
${LOGIN FORM}               xpath=//*[@id='__next']/form
${LANGUAGELISTBOX}      xpath=//div[2]/div/div
${POLSKIOPTIONBUTTON}       xpath=//div[3]/ul/li[1]
${ADDPLAYERBUTTON}            xpath=//a[contains(@href,'add')]
${SUBMITBUTTON}                xpath=//button[@type='submit']
${NAMEFIELD}            xpath=//input[@name='name']
${SURNAMEFIELD}         xpath=//input[@name='surname']
${AGEFIELD}             xpath=//input[@name='age']
${MAINPOSITIONFIELD}   xpath=//input[@name='mainPosition']
${FORMTITLE}                   xpath=//form//*[contains(@class, 'h5')]
${PROGRESSBARTOASTER}       xpath=//*[@role='alert']

*** Test Cases ***
Login to the system
    Open login page
    Type in email     # Provide valid email
    Type in password  # Provide valid password
    Click on the Sign in button
    Assert dashboard
    [Teardown]    Close Browser

Log in to the system with invalid password
    Open login page
    Type in email     # Provide valid email
    Type in incorrect password  # Provide incorrect password
    Click on the Sign in button
    Assert password error
    [Teardown]    Close Browser

Log out of the system
    Open login page
    Type in email     # Provide valid email
    Type in password  # Provide valid password
    Click on the Sign in button
    Click on the Sign out button
    Assert Login page
    [Teardown]    Close Browser

Change language to Polish
    Open login page
    Click on the Change language button
    Assert language change
    [Teardown]    Close Browser

Add player
    Open login page
    Type in email     # Provide valid email
    Type in password  # Provide valid password
    Click on the Sign in button
    Click on the Add player button
    Type in name      # Provide player's name
    Type in surname   # Provide player's surname
    Type in age       # Provide player's age
    Type in main position   # Provide player's main position
    Click on the Submit button
    Assert edit player page
    [Teardown]    Close Browser

*** Keywords ***
Open login page
    Open Browser    ${LOGIN URL}        ${BROWSER}
    Title Should Be     Scouts panel - sign in

Type in email
    Input Text    ${EMAILINPUT}     user09@getnada.com

Type in password
    Input Text      ${PASSWORDINPUT}     Test-1234

Type in incorrect password
    Input Text    ${PASSWORDINPUT}     Test1234

Click on the Sign in button
    Click Element       ${SIGNINBUTTON}

Click on the Sign out button
    Wait Until Element Is Visible   ${MAINPAGEBUTTON}       20s
    Click Element    ${SIGNOUTBUTTON}

Assert dashboard
    Wait Until Element Is Visible       ${MAINPAGEBUTTON}       20s
    Title Should Be     Scouts panel
    Capture Page Screenshot    alert.png

Assert password error
    Wait Until Element Is Visible    ${INVALID DATA CAPTION}
    Element Text Should Be      ${INVALID DATA CAPTION}     Identifier or password invalid.
    Capture Page Screenshot     screenshots/login/password-error.png

Assert login page
    Wait Until Element Is Visible    ${LOGIN FORM}      20s
    Title Should Be     Scouts panel - sign in
    Capture Page Screenshot    screenshots/login/login-page.png

Click on the Change language button
    Click Element    ${LANGUAGELISTBOX}
    Click Element    ${POLSKIOPTIONBUTTON}

Assert language change
    Wait Until Element Is Visible    ${SIGNINBUTTON}
    Title Should Be     Scouts panel - zaloguj

Click on the Add player button
    Wait Until Element Is Visible       ${MAINPAGEBUTTON}       20s
    Click Element    ${ADDPLAYERBUTTON}

Type in name
    Wait Until Element Is Visible       ${FORMTITLE}
    Input Text      ${NAMEFIELD}    Marian

Type in surname
    Input Text      ${SURNAMEFIELD}     Kowalski

Type in age
    Input Text      ${AGEFIELD}     01-01-1986

Type in main position
    Input Text      ${MAINPOSITIONFIELD}       Striker

Click on the Submit button
    Click Element    ${SUBMITBUTTON}

Assert edit player page
    Wait Until Element Is Visible    ${PROGRESSBARTOASTER}      20s
    Element Should Contain      ${FORMTITLE}   Edit player
    Capture Page Screenshot    screenshots/add-player/player-added.png
