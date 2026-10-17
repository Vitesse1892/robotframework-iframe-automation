*** Settings ***
Library    Browser
Library    Collections
Library    String


*** Variables ***
#frames
${PAYMENT_FRAME}              iframe[data-testid="frame-payment-82"]

#locators - main document
${PAYMENT_STATUS_DISPLAY}     [data-testid="payment-status-display"]
${PAYMENT_BALANCE_DISPLAY}    [data-testid="payment-balance-display"]
${PAYMENT_RESULT_DISPLAY}     [data-testid="payment-result-display"]

# Payment Frame - Form Fields
${CARD_HOLDER}                [data-testid="card-holder"]
${CARD_NUMBER}                [data-testid="card-number"]
${CARD_EXPIRY}                [data-testid="expiry-date"]
${CARD_CVV}                   [data-testid="cvv"]
${PAY_BUTTON}                 [data-testid="btn-pay-now"]
${PAYMENT_ERROR}              [data-testid="payment-form-error"]

*** Keywords ***
Fill Payment Form
    [Arguments]    ${payment}

    Fill Text    ${PAYMENT_FRAME} >>> ${CARD_HOLDER}    ${payment}[holder]
    Fill Text    ${PAYMENT_FRAME} >>> ${CARD_NUMBER}    ${payment}[number]
    Fill Text    ${PAYMENT_FRAME} >>> ${CARD_EXPIRY}    ${payment}[expiry]
    Fill Text    ${PAYMENT_FRAME} >>> ${CARD_CVV}       ${payment}[cvv]

Submit Payment
    Click    ${PAYMENT_FRAME} >>> ${PAY_BUTTON}

Verify Payment Results
    [Arguments]    ${payment}

    ${actualStatus}=     Get Text    ${PAYMENT_STATUS_DISPLAY}
    ${actualBalance}=    Get Text    ${PAYMENT_BALANCE_DISPLAY}
    ${actualResult}=     Get Text    ${PAYMENT_RESULT_DISPLAY}

    Should Be Equal As Strings    ${actualStatus}     ${payment}[status]
    Should Be Equal As Strings    ${actualBalance}    ${payment}[balance]
    Should Be Equal As Strings    ${actualResult}     ${payment}[result]