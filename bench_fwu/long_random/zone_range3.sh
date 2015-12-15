#!/bin/bash

bench_bin=~/libzbc/bench_fwu

if [ $# -ne 3 ]
then
    echo Usage: $0 [sample_num] [lba_count] [zone_num]
    echo sample_num: the number of random lbas to run
    exit -1
fi

start_stamp=$(date +%s)

sample_num=$1

#result_file="long_range.csv"
result_file=bw_range_zone${3}_${sample_num}.csv
echo "" > $result_file

echo $bench_bin/zone_range_rand_gen.sh 64 $(($3 + 63)) -2 $2 
$bench_bin/zone_range_rand_gen.sh 64 $(($3 + 63)) -2 $2 > range.job

echo $bench_bin/zbc_write_zone3 -p range.job -k $(($sample_num/$3)) /dev/sdb
$bench_bin/zbc_write_zone3 -p range.job -k $(($sample_num/$3)) /dev/sdb > range_$sample_num.log
#$bench_bin/reset_write_ptr_all.sh /dev/sdb > /dev/null
$bench_bin/extract_bw.sh range_$sample_num.log > $result_file
$bench_bin/extract_timestamp.sh range_$sample_num.log > timestamp.csv

paste $result_file timestamp.csv > temp.csv
mv temp.csv $result_file
rm timestamp.csv


echo cp $result_file ~
cp $result_file ~
#tar cf ~/bw_range_large.tar *.csv
#rm *.csv *.log *.job

end_stamp=$(date +%s)
echo time taken: $(($end_stamp - $start_stamp)) sec.
