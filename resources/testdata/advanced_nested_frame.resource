#testdata die willekeurige waarden genereert
*** Settings ***
Library    String
Library    Collections

*** Variables ***
@{TRAVEL_PREFERENCES}
...    Business
...    Family
...    Solo Traveller
...    Adventure

*** Keywords ***
Generate Travel Enquiry Data
    ${randomId}=    Generate Random String    8    [LETTERS]

    ${name}=     Set Variable    Test User ${randomId}
    ${email}=    Set Variable    test.${randomId}@example.com

    ${preference}=    Evaluate    random.choice($TRAVEL_PREFERENCES)    modules=random

    ${travelData}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    preference=${preference}

    RETURN    ${travelData}