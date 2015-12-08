#!/bin/bash

n=$(( 1 ))
for i in `seq 0 6` 
do
	echo `sudo ../reset_write_ptr_all.sh /dev/sdc`
	echo `sudo ../zbc_write_zone2 -p ./${n}MB_8Z_4KB.log -k 1 -s /dev/sdc > ./${n}MB_8Z_4KB.out`
	n=$(( $n * 2 ))
done
