./legit.pl init
echo line 1 >a
./legit.pl add a
./legit.pl commit -m commit-0
./legit.pl branch b1
echo line 2 >>a
echo hello >b
./legit.pl add a b
./legit.pl commit -m commit-1
./legit.pl checkout b1
echo line 3 >>a
echo world >b
touch c
./legit.pl add a b c
./legit.pl commit -m commit-2
./legit.pl checkout master
./legit.pl checkout b1
./legit.pl checkout master
./legit.pl checkout b1
