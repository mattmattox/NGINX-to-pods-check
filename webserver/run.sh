#!/bin/bash
# Vendor script that runs on every container update event

if [[ "$STATUS" == "Good" ]]
then
	echo "Good"
	apachectl -D FOREGROUND
fi
if [[ "$STATUS" == "Bad" ]]
then
	echo "Bad"
	while true; do sleep 100000000; done
fi
