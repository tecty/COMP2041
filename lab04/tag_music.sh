#!/bin/bash


# change the directory to the directory we need to change id
# cd  "$dirName"

OLDPWD=$PWD

for dir in "$@"; do
  cd - >/dev/null
  cd "$dir"
  # fetch the information from the directory name
  album=`basename "$PWD"`
  year=`basename "$album" | cut -d',' -f2 | cut -d' ' -f2`

  for musicFile in * ; do
    # extract the information from the file name
    track=`echo $musicFile | sed "s/ - /\[/g" | cut -d'[' -f1 `
    title=`echo $musicFile | sed "s/ - /\[/g" | cut -d'[' -f2 `
    artist=`echo $musicFile | sed "s/ - /\[/g" | cut -d'[' -f3 `

    # set the id
    id3 -t "$title" -T "$track" -a "$artist" -A "$album" \
    -y "$year" "$musicFile" > /dev/null

    # echo $musicFile

    # id3 -l "$musicFile"
  done
done
