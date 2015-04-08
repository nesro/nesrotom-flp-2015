#!/bin/bash
diff <(./main < sample_input.txt) sample_output.txt
echo "return code: $?"
