./legit.pl init
echo hello >a
./legit.pl add a
./legit.pl commit -m commit-A
./legit.pl branch branch1
./legit.pl checkout branch1
echo world >b
./legit.pl add b
./legit.pl commit -a -m commit-B
./legit.pl checkout master
./legit.pl branch -d branch1
./legit.pl merge -m merge-message branch1
./legit.pl branch -d branch1
./legit.pl branch
