#!/bin/sh
./legit.pl init
./legit.pl branch master
touch a
./legit.pl add a
./legit.pl commit -m "nothing"
./legit.pl branch master
./legit.pl branch
# deleting current branch
./legit.pl branch -d master
# delete an not exist branch
./legit.pl branch -d another

./legit.pl branch another
./legit.pl checkout another
# delettion of master branch
./legit.pl branch -d master
