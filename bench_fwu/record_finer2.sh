#!/bin/bash

if [ $# -ne 3 ]
then
    echo Usage: $0 [logfile] [interval] [device]
    exit -1
fi

#logfile=nonseq_`date +%m.%d-%H:%M:%S`.log
logfile=$1
echo "">$logfile
#i=0
ts_start=`date +%s.%N`

rm -f  $logfile

nonseq=1
flag=1

#while [ $nonseq -ne 0 -o $flag -eq 1 ]
while [ 1 ]
do
    ts_stop=`date +%s.%N`
    ts=$(awk "BEGIN {printf \"%.3f\",${ts_stop} - ${ts_start}}")
    nonseq=`zbc_report_zones $3 | grep "non_seq 1" | wc -l`
 #   echo $ts $nonseq | tee -a $logfile
    echo $ts $nonseq >> $logfile
 #   i=$(($i+1))
    if [ $nonseq -ne 0  ]; then
	flag=0
    fi
    sleep $2
done

cp $logfile ~
#mv nonseq_$1_`date +%m.%d-%H:%M:%S`.log ~/
