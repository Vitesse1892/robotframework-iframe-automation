*** Variables ***
# Widget Titles
${EXPECTED_FLIGHT_TITLE}    Flight Status
${EXPECTED_HOTEL_TITLE}     Hotel Availability

# Flight Data
&{FLIGHT_PW101}
...    route=London → New York
...    status=On Time

&{FLIGHT_PW202}
...    route=Dubai → Singapore
...    status=Delayed

&{EXPECTED_FLIGHTS}
...    PW101=${FLIGHT_PW101}
...    PW202=${FLIGHT_PW202}

# Hotel Data
&{EXPECTED_HOTELS}
...    Grand Plaza=3 Rooms
...    City Suites=7 Rooms