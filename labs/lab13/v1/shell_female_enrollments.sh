#!/bin/bash

cat $1 | cut -d"|" -f5,2 | grep "F" | cut -d"|" -f1  | sort -n

