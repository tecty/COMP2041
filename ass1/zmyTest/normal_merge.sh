#!/bin/bash
# normal merge with changed context
./legit.pl init
echo first > a
echo second > b
./legit.pl add a
./legit.pl commit -m "first"
./legit.pl branch b1
./legit.pl status
echo "--second lin\n str\s\s\s\\--" > a
./legit.pl status
./legit.pl add b
echo "changed b" >> b
./legit.pl commit -a -m "change a and b\n"
./legit.pl show :a
./legit.pl show 0:a
./legit.pl show :b
./legit.pl show 0:b
./legit.pl rm a
./legit.pl checkout b1
./legit.pl merge master -m "merge"
./legit.pl commit -a -m "merge a and b\n"
./legit.pl merge master -m "merge"
./legit.pl status