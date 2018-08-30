#!/bin/bash

if [[ $# != 2 ]]; then
  echo "usage $0 <Shuffle Script> <Test Input File>"
fi

testInput=$2

function test() {

  # fetch a result
  ./$1 < $testInput > out_$2.tmp

  sort out_$2.tmp > sorted_$2.tmp

  if ! diff "sorted_$2.tmp" "sorted_Input.tmp" ; then
    echo  "Error on $2 test"
    # exit the test
    exit 1
  fi

  # delete the result
  rm "out_$2.tmp" "sorted_$2.tmp"
}
# sort the numbers
sort "$testInput" > "sorted_Input.tmp"

for (( i = 0; i < 10; i++ )); do
  # do 10 times of test
  test $1 $i
done

# remove the sorted input
rm   sorted_Input.tmp
exit 0 
