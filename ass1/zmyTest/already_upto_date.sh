./legit.pl init
echo "h" > a
echo "f" >> a
echo "b will be removed" > b
./legit.pl add a
./legit.pl add b
./legit.pl commit -m "first - 0"
./legit.pl branch br
echo "h" > a
echo "f" >> a
./legit.pl rm b
./legit.pl commit -a -m "hf - 1"
./legit.pl checkout br
echo "g" >> a
./legit.pl rm b
./legit.pl commit -a -m "hfg - 2"
./legit.pl show :a
./legit.pl merge 1 -m "3=2+1 merge => hfg"
./legit.pl show :a
./legit.pl checkout master
./legit.pl show :a
./legit.pl status
