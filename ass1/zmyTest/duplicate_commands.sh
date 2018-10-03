./legit.pl init
# this test will test duplicate commands 
./legit.pl init
echo f > a
./legit.pl add a
./legit.pl add a
./legit.pl add a
./legit.pl commit -m "first"
./legit.pl commit -m "first"
./legit.pl branch br
./legit.pl branch br
./legit.pl rm .legit
./legit.pl rm .legit
./legit.pl init
./legit.pl rm a
./legit.pl rm a
./legit.pl commit -m "removed"
./legit.pl checkout br
./legit.pl checkout br
echo "t" >> a
./legit.pl commit -a -m "second"
./legit.pl commit -a -m "second"

./legit.pl merge master -m "merge"
./legit.pl merge master -m "merge"
./legit.pl log
./legit.pl status