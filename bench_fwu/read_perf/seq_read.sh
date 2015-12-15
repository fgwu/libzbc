#!/bin/bash

bench_bin=~/libzbc/bench_fwu

result_file_prefix=read_seq

echo 64 -1 1024 512 > 512K.job
echo 70 -1 8 65536 > 4K.job

echo $bench_bin/zbc_write_zone2 -p 512K.job /dev/sdb
$bench_bin/zbc_write_zone2 -p 512K.job /dev/sdb > w_512K.log

echo $bench_bin/zbc_read_zone2 -p 512K.job /dev/sdb
$bench_bin/zbc_read_zone2 -p 512K.job /dev/sdb > r_512K.log

echo $bench_bin/zbc_write_zone2 -p 4K.job /dev/sdb
$bench_bin/zbc_write_zone2 -p 4K.job /dev/sdb > w_4K.log

echo $bench_bin/zbc_read_zone2 -p 4K.job /dev/sdb
$bench_bin/zbc_read_zone2 -p 4K.job /dev/sdb > r_4K.log

echo $bench_bin/extract_bw.sh w_512K.log 
$bench_bin/extract_bw.sh w_512K.log > w_512K.csv

echo $bench_bin/extract_bw.sh r_512K.log 
$bench_bin/extract_bw.sh r_512K.log > r_512K.csv

echo $bench_bin/extract_bw.sh w_4K.log 
$bench_bin/extract_bw.sh w_4K.log > w_4K.csv

echo $bench_bin/extract_bw.sh r_4K.log 
$bench_bin/extract_bw.sh r_4K.log > r_4K.csv

paste w_512K.csv r_512K.csv > ${result_file_prefix}_512K.csv
paste  w_4K.csv r_4K.csv > ${result_file_prefix}_4K.csv

cp ${result_file_prefix}_512K.csv  ${result_file_prefix}_4K.csv ~
echo cp ${result_file_prefix}_512K.csv  ${result_file_prefix}_4K.csv ~

echo $bench_bin/reset_write_ptr_all.sh /dev/sdb 
$bench_bin/reset_write_ptr_all.sh /dev/sdb  > /dev/null

