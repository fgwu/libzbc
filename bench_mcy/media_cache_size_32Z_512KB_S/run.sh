#!/bin/bash

n=$(( 1 ))
for i in `seq 1 17` 
do
	echo `sudo ../reset_write_ptr_all.sh /dev/sdc`
	echo `sudo ../zbc_write_zone2 -p ../log/${n}MB_32Z_512KB.log -k 1 -s /dev/sdc > ./${n}MB_32Z_512KB.out`
	n=$(( $n * 2 ))
done
