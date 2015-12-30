#!/bin/bash

if [ $# -ne 1 ]
then
    echo Usage: $0 [logfile]
    exit -1
fi

#logfile=nonseq_`date +%m.%d-%H:%M:%S`.log
logfile=$1

#i=0
ts_start=`date +%s.%N`

rm -f  $logfile

while [ 1 ]
do
    ts_stop=`date +%s.%N`
    ts=$(awk "BEGIN {printf \"%.3f\",${ts_stop} - ${ts_start}}")

    echo $ts `zbc_report_zones /dev/sdb | grep "non_seq 1" | wc -l` | tee -a $logfile
 #   i=$(($i+1))
    sleep 1
done

cp $logfile ~
#mv nonseq_$1_`date +%m.%d-%H:%M:%S`.log ~/
