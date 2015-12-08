#!/bin/bash

if [ $# -ne  3 ]
then
    echo Usage $0 [num_io] [lba_count] [iosize_in_Bytes]
    exit -1
fi

for i in `seq 1 $1`
do
    # we fix the set of zones, and the same offset each run
#    echo    `shuf -i 64-29809 -n 1` `shuf -i 0-523263 -n 1` $2 $3 1
    
    # we fix the set of zones, but have rand offset each time.
    echo `shuf -i 64-29809 -n 1` -2 $2 $3 1 
done
