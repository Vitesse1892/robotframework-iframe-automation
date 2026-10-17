*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}    https://www.playwrightautomation.com/practice.html
${BROWSER}     chromium

*** Keywords ***
Open Practice Application
    New Browser    ${BROWSER}    headless=False
    New Context
    New Page    ${BASE_URL}

Close Practice Application
    Close Browser