./legit.pl init
echo "1" > a
echo "1" > b
echo "1" > c
echo "1" > d
echo "1" > e
echo "1" > f
echo "1" > g
echo "1" > h
./legit.pl add a b c d e f
./legit.pl commit -m "first commit"
./legit.pl branch br
echo hello >>a
echo hello >>b
echo hello >>c
./legit.pl checkout br
./legit.pl checkout master
./legit.pl add a b
echo world >a
rm d
./legit.pl checkout br
./legit.pl checkout master
./legit.pl rm e
./legit.pl add g
./legit.pl checkout br
./legit.pl status