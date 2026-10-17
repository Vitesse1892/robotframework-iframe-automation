*** Settings ***
Library     Collections
Resource    ../../resources/components/iframe/frame_counting.resource
Resource    ../../resources/testdata/travel_dashboard.resource
Resource    ../../resources/components/common.resource

Test Setup       Open Practice Application
Test Teardown    Close Practice Application

*** Test Cases ***
TC01 - Displayed Frame Count Should Match Actual Frame Count
    ${actual_count}=       Get Dashboard Frame Count
    ${displayed_count}=    Get Displayed Frame Count
    Should Be Equal As Integers    ${actual_count}    ${displayed_count}

TC02 - Verify flight data from iframe equals expected test data
    ${actual_flights}=    Get Flight Data
    Dictionaries Should Be Equal    ${actual_flights}    ${EXPECTED_FLIGHTS}

TC03 - Verify hotel data from iframe equals expected test data
    ${actual_hotels}=    Get Hotel Data
    Dictionaries Should Be Equal    ${actual_hotels}    ${EXPECTED_HOTELS}

TC04 - Verify data consistency when alternating between different iframes
    # Flight iframe
    ${actual_flights_before}=    Get Flight Data
    Dictionaries Should Be Equal    ${actual_flights_before}    ${EXPECTED_FLIGHTS}

    # Hotel iframe
    ${actual_hotels}=    Get Hotel Data
    Dictionaries Should Be Equal    ${actual_hotels}    ${EXPECTED_HOTELS}

    # Flight iframe again
    ${actual_flights_after}=    Get Flight Data
    Dictionaries Should Be Equal    ${actual_flights_after}    ${EXPECTED_FLIGHTS}