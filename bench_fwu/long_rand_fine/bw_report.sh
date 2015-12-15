#!/bin/bash


bench_bin=~/libzbc/bench_fwu
$bench_bin/extract_bw.sh $1 > temp_bw.csv
$bench_bin/extract_timestamp.sh $1 > temp_ts.csv

paste temp_bw.csv temp_ts.csv > $2
#rm temp_bw.csv temp_ts.csv
