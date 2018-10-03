#!/bin/sh
./legit.pl init
./legit.pl branch master
touch a
./legit.pl add a
./legit.pl commit -m "nothing"

./legit.pl branch b
./legit.pl checkout b
touch b
./legit.pl add b
./legit.pl commit -m "nothing again "

touch c
./legit.pl add c
# merge to self
./legit.pl merge b -m "Might be a failure"
