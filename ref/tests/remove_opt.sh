./legit.pl init
echo 1 >a
echo 2 >b
echo 3 >c
./legit.pl add a b c
./legit.pl commit -m "first commit"
echo 4 >>a
echo 5 >>b
echo 6 >>c
echo 7 >d
echo 8 >e
./legit.pl add b c d e
echo 9 >b
echo 0 >d
./legit.pl rm --cached a c
./legit.pl rm --force --cached b
./legit.pl rm --cached --force e
./legit.pl rm --force d
./legit.pl status
