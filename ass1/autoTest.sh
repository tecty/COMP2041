#!/usr/bin/env bash

# init the counter value
fail_count=0;
count=0;

function cleanEnv() {
  # clean the environment
  rm -rf .legit;
  # a common variable to return
  fail=0;
}

for test in `ls tests`; do
  # clean the state
  cleanEnv;
  # atttach the test folder name to excute
  echo "Test:" $test;
  test=`echo "tests/$test"`;

  # give the file a premission to execute
  chmod u+x $test;

  # excute the command;
  if  ! $test ; then
    ((fail_count ++));
  fi;

  ((count ++));
done;


# clean the state
cleanEnv;

echo "Test $count, Failed $fail_count";
