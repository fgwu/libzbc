#!/bin/bash

if [ $# -ne  3 ]
then
    echo Usage $0 [line_num] [lba_count]
    exit -1
fi

start_zidx=$(((29809 - $1)/2))
end_zidx=$(($start_zidx + $1 - 1))

echo $start_zidx $end_zidx

for i in `seq $start_zidx $end_zidx`
do
    # set lba_offset to -1, indicating wp
    echo $i -1 $2 1 
done
