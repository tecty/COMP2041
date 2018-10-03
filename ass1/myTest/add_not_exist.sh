#!/bin/sh
./legit.pl init
./legit.pl branch master
touch a
./legit.pl add a
./legit.pl commit -m "nothing"

touch b
./legit.pl add b
./legit.pl commit -m "nothing again "

./legit.pl add c
./legit.pl commit -m "i will be fail here"
