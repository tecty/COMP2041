#!/bin/bash
# errors while no commits yet
./legit.pl init
./legit.pl commit -m "first" # commit while nothing in index
./legit.pl add a # add unexist file
./legit.pl commit -m "first" # commit while nothing in index
./legit.pl branch b1
echo "--second lin\n str\s\s\s\\--" > a
./legit.pl checkout b1
./legit.pl rm --cached b
./legit.pl commit -m "second"
./legit.pl checkout master
./legit.pl merge 1 -m "merge the commit"
./legit.pl log
#./legit.pl status
./legit.pl show :a
