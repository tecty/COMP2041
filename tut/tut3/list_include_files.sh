#!/bin/bash

for file in *.c ; do 
    echo $file "includes:"
    cat $file | egrep "\.h" | tr -d "<>" | sed "s/^#include /\t/"| cat 
done 

