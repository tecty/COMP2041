rm -rf .legit
./legit.pl init
echo "f" > a
./legit.pl add a
./legit.pl commit -m "first - 0"
./legit.pl branch br
echo "h" > a
echo "f" >> a
./legit.pl commit -a -m "hf - 1"
./legit.pl checkout br
echo "g" >> a
./legit.pl commit -a -m "fg - 2"
./legit.pl merge master -m "3 = 1+2 merge => hfg"
./legit.pl show :a
echo "x" > a
./legit.pl commit -a -m "x - 4"
./legit.pl show :a
./legit.pl merge 1 -m " =4+1 merge => x, Already up to date"
./legit.pl show :a
./legit.pl checkout master
./legit.pl show :a
./legit.pl merge br -m " =4+1 merge => x, Fast-forward merge"
./legit.pl show :a
./legit.pl status
./legit.pl merge 3 -m " =4+3 merge => x, Already up to date"
./legit.pl show :a
./legit.pl checkout br
./legit.pl show :a
./legit.pl merge master -m "merge the commit with itself"
./legit.pl show :a
./legit.pl log
