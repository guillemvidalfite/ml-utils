IFS=$'\n'       # make newlines the only separator
for i in $(cat < "extensionids.txt"); do
  filename=$i"_all.csv"
  echo "NEW FILE" $filename
  count=0
  for j in $(find /home/bigml/alvaro/anomaly-evaluator/outputs -depth -name "*$i*"  | grep -E 'train|test|val.csv'); do
     # check count to add header only once
     if [ $count -eq 0 ]
     then
        cat $j >> $filename
        count=`expr $count + 1`
     else
        tail -n +2 -q $j >> $filename
     fi
  done
done