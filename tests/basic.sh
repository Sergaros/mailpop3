#!/bin/sh

print_title "basic.js"
RANDOMID=$RANDOM

print_test "Sending test message to $EMAIL (str: $RANDOMID)"
OUTPUT=`./sendmail.sh -q 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "Sleeping 5 seconds"
OUTPUT=`sleep 5`
print_result 0 $OUTPUT

print_test "CAPA test"
OUTPUT=`node basic.js --username $USER --password $PASS --host $HOST --port $PORT`;
print_result 0 $OUTPUT

print_test "RETR test"
OUTPUT=`node basic.js --username $USER --password $PASS --host $HOST --port $PORT --download on`;
OUTPUT=`echo $OUTPUT | grep $RANDOMID`
if [ $? -eq 1 ]; then OUTPUT="fail"; fi
print_result 0 $OUTPUT

print_test "RETR, DELE test"
OUTPUT=`node basic.js --username $USER --password $PASS --host $HOST --port $PORT --download on --dele on`;
OUTPUT=`node basic.js --username $USER --password $PASS --host $HOST --port $PORT --download on`;
OUTPUT=`echo $OUTPUT | grep $RANDOMID`
if [ $? -eq 0 ]; then OUTPUT="fail"; fi
print_result 0 $OUTPUT

RANDOMID=$RANDOM
print_test "Sending test message to $EMAIL (str: $RANDOMID)"
OUTPUT=`./sendmail.sh -q 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "Sleeping 5 seconds"
OUTPUT=`sleep 5`
print_result 0 $OUTPUT

print_test "DELE test"
OUTPUT=`node basic.js --username $USER --password $PASS --host $HOST --port $PORT --dele on`;
OUTPUT=`node basic.js --username $USER --password $PASS --host $HOST --port $PORT --download on`;
OUTPUT=`echo $OUTPUT | grep $RANDOMID`
if [ $? -eq 0 ]; then OUTPUT="fail"; fi
print_result 0 $OUTPUT

RANDOMID=$RANDOM
print_test "Sending test message to $EMAIL (str: $RANDOMID)"
OUTPUT=`./sendmail.sh -q 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "Sleeping 5 seconds"
OUTPUT=`sleep 5`
print_result 0 $OUTPUT

print_test "DELE, RSET, RETR test"
OUTPUT=`node basic.js --username $USER --password $PASS --host $HOST --port $PORT --dele on --rset on --download on`;
OUTPUT=`echo $OUTPUT | grep $RANDOMID`
if [ $? -eq 1 ]; then OUTPUT="fail"; fi
print_result 0 $OUTPUT
