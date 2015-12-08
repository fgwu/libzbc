#!/bin/bash

bench_bin=~/bench

result_file="bw_seq_20_20_200.csv"
echo "" > $result_file
for i in 20 40 60 80 100 120 140 160 180 200
do
    echo  $bench_bin/seq_script_gen.sh $i 1024 
    $bench_bin/seq_script_gen.sh $i  1024  > $i.job
    echo $bench_bin/zbc_write_zone2 -p $i.job -k $((1000/$i)) /dev/sdb
    $bench_bin/zbc_write_zone2 -p $i.job -k $((1000/$i)) /dev/sdb > $i.log
    $bench_bin/reset_write_ptr_all.sh /dev/sdb > /dev/null
    $bench_bin/extract_bw.sh $i.log > bw_$i.csv
    paste $result_file bw_$i.csv > temp.csv
    mv temp.csv $result_file
done

head -n 900 $result_file > temp.csv
mv temp.csv $result_file
echo cp $result_file ~
cp $result_file ~
#tar cf ~/bw_large.tar *.csv
#rm *.csv *.log *.job
