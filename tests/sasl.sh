#!/bin/sh

int_title "sasl.js"
RANDOMID=$RANDOM

print_test "Sending test message to $EMAIL (str: $RANDOMID)"
OUTPUT=`./sendmail.sh -q 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "Valid PLAIN login without TLS"
OUTPUT=`node sasl.js --username $USER --password $PASS --host $HOST --port $PORT --auth plain`;
print_result 0 $OUTPUT

print_test "Valid CRAM-MD5 login without TLS"
OUTPUT=`node sasl.js --username $USER --password $PASS --host $HOST --port $PORT --auth "cram-md5"`;
print_result 0 $OUTPUT

print_test "Invalid PLAIN login without TLS"
OUTPUT=`node sasl.js --username $USER --password ${PASS}a --host $HOST --port $PORT --auth plain`;
print_result 1 $OUTPUT

print_test "Invalid CRAM-MD5 login without TLS"
OUTPUT=`node sasl.js --username $USER --password ${PASS}a --host $HOST --port $PORT --auth "cram-md5"`;
print_result 1 $OUTPUT

print_test "Valid PLAIN login with TLS"
OUTPUT=`node sasl.js --username $USER --password $PASS --host $HOST --port $TLSPORT --auth plain --tls on`;
print_result 0 $OUTPUT

print_test "Valid CRAM-MD5 login with TLS"
OUTPUT=`node sasl.js --username $USER --password $PASS --host $HOST --port $TLSPORT --auth "cram-md5" --tls on`;
print_result 0 $OUTPUT

print_test "Invalid PLAIN login with TLS"
OUTPUT=`node sasl.js --username $USER --password ${PASS}a --host $HOST --port $TLSPORT --auth plain --tls on`;
print_result 1 $OUTPUT

print_test "Invalid CRAM-MD5 login with TLS"
OUTPUT=`node sasl.js --username $USER --password ${PASS}a --host $HOST --port $TLSPORT --auth "cram-md5" --tls on`;
print_result 1 $OUTPUT

print_test "PLAIN login and message download"
OUTPUT=`node sasl.js --username $USER --password $PASS --host $HOST --port $PORT --auth plain --download on`
OUTPUT=`echo $OUTPUT | grep $RANDOMID`

if [ $? -eq 1 ]; then OUTPUT="fail"; fi

print_result 0 $OUTPUT

print_test "Sending another test message to $EMAIL (str: $RANDOMID)"
OUTPUT=`./sendmail.sh -q 1 $EMAIL "subject with $RANDOMID" "body with $RANDOMID"`
print_result 0 $OUTPUT

print_test "Sleeping 5 seconds"
OUTPUT=`sleep 5`
print_result 0 $OUTPUT

print_test "CRAM-MD5 login and message download"
OUTPUT=`node sasl.js --username $USER --password $PASS --host $HOST --port $PORT --auth "cram-md5" --download on`
OUTPUT=`echo $OUTPUT | grep $RANDOMID`

if [ $? -eq 1 ]; then OUTPUT="fail"; fi

print_result 0 $OUTPUT
