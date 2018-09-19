#!/bin/bash
for fileName in * ; do
  if  echo $fileName | egrep "*.jpg"  2>&1 >/dev/null; then
    #statements
    fileNamePng=`echo $fileName |sed "s/.jpg/.png/g"`
    if ls -- "$fileNamePng" >/dev/null 2>&1 
    then
      echo $fileNamePng "already exists" >&2
    else 
      convert "$fileName" "$fileNamePng"
      rm -- "$fileName" 
    fi
  fi
done
