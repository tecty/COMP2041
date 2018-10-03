# this test will test several situations of rm 
./legit.pl init
echo "1" > a
echo "1" > b
echo "1" > c
echo "1" > d
echo "1" > e
echo "1" > f
echo "1" > g
echo "1" > h
./legit.pl add a b c d e f
./legit.pl commit -m "first commit"
./legit.pl branch br
echo hello >>a
echo hello >>b
echo hello >>c
./legit.pl checkout br

./legit.pl add a b
echo world >a
./legit.pl commit -m "second commit"
rm d
./legit.pl rm a
./legit.pl rm b
./legit.pl rm --cached b --force
./legit.pl rm --force --force d
./legit.pl rm --force --cached --force --force --cached c --cached
./legit.pl rm --cached g
./legit.pl rm --force a
./legit.pl commit -m "second commit"
./legit.pl rm another
./legit.pl add --force -file
./legit.pl rm --force -file
touch "a long long long things with invalid name"
./legit.pl rm "a long long long things with invalid name"
echo "this is a line in br branch" > fileinBrBranch
./legit.pl add fileinBrBranch
./legit.pl add g
./legit.pl rm g
./legit.pl commit -m "add file"
./legit.pl status
./legit.pl checkout master
./legit.pl rm --force fileinBrBranch
./legit.pl rm --cached g
./legit.pl rm a # remove file that has been removed in another branch
./legit.pl status