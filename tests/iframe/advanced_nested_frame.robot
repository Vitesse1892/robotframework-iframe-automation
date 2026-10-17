*** Settings ***
Resource    ../../resources/components/iframe/advanced_nested_frame.resource
Resource    ../../resources/testdata/advanced_nested_frame.resource
Resource    ../../resources/components/common.resource

Test Setup       Open Practice Application
Test Teardown    Close Practice Application

*** Test Cases ***
TC01 - Verify nested frame travel enquiry
    ${travelData}=    Generate Travel Enquiry Data

    Fill Travel Enquiry Form
    ...    ${travelData}[name]
    ...    ${travelData}[email]

    Select Travel Preference    ${travelData}[preference]

    Submit Travel Enquiry
    Verify Travel Enquiry Success

#Het doel is voor nu een happy flow te testen, waarin een formulier mét nested frame succesvol kan worden ingevuld.
#Uitbreiden kan bijvoorbeeld door te checken dat nedted frame niet zichtbaar is zonder dat naam/email van valide waarden zijn voorzien
#verder validatiemogelijkheden testen
