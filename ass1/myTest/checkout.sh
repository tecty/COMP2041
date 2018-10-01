#!/bin/sh
./legit.pl init
./legit.pl branch master
touch a
./legit.pl add a
./legit.pl commit -m "nothing"
./legit.pl branch another

# usage print
./legit.pl checkout and another
./legit.pl checkout -a
./legit.pl checkout

# error when checkout current  ?
./legit.pl checkout another
./legit.pl checkout another
# error when checkotu non exist branch
./legit.pl checkout and
