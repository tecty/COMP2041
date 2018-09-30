./legit.pl init
echo hello >a
./legit.pl add a
./legit.pl commit -m commit-A
./legit.pl branch branchA
echo world >b
./legit.pl add b
./legit.pl commit -m commit-B
./legit.pl checkout branchA
echo new contents >b
./legit.pl checkout master
./legit.pl add b
./legit.pl commit -m commit-C
./legit.pl checkout master
