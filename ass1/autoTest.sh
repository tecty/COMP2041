#!/usr/bin/env bash

# init the counter value
fail=0;
count=0;

function clean {
  # clean the environment
  rm -rf .legit;
  # a common variable to return
  fail= 0;
}


for test in `ls tests`; do
  # atttach the test folder name to excute
  echo "Test:" $test;
  test=`echo "tests/$test"`;

  # excute the command;
  if  ! bash $test ; then
    ((fail++));
  fi;

  ((count ++));
done;


echo "Test $count, Failed $fail";
