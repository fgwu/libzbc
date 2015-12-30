#!/bin/bash

bench_bin=~/libzbc/bench_fwu

result_file=read_perf_large.csv

echo $bench_bin/random_script_gen.sh 1024 -3 1024
$bench_bin/random_script_gen.sh 1024 -3 1024 > rand.job

echo cat rand.job | shuf > rand_shuf.job
cat rand.job | shuf > rand_shuf.job

echo $bench_bin/zbc_write_zone2 -p rand.job /dev/sdb
$bench_bin/zbc_write_zone2 -p rand.job /dev/sdb > write.log

echo $bench_bin/zbc_read_zone2 -p rand.job /dev/sdb 
$bench_bin/zbc_read_zone2 -p rand.job /dev/sdb > read.log
echo $bench_bin/zbc_read_zone2 -p rand_shuf.job /dev/sdb
$bench_bin/zbc_read_zone2 -p rand_shuf.job /dev/sdb > read_shuf.log

echo $bench_bin/zbc_write_zone2 -p rand_shuf.job /dev/sdb
$bench_bin/zbc_write_zone2 -p rand_shuf.job /dev/sdb > write_shuf.log

echo $bench_bin/zbc_read_zone2 -p rand.job /dev/sdb
$bench_bin/zbc_read_zone2 -p rand.job /dev/sdb > read2.log
echo $bench_bin/zbc_read_zone2 -p rand_shuf.job /dev/sdb
$bench_bin/zbc_read_zone2 -p rand_shuf.job /dev/sdb > read_shuf2.log

echo $bench_bin/extract_bw.sh write.log 
$bench_bin/extract_bw.sh write.log > write.csv

echo $bench_bin/extract_bw.sh write_shuf.log 
$bench_bin/extract_bw.sh write_shuf.log > write_shuf.csv

echo $bench_bin/extract_bw.sh read.log 
$bench_bin/extract_bw.sh read.log > read.csv

echo $bench_bin/extract_bw.sh read_shuf.log 
$bench_bin/extract_bw.sh read_shuf.log > read_shuf.csv

echo $bench_bin/extract_bw.sh read_2.log 
$bench_bin/extract_bw.sh read2.log > read_2.csv

echo $bench_bin/extract_bw.sh read_shuf_2.log 
$bench_bin/extract_bw.sh read_shuf2.log > read_shuf_2.csv

paste write.csv read.csv read_shuf.csv write_shuf.csv read_2.csv read_shuf_2.csv > $result_file

cp $result_file ~
echo cp $result_file ~

echo $bench_bin/reset_write_ptr_all.sh /dev/sdb 
$bench_bin/reset_write_ptr_all.sh /dev/sdb  > /dev/null

