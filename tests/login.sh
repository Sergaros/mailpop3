#!/bin/sh

print_title "login.js"
print_test "Correct auth"
OUTPUT=`node login.js --username $USER --password $PASS --host $HOST --port $PORT`;
print_result 0 $OUTPUT

print_test "Invalid auth"
OUTPUT=`node login.js --username $USER --password ${PASS}a --host $HOST --port $PORT`
print_result 1 $OUTPUT

print_test "Correct host"
OUTPUT=`node login.js --username $USER --password $PASS --host $HOST --port $PORT`;
print_result 0 $OUTPUT

print_test "Invalid host"
OUTPUT=`node login.js --username $USER --password $PASS --host ${HOST}a --port $PORT`
print_result 1 $OUTPUT

print_test "Correct port"
OUTPUT=`node login.js --username $USER --password $PASS --host $HOST --port $PORT`;
print_result 0 $OUTPUT 

print_test "Invalid port"
OUTPUT=`node login.js --username $USER --password $PASS --host $HOST --port ${PORT}1`
print_result 1 $OUTPUT
