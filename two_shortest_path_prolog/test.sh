#!/bin/bash

for i in 1 2 3 4 all; do
	if diff <(cat input${i}.txt | swipl -s main.pl -g main -t halt \
		2>/dev/null | egrep "^[0-9]|^B") output${i}.txt; then
		echo "prolog test $i: OK"
	else
		echo "prolog test $i: FAIL"  
		#echo "cat input${i}.txt | swipl -s main.pl -g main -t halt"
	fi
done

