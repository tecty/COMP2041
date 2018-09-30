./legit.pl init
touch a
./legit.pl add a
./legit.pl commit -m "commit a"
./legit.pl rm --cached a
./legit.pl add a
./legit.pl commit -m "I should not be here"
