#!/bin/bash

if [ $# -ne 4 ]
then
    echo Usage: $0 [logfile] [interval] [device] [zone_num]
    echo "      [64, 64+zone_num) is the range we record bit map"
    exit -1
fi

#logfile=nonseq_`date +%m.%d-%H:%M:%S`.log
logfile=$1
echo "">cnt_${logfile}
echo "">bit_${logfile}
#i=0
ts_start=`date +%s.%N`

nonseq=1
flag=1

ttl=3

while [ $nonseq -ne 0 -o $flag -eq 1 ]
#while [ 1 ]
do
    ts_stop=`date +%s.%N`
    ts=$(awk "BEGIN {printf \"%.3f\",${ts_stop} - ${ts_start}}")
    nonseq=`zbc_report_zones $3 | grep "non_seq 1" | wc -l`
    echo $ts $nonseq | tee -a cnt_${logfile}
 #   echo $ts $nonseq >> cnt_${logfile}
 #   i=$(($i+1))
    zbc_report_zones -nz $(($4 + 64)) /dev/sdb | tail  -n $4 | awk -F',' '{print $4}' | awk  '{print $2}' > bit_tmp
    paste -d' ' bit_${logfile} bit_tmp > bit_tmp2
    mv bit_tmp2 bit_${logfile}
    rm -rf bit_tmp


    if [ $nonseq -ne 0  ]; then
	flag=0
	ttl=3
    fi

    if [ $flag -eq 0 -a $nonseq -eq 0  ]; then
	break
    fi

    if [ $nonseq -eq 0  ]; then
	ttl=$(($ttl - 1))
    fi

    if [ $ttl -eq 0 ]; then
	break
    fi


    sleep $2
done

cp cnt_${logfile} ~
#mv nonseq_$1_`date +%m.%d-%H:%M:%S`.log ~/
