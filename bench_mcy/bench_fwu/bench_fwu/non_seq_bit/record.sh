#!/bin/bash

if [ $# -ne 2 ]
then
    echo Usage: $0 [interval_in_sec] [logfile]
    exit -1
fi

#logfile=nonseq_`date +%m.%d-%H:%M:%S`.log
logfile=$2

#i=0
ts_start=`date +%s`

echo "" > $logfile

while [ 1 ]
do
    ts=`date +%s`
    echo $((ts-ts_start)) `zbc_report_zones /dev/sdb | grep "non_seq 1" | wc -l` | tee -a $logfile
 #   i=$(($i+1))
    sleep $1
done

cp $logfile ~
#mv nonseq_$1_`date +%m.%d-%H:%M:%S`.log ~/
