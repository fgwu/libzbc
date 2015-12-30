#!/bin/bash

bench_bin=~/libzbc/bench_fwu

if [ $# -ne 5 ]
then
    echo Usage: $0 [sample_num] [lba_count] [zone_num] [device] [log-prefix]
    echo sample_num: the number of random lbas to run
    exit -1
fi

start_stamp=$(date +%s)

sample_num=$1

#result_file="long_range.csv"
run_log=run_${5}.log
bw_log=bw_${5}.csv
nonseq_log=nonseq_${5}.csv
job_file=job_${5}.job

echo "" > $bw_log

echo $bench_bin/zone_range_rand_gen.sh 64 $(($3 + 63)) -2 $2 
$bench_bin/zone_range_rand_gen.sh 64 $(($3 + 63)) -2 $2 > ${job_file}

echo $bench_bin/zbc_write_zone3 -p ${job_file} -k $(($sample_num/$3)) $4
$bench_bin/record_finer2.sh ${nonseq_log} 1 $4 &
$bench_bin/zbc_write_zone3 -p ${job_file} -k $(($sample_num/$3)) $4 > ${run_log}


$bench_bin/extract_bw.sh ${run_log} > tmp_${5}_bw.csv
$bench_bin/extract_timestamp.sh ${run_log} > tmp_${5}_ts.csv

paste tmp_${5}_bw.csv tmp_${5}_ts.csv > $bw_log

echo cp $bw_log ~
cp $bw_log ~
#tar cf ~/bw_range_large.tar *.csv
#rm *.csv *.log *.job

end_stamp=$(date +%s)
echo time taken: $(($end_stamp - $start_stamp)) sec.
hdparm -W0 $4
