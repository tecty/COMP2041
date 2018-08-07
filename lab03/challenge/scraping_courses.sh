#!/bin/bash

function fetch_info() {
  # script fetch all the use ful information, still in html
  cat $1 | \
  # grep all the course detail
  egrep \
  "<TD class=\".*\" align=\".*\">|<TD class=\".*\"><A href=\".*\">.*</A></TD>"|
  #  remove the indent
  cut -f9 |
  # remove the html tags
  sed "s/<TD class=\".*\" align=\".*\">//g" |
  sed "s/<TD class=\".*\">//g" |
  sed "s/<\/.*>//g" |
  # remove UOC info
  egrep -v "^[0-9]{1,2}$|^[0-9]{1,2}\.[0-9]$"

}

function generate_db() {
  if ! test -r course.db ; then
    # try to create a db file contain all those course
    fetch_info "UG_all.html"  > UG.tmp
    fetch_info "PG_all.html"  > PG.tmp

    # # fetch the  info in the undergraduate
    egrep "^[A-Z]{4}[0-9]{4}$"    UG.tmp > course_name.tmp
    egrep -v "^[A-Z]{4}[0-9]{4}$" UG.tmp > course_detail.tmp
    # create a file of course db, or remove the old one
    paste course_name.tmp course_detail.tmp -d" " > course.db.tmp

    # fetch the info in postgraduate
    egrep "^[A-Z]{4}[0-9]{4}$"    PG.tmp > course_name.tmp
    egrep -v "^[A-Z]{4}[0-9]{4}$" PG.tmp > course_detail.tmp
    # append the PG course after the UG course
    paste course_name.tmp course_detail.tmp -d" " >> course.db.tmp

    # remove the duplicate course
    sort course.db.tmp | uniq > course.db
    # delete the tempory file
    rm *.tmp
  fi
}

if [[ $# != 1 ]]; then
  # print the usage to stderr
  echo "Usage: $0 <Course Name>" 1>&2
  exit 1
fi

# try to generate a db that contain the couses' info
generate_db

# grep the name given
grep $1 course.db
