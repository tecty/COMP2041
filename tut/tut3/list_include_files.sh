#!/bin/bash

for file in *.c ; do 
    echo $file "includes:"
    cat $file | egrep "#include " | egrep -o "[^<>\"]*\.h" | sed "s/^/\t/" |  cat 
done 

