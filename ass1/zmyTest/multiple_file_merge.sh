# test several merging situation of multiple files
./legit.pl init
echo "1" > a
echo "1" > b
echo "1" > c
echo "1" > d
./legit.pl add a b c d
./legit.pl commit -a -m "first - 0"
# 0 contains a:hf and b
./legit.pl branch br
./legit.pl branch cr
./legit.pl branch dr
./legit.pl merge 1 -m "merge unexisted commit"
./legit.pl checkout br
echo "2" >> a
echo "2" >> c
echo "2" >> d
./legit.pl commit -a -m "1 in br"
./legit.pl checkout cr
echo "0" > a
echo "0" > b
echo "0" > c
echo "2" >> a
echo "2" >> b
echo "2" >> c
echo "2" >> d
./legit.pl commit -a -m "2 in cr"
./legit.pl checkout dr
echo "0" > a
echo "0" > b
echo "0" > c
echo "0" > d
echo "1" >> a
echo "1" >> b
echo "1" >> c
echo "1" >> d
./legit.pl commit -a -m "3 in dr"
./legit.pl merge 1 -m "merge 1 and 3"
# auto merging
./legit.pl checkout cr
./legit.pl merge 1 -m "merge 1 and 2"
# unable to merge
./legit.pl checkout master
./legit.pl merge cr -m "fast forward merge"
./legit.pl status
./legit.pl log