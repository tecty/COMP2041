#!/usr/bin/env bash

fail=0;

function check_output() {
  if [[ $1 != $2 ]]; then
    echo "> Your init out put is not correct";
    echo "> Require: $2";
    echo "> Yours: $1";
    # assert a flag indicate that this test is failed
    fail=1;
  fi
}


# touch all the file
touch a b c d e f g h
./legit.pl add a b c d e f
# require a correct message
output=`./legit.pl commit -m 'first commit'`

# remove the files created
rm a b c d e f g h


check_output $output "Commited as commit 0";

exit $fail;
