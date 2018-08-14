#!/bin/bash
for fileName in * ; do
  if  echo $fileName | egrep "*.jpg"  2>&1 >/dev/null; then
    #statements
    fileNamePng=`echo $fileName |sed "s/.jpg/.png/g"`
    convert -- "$fileName" "$fileNamePng"
  fi
done
