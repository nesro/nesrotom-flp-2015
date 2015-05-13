#!/bin/bash
if make 1>/dev/null 2>&1; then
	echo "c compile: OK"
else
	echo "c compile: FAIL"
	exit 1
fi

if diff <(./main < sample_input.txt) sample_output.txt; then
	echo "c test: OK"
else
	echo "c test: FAIL"
fi

