#!/bin/bash

same_files=();
index=0;
if [[ ! -d $1 ]]; then
  #statements
  exit 1;
fi


cd $1;
for file in *
do
    b_file=`echo "../$2/${file}"`
    # echo $b_file;
    if  `diff "${file}" "${b_file}"  > /dev/null 2>/dev/null` ;then
        same_files[$index]=`echo "$file" | sed s?^$1/??`
        # echo ${same_files[$index]}
        # echo $index
        ((index ++));
    fi
done
sorted=($(sort <<<"${same_files[*]}"))
if ((index != 0)) ;then
    ((index--))
    for i in `seq 0 $index`; do
        echo "${same_files[$i]}"
    done
fi
