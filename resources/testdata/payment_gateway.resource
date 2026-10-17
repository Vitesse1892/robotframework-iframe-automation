*** Variables ***
# Approved Payment
&{PAYMENT_APPROVED}
...    holder=JOHN SMITH
...    number=4111111111111111
...    expiry=12/29
...    cvv=123
...    status=Approved
...    balance=₹1,25,000
...    result=Payment Successful

# Insufficient Balance
&{PAYMENT_INSUFFICIENT}
...    holder=ALEX JOHNSON
...    number=5555555555554444
...    expiry=08/28
...    cvv=456
...    status=Insufficient Balance
...    balance=₹120
...    result=Payment Failed

# Unknown Card
&{PAYMENT_UNKNOWN_CARD}
...    holder=JOHN SMITH
...    number=9999999999999999
...    expiry=12/29
...    cvv=123
...    status=Unknown Card
...    balance=—
...    result=Card Not Recognized