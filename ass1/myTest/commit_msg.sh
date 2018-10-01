#!/usr/bin/env bash
#!/bin/sh
./legit.pl init
./legit.pl branch master
touch a
./legit.pl add a
./legit.pl commit
./legit.pl commit -ma
./legit.pl commit "assdsffg"
./legit.pl commit "-m asdfgg"
./legit.pl commit -m "nothing"
