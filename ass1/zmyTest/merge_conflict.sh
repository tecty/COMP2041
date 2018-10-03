#!/bin/bash
# merge ftg and fhg to generate merge conflicts
./legit.pl init
echo f > a
./legit.pl add a
./legit.pl commit -m "first"
./legit.pl branch br
echo "t" >> a
echo "g" >> a
./legit.pl commit -a -m "second"
./legit.pl checkout br
echo "h" >> a
echo "g" >> a
./legit.pl commit -a -m "third"
./legit.pl merge master -m "4 merge"
./legit.pl show :a
cat a
./legit.pl checkout master
cat a
