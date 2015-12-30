#!/bin/bash

bench_bin=~/libzbc/bench_fwu

if [ $# -ne 4 ]
then
    echo Usage: $0 [sample_num] [lba_count] [zone_num] [device]
    echo sample_num: the number of random lbas to run
    exit -1
fi

start_stamp=$(date +%s)

sample_num=$1

#result_file="long_range.csv"
result_file=bw_range_zone${3}_${sample_num}.csv
echo "" > $result_file

echo $bench_bin/zone_range_rand_gen.sh 64 $(($3 + 63)) -2 $2 
$bench_bin/zone_range_rand_gen.sh 64 $(($3 + 63)) -2 $2 > range2.job

echo $bench_bin/zbc_write_zone3 -p range2.job -k $(($sample_num/$3)) $4
$bench_bin/record_finer2.sh nonseq_range${3}_${sample_num}.csv 60 $4 &
$bench_bin/zbc_write_zone3 -p range2.job -k $(($sample_num/$3)) $4 > range${3}_$sample_num.log


$bench_bin/extract_bw.sh range${3}_$sample_num.log > temp_bw.csv
$bench_bin/extract_timestamp.sh range${3}_$sample_num.log > temp_ts.csv

paste temp_bw.csv temp_ts.csv > $result_file

echo cp $result_file ~
cp $result_file ~
#tar cf ~/bw_range_large.tar *.csv
#rm *.csv *.log *.job

end_stamp=$(date +%s)
echo time taken: $(($end_stamp - $start_stamp)) sec.
