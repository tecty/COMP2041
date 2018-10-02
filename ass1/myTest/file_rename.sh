#!/usr/bin/env bash

# file renames
./legit.pl init
seq 1 7 >a
./legit.pl add a
./legit.pl add a
./legit.pl commit -m "commit 0"
mv a b
./legit.pl status
./legit.pl add b
./legit.pl commit -m "change name of b"
./legit.pl status
touch a
./legit.pl add a
./legit.pl commit -m "another a"
mv b a
./legit.pl status
./legit.pl commit -ma "b or a conflict"
