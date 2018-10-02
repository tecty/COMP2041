# #!/usr/bin/env bash
./legit.pl init
touch a
./legit.pl add a
./legit.pl commit -m "commit -0"
./legit.pl branch another
./legit.pl checkout another
touch b
./legit.pl add b
./legit.pl commit -m "commit -1"
touch c
./legit.pl add c
./legit.pl commit -m "commit -2"
touch d
./legit.pl add d
./legit.pl commit -m "commit -3"
# try to fast forward merge
./legit.pl merge master -m "merge master"
./legit.pl merge 1 -m "merge ancestor commit"
./legit.pl status
