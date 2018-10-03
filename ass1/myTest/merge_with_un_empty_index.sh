#!/bin/bash
./legit.pl init
touch a
./legit.pl add a
./legit.pl commit -m "master 0"
./legit.pl branch another

./legit.pl checkout another
touch c
./legit.pl add c
./legit.pl commit -m "another 1"

./legit.pl checkout master
touch b
./legit.pl add b
./legit.pl commit -m "master 2"

./legit.pl checkout another
touch d
./legit.pl add d
./legit.pl commit -m "another 3"

./legit.pl checkout master
touch e
./legit.pl add e
# not sure this will merge 
./legit.pl merge another -m "master 4"

./legit.pl log
./legit.pl status
ls
