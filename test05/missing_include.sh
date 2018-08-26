#!/usr/bin/env bash
for file in "$@"; do
  # fetch the file is enclude
  included=`cat $file | egrep "#include \"[a-zA-Z.]*\"" |
    egrep -o "[a-zA-Z.]*" |
    egrep -v "include"`

  for include_file in $included; do
    if ! ls  include_file  >/dev/null 2>/dev/null; then
      # this file is not exist
      echo "$include_file included into $file does not exist"
    fi
  done
done
