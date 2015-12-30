#!/bin/bash

bench_bin=~/libzbc/bench_fwu

if [ $# -ne 2 ]
then
    echo Usage: $0 [sample_num] [lba_count]
    echo sample_num: the number of random lbas to run
    exit -1
fi

start_stamp=$(date +%s)

sample_num=$1

#result_file="long_rand.csv"
result_file=bw_zone_all_$sample_num.csv
echo "" > $result_file
echo -2 -2 $2 1
echo -2 -2 $2 1 > rand.job
echo $bench_bin/zbc_write_zone3 -p rand.job -k $sample_num /dev/sdb
$bench_bin/zbc_write_zone3 -p rand.job -k $sample_num /dev/sdb > rand_$sample_num.log

$bench_bin/extract_bw.sh rand_$sample_num.log > temp_bw.csv
$bench_bin/extract_timestamp.sh rand_$sample_num.log > temp_ts.csv

paste temp_bw.csv temp_ts.csv > $result_file

echo cp $result_file ~
cp $result_file ~

end_stamp=$(date +%s)
echo time taken: $(($end_stamp - $start_stamp)) sec.
