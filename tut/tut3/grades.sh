#!/bin/bash

while read id mark condition
do
    # insert mark/grade checking here
    
    re="[a-zA-Z]"
    if [[ $mark =~ $re   ]] ; then 
        mark=`echo "?? (${mark})" ` 
    else 
        if (($mark \< 0)); then 
            mark=`echo "?? (${mark})" `
        elif (($mark \< 50)); then 
            mark="FL"
        elif (($mark \< 65)); then 
            mark="PS"
        elif (($mark \< 75)); then 
            mark="CR"
        elif (($mark \< 85)); then 
            mark="DN"
        elif (($mark \< 100)); then 
            mark="HD"
        else 
            mark=`echo "?? (${mark})" ` 
        fi
    fi    
    echo ${id} ${mark}
done
