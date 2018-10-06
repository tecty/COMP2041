#!/bin/bash

a_files=`ls $1/*`;
b_files=`ls $2/*`;
same_files=();
index=0;
for file in $a_files
do
    b_file=`echo ${file} | sed s/^$1/$2/`
    if  `diff ${file} ${b_file}  > /dev/null 2>/dev/null` ;then
        same_files[$index]=`echo $file | sed s?^$1/??` 
        # echo ${same_files[$index]}
        # echo $index
        ((index ++));
    fi
done
sorted=($(sort <<<"${same_files[*]}"))
printf "%s\n" "${sorted[@]}"