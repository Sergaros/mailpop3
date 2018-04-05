#!/bin/sh

QUIET=0
if [ "$1" = "-q" ]; then
	QUIET=1
	shift
fi

if [ $QUIET -eq 0 ]; then

	echo "sendmail.sh v0.1 - a utility to pump email into an SMTP server"
	echo "Copyright (c) 2011 Ditesh Shashikant Gathani <ditesh@gathani.org>"
	echo

fi


if [ $# -ne 4 ]; then

	echo "Usage:"
	echo "	sendmail.sh [-q] [number of emails] [to] [subject] [body]"
	exit 1

fi

if [ $QUIET -eq 0 ]; then

	echo "Sending $1 email(s)"
	echo "	to: 		$2"
	echo "	subject: 	\"$3\""
	echo "	body: 		\"$4\""
	echo

fi

for i in `seq 1 $1`; do
	echo "$4" | mail -s "$3" "$2";
done
