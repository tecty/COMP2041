# merge br and master, they contain exactly the same files but different to the ancestor
# merge cr and master, their file a are different
./legit.pl init
echo "h" > a
echo "f" >> a
echo "b will be removed" > b
./legit.pl add a
./legit.pl add b
./legit.pl commit -m "first - 0"
# 0 contains a:hf and b
./legit.pl branch br
./legit.pl branch cr
./legit.pl rm b
./legit.pl commit -a -m "hf - 1"
# 1 contains a:hf
./legit.pl checkout br
./legit.pl rm b
./legit.pl commit -a -m "hf - 2"
# 2 contains a:hf
./legit.pl checkout cr
./legit.pl rm b
echo "g" >> a
./legit.pl commit -a -m "hfg - 3"
# 3 contains a:hfg
./legit.pl show :a
./legit.pl merge master -m "4=3+1 merge => hfg"
# after merge, a contains hfg
./legit.pl show :a
./legit.pl checkout br
./legit.pl show :a
./legit.pl merge master -m "5=2+1 merge => hf"
./legit.pl status
./legit.pl log