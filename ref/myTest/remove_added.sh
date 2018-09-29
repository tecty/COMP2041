./legit init
touch a
./legit add a
./legit commit -m "commit a"
./legit rm --chached a
./legit add a
./legit commit -m "I should not be here"
