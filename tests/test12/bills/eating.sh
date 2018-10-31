#!/bin/bash


cat $1 | egrep "name"  | cut -d: -f2 | cut -d\" -f 2 | sort | uniq 
