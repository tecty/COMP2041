#!/usr/bin/env bash

output=`./legit.pl init`;

correct_output="Initialized empty legit repository in .legit";

if [[ $output != $correct_output ]]; then
  echo "Your init out put is not correct";
  echo "";
  echo "require: $correct_output";
  echo "Yours: $output";
fi



if ! ls -d .legit >/dev/null 2>&1; then
  echo "doesn't create .legit folder"
  # this test is failed
  fail=1;
fi

exit $fail
