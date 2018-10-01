#!/bin/bash
# 26
./legit.pl init
seq -f "line %.0f" 1 7 >a
seq -f "line %.0f" 1 7 >b
seq -f "line %.0f" 1 7 >c
seq -f "line %.0f" 1 7 >d
./legit.pl add a b c d
./legit.pl commit -m commit-0
./legit.pl branch b1
./legit.pl checkout b1
seq -f "line %.0f" 0 7 >a
seq -f "line %.0f" 1 8 >b
seq -f "line %.0f" 0 8 >c
sed -i 4d d
seq -f "line %.0f" 1 7 >e
./legit.pl add e
./legit.pl commit -a -m commit-1
./legit.pl checkout master
seq -f "line %.0f" 1 8 >a
seq -f "line %.0f" 0 7 >b
sed -i 4d c
seq -f "line %.0f" 0 8 >d
seq -f "line %.0f" 1 7 >f
./legit.pl add f
./legit.pl commit -a -m commit-2
./legit.pl merge -m merge1 b1
./legit.pl log
./legit.pl status
