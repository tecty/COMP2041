#!/bin/sh
./legit.pl init
./legit.pl branch master
touch a
./legit.pl add a
./legit.pl commit -m "nothing"

touch b
./legit.pl add b
./legit.pl commit -m "nothing again "

# TODO: fetch the merge 's message of errors
./legit.pl merge h2
./legit.pl merge -m heee heee heee
./legit.pl merge heee heee -m heee
# merge to self 
./legit.pl merge 0
./legit.pl merge
