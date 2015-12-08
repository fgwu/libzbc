#!/bin/bash

bench_bin=~/libzbc/bench

if [ $# -ne 1 ]
then
    echo Usage: $0 [sample_num]
    echo sample_num: the number of random lbas to run
    exit -1
fi

start_stamp=$(date +%s)

sample_num=$1

#result_file="long_rand.csv"
result_file=bw_long_rand_$sample_num.csv
echo "" > $result_file
echo -2 -2 1024 1
echo -2 -2 1024 1 > rand.job
echo $bench_bin/zbc_write_zone2 -p rand.job -k $sample_num /dev/sdb
$bench_bin/zbc_write_zone2 -p rand.job -k $sample_num /dev/sdb > rand_$sample_num.log
#$bench_bin/reset_write_ptr_all.sh /dev/sdb > /dev/null
$bench_bin/extract_bw.sh rand_$sample_num.log > $result_file

echo cp $result_file ~
cp $result_file ~
#tar cf ~/bw_rand_large.tar *.csv
#rm *.csv *.log *.job

end_stamp=$(date +%s)
echo time taken: $(($end_stamp - $start_stamp)) sec.
