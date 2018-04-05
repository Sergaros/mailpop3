#!/bin/sh

print_title "apop.js"
RANDOMID=$RANDOM

print_test "Sending test message (str: $RANDOMID)"
OUTPUT=`./sendmail.sh 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "Correct auth"
OUTPUT=`node apop.js --username $USER --password $PASS --host $HOST --port $PORT --login on`;
print_result 0 $OUTPUT

print_test "Invalid auth"
OUTPUT=`node apop.js --username $USER --password ${PASS}a --host $HOST --port $PORT --login on`;
print_result 1 $OUTPUT

print_test "Login and message download"
OUTPUT=`node apop.js --username $USER --password $PASS --host $HOST --port $PORT --login on --download on`
OUTPUT=`echo $OUTPUT | grep $RANDOMID`

if [ $? -eq 1 ]; then OUTPUT="fail"; fi

print_result 0 $OUTPUT
