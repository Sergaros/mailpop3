#!/bin/sh

print_title "stls.js"
RANDOMID=$RANDOM

print_test "Sending test message to $EMAIL (str: $RANDOMID)"
OUTPUT=`./sendmail.sh 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "No login"
OUTPUT=`node stls.js --username $USER --password $PASS --host $HOST --port $PORT --login off`;
print_result 0 $OUTPUT

print_test "Login only"
OUTPUT=`node stls.js --username $USER --password $PASS --host $HOST --port $PORT --login on`;
print_result 0 $OUTPUT

print_test "Login and message download"
OUTPUT=`node stls.js --username $USER --password $PASS --host $HOST --port $PORT --login on --download on`
OUTPUT=`echo $OUTPUT | grep $RANDOMID`

if [ $? -eq 1 ]; then OUTPUT="fail"; fi

print_result 0 $OUTPUT
