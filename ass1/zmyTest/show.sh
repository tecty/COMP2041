#!/bin/bash
# test several cases of show
./legit.pl init
./legit.pl show :a
touch a b
./legit.pl show :a
./legit.pl add a
./legit.pl show :a
./legit.pl commit -m "first"
./legit.pl show :a
./legit.pl show -1:a
./legit.pl show 10:a
./legit.pl show 0:a
./legit.pl branch b1
echo "--second lin\n str\s\s\s\\--" > a
./legit.pl checkout b1
./legit.pl show :a
cat a
./legit.pl rm --cached b
./legit.pl show :b # show something that has been deleted
./legit.pl show 0:b # show something that has been deleted
./legit.pl add b
./legit.pl commit -m "second"
./legit.pl show 1:b
./legit.pl show 1:a
./legit.pl show :a 
./legit.pl checkout master
./legit.pl show :b
./legit.pl show 1:b # show commits that are not in current branch
./legit.pl show 1:a
./legit.pl merge 1 -m "merge the commit"
./legit.pl show 1:b 
./legit.pl show 1:a
./legit.pl show :a
cat a
./legit.pl status
./legit.pl log
