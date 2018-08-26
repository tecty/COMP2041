#!/usr/bin/env bash

for htm in *.htm ; do
  if  echo $htm | egrep "\*.htm" >/dev/null ; then
    # no htm in this directory break
    exit 0
  fi

  if echo  "$htm" | egrep ".html$"; then
    # pass those file already change to html
    continue;
  fi
  html=`echo  "$htm" |sed "s/.htm$/.html/g"`
  if  ls $html 2>/dev/null >/dev/null ; then
    # break the loop if the file is exist
    echo  "$html" "exists" 1>&2
    exit 1
  fi
  mv -- "$htm" "$html"
done
