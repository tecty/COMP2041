#!/bin/bash
date
month=`date "+%m"`
while [[ $month == `date "+%m"` ]]; do
    sleep 360 
    date
done 
