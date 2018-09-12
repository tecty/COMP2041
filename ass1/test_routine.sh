while [[ 1 ]]; do
  echo -n "@ "
  date +%H:%M;
  # call the auto test
  ./autoTest.sh;

  sleep 60;
done
