#!/bin/bash

if [ $# -ne 4 ]
then
    echo Usage: $0 dev start_zdix end_zidx log_prefix
    exit -1
fi

num_log=$4_num.log
bit_log=$4_bit.log

echo "" > $bit_log

i=0

while [ 1 ]
do
#    echo $i `zbc_report_zones /dev/sdb | grep "non_seq 1" | wc -l` | tee -a $num_log

    zbc_report_zones $1 | grep "type 0x" | awk '{print $12}' |  sed 's/,//g' | head -n $(($3 + 1)) | tail -n $(($3 - $2 + 1)) > temp.log

    echo $i `cat temp.log | grep 1 | wc -l` | tee -a $num_log

    paste $bit_log temp.log > temp2.log
    mv temp2.log $bit_log

    i=$(($i+1))
    sleep 1
done


