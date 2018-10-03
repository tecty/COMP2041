#!/bin/bash
# merge 2 branches with same index but different working tree or last commits
./legit.pl init
echo first > a
echo second > b
./legit.pl add a
touch c
./legit.pl add c
./legit.pl commit -m "first"
./legit.pl branch b1
./legit.pl rm c
./legit.pl commit -m "1 in master"
./legit.pl checkout b1
./legit.pl rm c
./legit.pl status
./legit.pl add b
echo "changed b" >> b
./legit.pl commit -a -m "changed b\n"
./legit.pl rm --cached b
./legit.pl status
# the files in index is the same as master, while the working tree is different
# and the commits are different 
# ./legit.pl merge master -m "merge" # this will trigger internal error
./legit.pl commit -a -m "merge a and b\n"
./legit.pl merge master -m "merge"
./legit.pl status
./legit.pl show :b
./legit.pl show :a