#!/bin/sh

RANDOMID=$RANDOM

print_test "Sending test message to $EMAIL (str: $RANDOMID)"
OUTPUT=`./sendmail.sh -q 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "Wrong port"
OUTPUT=`node tls.js --username $USER --password $PASS --host $HOST --port $PORT --login off`;
print_result 1 $OUTPUT

print_test "No login"
OUTPUT=`node tls.js --username $USER --password $PASS --host $HOST --port $TLSPORT --login off`;
print_result 0 $OUTPUT

print_test "Login only"
OUTPUT=`node tls.js --username $USER --password $PASS --host $HOST --port $TLSPORT --login on`;
print_result 0 $OUTPUT

print_test "Login and message download"
OUTPUT=`node tls.js --username $USER --password $PASS --host $HOST --port $TLSPORT --login on --download on`
OUTPUT=`echo $OUTPUT | grep $RANDOMID`

if [ $? -eq 1 ]; then OUTPUT="fail"; fi

print_result 0 $OUTPUT
