# this test is for testing merging recursively
./legit.pl init
echo "f" > a
./legit.pl add a
./legit.pl commit -m "first - 0"
./legit.pl branch br
echo "h" > a
echo "f" >> a
./legit.pl commit -a -m "hf - 1"
echo "g" >> a
./legit.pl commit -a -m "hfg - 2"
./legit.pl checkout br
echo "g" >> a
./legit.pl commit -a -m "fg - 3"
echo "x" >> a
./legit.pl commit -a -m "fgx - 4"
./legit.pl show 1:a
./legit.pl show :a
./legit.pl merge 1 -m "5=4+1 merge => hfgx"
./legit.pl show :a
./legit.pl checkout master
./legit.pl show 3:a
./legit.pl show :a
./legit.pl merge 3 -m "6=3+2 merge => hfg"
./legit.pl show :a
./legit.pl checkout br
### issue: the reference implementation will report "Already up to date" while still making a new commit
./legit.pl merge master -m "7 = 6+5 merge => hfgx"
./legit.pl show :a

