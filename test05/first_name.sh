#!/usr/bin/env bash

# fetch by course name
egrep "^COMP[29]041" $1 |
# fetch all the last name
egrep -o ", [a-zA-Z ]*"   |
# remove the "," and " " at the end of line
sed "s/[ ]*$//g" |
sed "s/^,[ ]*//g" |
cut -d" " -f1-  |
# remove new line to space
sed "s/\n/ /g" |
# let the space to new line
sed "s/ /\n/g" |
sort | uniq -c | sort -n | tail -n 1 |
sed "s/[\t ]*[0-9]*//g"
