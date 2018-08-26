#!/usr/bin/env bash

# fetch by course name
cat $1 |
egrep "^COMP[29]041"  |
# fetch the names
cut -d"|"  -f3 |
sort| uniq|

# fetch the name
cut -d"," -f2 |
# remove the dummy space
sed "s/^ //g"|
sed "s/[ ]*$//g" |
# fetch the first name " the last string after , "
cut -d" " -f-1 |
# make every word into new line
# sed "s/ /\n/g" |
sort | uniq -c | sort -n |
 # fetch the most common one
tail -1 |
egrep -o "[a-zA-Z]*" |
cat
