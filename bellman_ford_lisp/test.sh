#!/bin/bash
diff <(clisp ./main.lisp < sample_input.txt) sample_output.txt
echo "return code: $?"
