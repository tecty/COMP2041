./legit.pl init
seq 1 7 >7.txt
./legit.pl add 7.txt
./legit.pl commit -m commit-0
./legit.pl branch b1
./legit.pl checkout b1
perl -pi -e s/2/42/ 7.txt
./legit.pl commit -a -m commit-1
./legit.pl checkout master
perl -pi -e s/5/24/ 7.txt
./legit.pl commit -a -m commit-2
./legit.pl merge -m merge-message b1
./legit.pl log
./legit.pl status
