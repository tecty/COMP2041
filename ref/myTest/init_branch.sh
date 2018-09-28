#!/bin/sh
legit init
legit branch master
touch a
legit add a
legit commit -m "nothing"
legit branch master
