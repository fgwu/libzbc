#!/bin/bash

n=$(( 8 ))
for i in `seq 0 8` 
do
	echo `sudo ../reset_write_ptr_all.sh /dev/sdc`
	echo `sudo ../zbc_write_zone2 -p ../log_32GB/32GB_${n}Z_512KB.log -k 1 -s /dev/sdc > ./32GB_${n}Z_512KB.out`
	n=$(( $n * 2 ))
done
