#!/bin/bash

# check whether is has given 2 arguements
if (($# != 2))
then
    echo "Usage: $0 <number of lines> <string>" 1>&2
    exit 1
fi



# check whether the argument 1 is a positive integer
if ! test $1 -ge 0  2>/dev/null
then 
    # echo the given message to the stderr 
    echo "$0: argument 1 must be a non-negative integer" 1>&2
    # stop the script 
    exit 1
fi 

# echo the time has given  
for((i=0;i<$1;i++));
do
    echo $2
done
