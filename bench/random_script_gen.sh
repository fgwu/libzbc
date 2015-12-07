#!/bin/bash

if [ $# -ne  4 ]
then
    echo Usage $0 [line_num] [lba_offset] [lba_count] [iosize_in_Bytes]
    echo lba: -1 wp, -2 rand, -3 fixed
    exit -1
fi

for i in `seq 1 $1`
do
    if [ $2 -eq -3 ]
    then
	# we fix the set of zones, and the same offset each run
	echo `shuf -i 64-29809 -n 1` `shuf -i 0-523263 -n 1` $3 $4 1
    else
	# we fix the set of zones, but have rand offset each time.
	echo `shuf -i 64-29809 -n 1` $2 $3 $4 1 
    fi
done
