#!/bin/bash
./legit init
touch a
./legit add a
./legit commit -m "master 0"
./legit branch another

./legit checkout another
touch c
./legit add c
./legit commit -m "another 1"

./legit checkout master
touch b
./legit add b
./legit commit -m "master 2"

./legit checkout another
touch d
./legit add d
./legit commit -m "another 3"

./legit checkout master
./legit merge another -m "master 4"
