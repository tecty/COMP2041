#/bin/bash

# echo with correct date formate
the_date=`date +"'%b %d %H:%M'"`

# put the date into the file
convert -gravity south -pointsize 36 -draw "text 0,10 $the_date" $1 $1
