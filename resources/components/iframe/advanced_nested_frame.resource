*** Settings ***
Library    Browser
Library    Collections
Library    String

*** Variables ***
#frames
${FEEDBACK_FRAME}                  iframe[data-testid="frame-feedback"]
${TRAVEL_PREFS_FRAME}               iframe[data-testid="frame-travel-prefs"]

# Feedback frame - Form fields
${FEEDBACK_NAME}                   [data-testid="feedback-name"]
${FEEDBACK_EMAIL}                  [data-testid="feedback-email"]

# Child frame - Travel preferences
${TRAVEL_PREFERENCE}                input[name="travel-type"][value="{preference}"]

# Parent frame - Submit and result
${FEEDBACK_SUBMIT_BUTTON}           [data-testid="btn-submit-enquiry"]
${FEEDBACK_SUCCESS_MESSAGE}         [data-testid="enquiry-success"]

*** Keywords ***
Fill Travel Enquiry Form
    [Arguments]    ${name}    ${email}

    Fill Text    ${FEEDBACK_FRAME} >>> ${FEEDBACK_NAME}     ${name}
    Fill Text    ${FEEDBACK_FRAME} >>> ${FEEDBACK_EMAIL}    ${email}

Select Travel Preference
    [Arguments]    ${preference}

    ${selector}=    Replace String    ${TRAVEL_PREFERENCE}    {preference}    ${preference}
    Click    ${FEEDBACK_FRAME} >>> ${TRAVEL_PREFS_FRAME} >>> ${selector}

Submit Travel Enquiry
    Click    ${FEEDBACK_FRAME} >>> ${FEEDBACK_SUBMIT_BUTTON}

Verify Travel Enquiry Success
    Wait For Elements State    ${FEEDBACK_FRAME} >>> ${FEEDBACK_SUCCESS_MESSAGE}    visible   