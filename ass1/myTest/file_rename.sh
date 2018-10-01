#!/usr/bin/env bash

# file renames
./legit.pl init
seq 1 7 >a
./legit.pl add a
git add a
git commit -m "commit 0"
mv a b
git status
git add b
git commit -m "change name of b"
git status
touch a
git add a
git commit -m "another a"
mv b a
git status
git commit -ma "b or a conflict"
