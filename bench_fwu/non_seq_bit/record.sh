#!/bin/bash

if [ $# -ne 1 ]
then
    echo Usage: $0 [interval_in_sec]
    exit -1
fi

logfile=nonseq_`date +%m.%d-%H:%M:%S`.log

i=0

while [ 1 ]
do
    echo $i `zbc_report_zones /dev/sdb | grep "non_seq 1" | wc -l` | tee -a $logfile
    i=$(($i+1))
    sleep $1
done


#mv nonseq_$1_`date +%m.%d-%H:%M:%S`.log ~/
