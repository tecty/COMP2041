./legit.pl init
./legit.pl branch
touch a
./legit.pl add a
./legit.pl commit -m commit-0
./legit.pl branch branch1
./legit.pl branch branch2
./legit.pl branch master
./legit.pl branch
./legit.pl branch -d branch2
./legit.pl branch -d master
./legit.pl branch -d b1
./legit.pl branch
