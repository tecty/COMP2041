#!/bin/bash
# 29
./legit.pl init
echo 0 >level0
./legit.pl add level0
./legit.pl commit -m root
./legit.pl branch b0
./legit.pl branch b1
./legit.pl checkout b0
echo 0 >level1
./legit.pl add level1
./legit.pl commit -m 0
./legit.pl checkout b1
echo 1 >level1
./legit.pl add level1
./legit.pl commit -m 1
./legit.pl checkout b0
./legit.pl branch b00
./legit.pl branch b01
./legit.pl checkout b1
./legit.pl branch b10
./legit.pl branch b11
./legit.pl checkout b00
echo 00 >level2
./legit.pl add level2
./legit.pl commit -m 00
./legit.pl checkout b01
echo 01 >level2
./legit.pl add level2
./legit.pl commit -m 01
./legit.pl checkout b10
echo 10 >level2
./legit.pl add level2
./legit.pl commit -m 10
./legit.pl checkout b11
echo 11 >level2
./legit.pl add level2
./legit.pl commit -m 11
./legit.pl checkout master
./legit.pl log
./legit.pl checkout b1
./legit.pl log
./legit.pl checkout b01
./legit.pl log
./legit.pl checkout b11
./legit.pl log
./legit.pl checkout master
./legit.pl merge b0 -m merge0
./legit.pl merge b00 -m merge00
./legit.pl log
