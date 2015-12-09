#!/bin/bash

if  [ $# -ne 2 ]
then
    echo Usage: $0 start_zidx end_zidx
    exit -1
fi

bench_bin=~/libzbc/bench_fwu

$bench_bin/zone_range_rand_gen.sh $1 $2 -2 1024 > rand$1-$2.job
$bench_bin/zbc_write_zone2 -p rand$1-$2.job /dev/sdb


