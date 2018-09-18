#!/usr/bin/env bash
i=0;

back=".$1.$i";

while [[ -f $back ]]; do
  #statements
  ((i++));
  # reconstrcut the backup file name 
  back=".$1.$i";
done
cp "$1" "$back"
echo "Backup of '$1' saved as '$back'"
