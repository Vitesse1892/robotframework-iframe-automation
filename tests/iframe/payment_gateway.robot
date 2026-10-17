*** Settings ***
Resource    ../../resources/components/iframe/payment_gateway.resource
Resource    ../../resources/testdata/payment_gateway.resource
Resource    ../../resources/components/common.resource

Test Setup       Open Practice Application
Test Teardown    Close Practice Application

*** Test Cases ***
TC01 - Verify approved payment
    Fill Payment Form    ${PAYMENT_APPROVED}
    Submit Payment
    Verify Payment Results    ${PAYMENT_APPROVED}

TC02 - Verify insufficient balance payment
    Fill Payment Form    ${PAYMENT_INSUFFICIENT}
    Submit Payment
    Verify Payment Results    ${PAYMENT_INSUFFICIENT}

TC03 - Verify unknown card payment
    Fill Payment Form    ${PAYMENT_UNKNOWN_CARD}
    Submit Payment
    Verify Payment Results    ${PAYMENT_UNKNOWN_CARD}