#!/bin/bash
if diff <(clisp ./main.lisp < sample_input.txt) sample_output.txt; then
	echo "lisp test: OK"
else
	echo "lisp test: FAIL"
fi
