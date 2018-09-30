#!/bin/sh
./legit.pl init
./legit.pl branch master
touch a
./legit.pl add a
./legit.pl commit -m "nothing"
./legit.pl branch master
