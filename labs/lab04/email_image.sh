#/bin/bash


for arg in $@ ; do
  echo -n "Address to e-mail this image to? "
  read email
  echo -n "Message to accompany image? "
  read msg
  echo $arg "sent to" $email
  echo "$msg"|mutt -s 'penguins!' -e 'set copy=no' -a $arg -- $email
  # echo $arg
done
