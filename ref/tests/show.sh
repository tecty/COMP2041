./legit.pl init
echo line 1 >a
echo hello world >b
./legit.pl add a b
./legit.pl commit -m "first commit"
echo line 2 >>a
./legit.pl add a
./legit.pl commit -m "second commit"
./legit.pl log
echo line 3 >>a
./legit.pl add a
echo line 4 >>a
./legit.pl show 0:a
./legit.pl show 1:a
./legit.pl show :a
./legit.pl show 0:b
./legit.pl show 1:b

# cleanning code
rm a b -rf
