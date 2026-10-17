*** Settings ***
Library    Browser
Library    Collections
Library    String

*** Variables ***
#containers - De hoofdonderdelen van je applicatie waarin meerdere elementen zitten.
${DASHBOARD}                  [data-testid="travel-dashboard"]

#frames - De iFrame-elementen die een eigen document bevatten.
${FLIGHT_FRAME}               iframe[data-testid="frame-flight-status"]
${HOTEL_FRAME}                iframe[data-testid="frame-hotel-avail"]

# Locators - Main Document - Elementen die rechtstreeks vanuit de hoofdpagina bereikbaar zijn.
${DASHBOARD_FRAMES}           [data-testid="travel-dashboard"] iframe
${FRAME_COUNTER}              [data-testid="frame-count-total"]

# Locators - Flight Frame
${FLIGHT_TITLE}               p.wh
${FLIGHT_ROWS}                p:has(strong)
${FLIGHT_NUMBER}              strong
${FLIGHT_ROUTE}               span:first-child
${FLIGHT_STATUS}              span:last-child

# Locators - Hotel Frame
${HOTEL_TITLE}                p.wh
${HOTEL_ROWS}                 p:has(strong)
${HOTEL_NAME}                 strong
${HOTEL_ROOMS}                span:last-child

*** Keywords ***
Get Dashboard Frame Count
    ${count}=    Get Element Count    ${DASHBOARD_FRAMES}
    RETURN    ${count}

Get Displayed Frame Count
    ${text}=    Get Text    ${FRAME_COUNTER}
    ${count}=    Convert To Integer    ${text}
    RETURN    ${count}

Get Flight Widget Title
    ${text}=    Get Text    ${FLIGHT_FRAME} >>> ${FLIGHT_TITLE}
    RETURN    ${text}

Get Hotel Widget Title
    ${text}=    Get Text    ${HOTEL_FRAME} >>> ${HOTEL_TITLE}
    RETURN    ${text}

Get Flight Data
    ${flights}=    Create Dictionary
    ${count}=      Get Element Count    ${FLIGHT_FRAME} >>> ${FLIGHT_ROWS}

    FOR    ${index}    IN RANGE    ${count}
        ${row}=    Set Variable    ${FLIGHT_ROWS} >> nth=${index}

        ${actualFlightNumber}=        Get Text    ${FLIGHT_FRAME} >>> ${row} >> ${FLIGHT_NUMBER}
        ${actualFlightRoute}=           Get Text    ${FLIGHT_FRAME} >>> ${row} >> ${FLIGHT_ROUTE}
        ${actualFlightStatus}=              Get Text    ${FLIGHT_FRAME} >>> ${row} >> ${FLIGHT_STATUS}

        ${route}=    Replace String    ${actualFlightRoute}    ${actualFlightNumber}    ${EMPTY}
        ${route}=    Strip String      ${route}

        ${flight}=    Create Dictionary
        ...    route=${route}
        ...    status=${actualFlightStatus}

        Dictionary Should Not Contain Key    ${flights}    ${actualFlightNumber}
        Set To Dictionary    ${flights}    ${actualFlightNumber}=${flight}
    END

    RETURN    ${flights}

Get Hotel Data
    ${hotels}=    Create Dictionary
    ${count}=     Get Element Count    ${HOTEL_FRAME} >>> ${HOTEL_ROWS}

    FOR    ${index}    IN RANGE    ${count}
        ${row}=    Set Variable    ${HOTEL_ROWS} >> nth=${index}

        ${actualHotelName}=     Get Text    ${HOTEL_FRAME} >>> ${row} >> ${HOTEL_NAME}
        ${actualHotelRooms}=    Get Text    ${HOTEL_FRAME} >>> ${row} >> ${HOTEL_ROOMS}

        Dictionary Should Not Contain Key    ${hotels}    ${actualHotelName}
        Set To Dictionary    ${hotels}    ${actualHotelName}=${actualHotelRooms}
    END

    RETURN    ${hotels}