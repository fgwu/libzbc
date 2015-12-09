#!/bin/bash

if [ $# -ne  4 ]
then
    echo Usage $0 [start_zidx] [end_zidx] [lba_offset] [lba_count]
    echo lba: -1 wp, -2 rand, -3 fixed
    exit -1
fi

shuf -i $1-$2 > temp1

for i in `seq $1 $2`
do
    if [ $3 -eq -3 ]
    then
	# we fix the set of zones, and the same offset each run
	echo `shuf -i 0-523263 -n 1` $4  1 >> temp2
    else
	# we fix the set of zones, but have rand offset each time.
	echo $3 $4  1  >> temp2
    fi
done

paste temp1 temp2

rm temp1 temp2
