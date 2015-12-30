#!/bin/bash

n=$(( 8 ))
for i in `seq 0 8` 
do
	z=$(( 64+$n-1))
	echo `./random_script_gen.sh 65536 ${z} 1024 > log_32MB/32MB_${n}Z_512KB.log`
	n=$(( $n * 2 ))
done
