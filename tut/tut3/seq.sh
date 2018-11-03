#!/bin/bash

# default first is 1
first=1;
# default increament is 1 
inc=1;
# last fill be always the first input
last=$1;




if (( $# == 2 || $# == 3)) ; then 
    first=$1;
fi


# setting last 
if (($# == 2 )); then 
    last=$2;
fi
if (($#==3)); then 
    last=$3;
    # increment setting 
    inc=$2;
    
fi





for ((i=first; i <= last ; i += inc )) ; do
    echo ${i}
 
done; 
