#!/usr/bin/env bash
./legit.pl init
touch a
./legit.pl add a
./legit.pl commit -m "commit -0"
./legit.pl branch another
./legit.pl checkout another
./legit.pl add b
./legit.pl commit -m "commit -1"
./legit.pl add c
./legit.pl commit -m "commit -2"
./legit.pl add d
./legit.pl commit -m "commit -3"
./legit.pl checkout master
# try to fast forward merge
./legit.pl merge another -m "Im a fast-forward merge"
./legit.pl status
