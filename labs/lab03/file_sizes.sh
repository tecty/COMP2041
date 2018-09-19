#!/bin/bash

# the array store the file name of different file size
# large_array=( )
small_array=("")
medium_array=("")
large_array=("")
# the array siize of file name
small_index=1
medium_index=1
large_index=1

# fetch out all the file name
for file_name in `ls`
do
    # fetch all the line count from each file
    line_count=`wc -l $file_name | cut -f1 -d' '`;
    if  (($line_count < 10 )); then
        # small file
        small_array[small_index]=${file_name}
        ((small_index++))
    elif (( $line_count < 100 )); then
        # medium file
        medium_array[medium_index]=${file_name}
        ((medium_index++))
    else
        # large file
        large_array[$large_index]="${file_name}"
        ((large_index++))
    fi
    # echo $line_count
done
# dump all those promt
echo "Small files: " ${small_array[@]}
echo "Medium-sized files:" ${medium_array[@]}
echo "Large files:" ${large_array[@]}
