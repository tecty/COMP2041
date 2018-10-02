./legit.pl init
touch a
./legit.pl add a
./legit.pl commit -m "commit a"
./legit.pl rm --cached a
./legit.pl add a
./legit.pl rm --cached b
./legit.pl rm --force --cached b
./legit.pl rm b
./legit.pl rm --force b
./legit.pl rm --fo b
./legit.pl rm -c b
