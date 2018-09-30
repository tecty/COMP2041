./legit.pl init
echo hello >a
./legit.pl add a
./legit.pl commit -m commit-A
./legit.pl branch b1
echo world >>a
./legit.pl checkout b1
./legit.pl status
./legit.pl checkout master
./legit.pl add a
./legit.pl status
./legit.pl checkout b1
./legit.pl status
./legit.pl checkout master
./legit.pl commit -a -m commit-B
./legit.pl checkout b1
./legit.pl status
./legit.pl checkout master
./legit.pl status
