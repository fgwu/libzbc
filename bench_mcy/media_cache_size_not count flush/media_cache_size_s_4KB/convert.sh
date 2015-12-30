#!/bin/bash

n=$(( 1 ))
for i in `seq 0 6` 
do
	echo `touch ${n}MB_8Z_4KB.bw`
	echo `cat ${n}MB_8Z_4KB.out | grep BW > ${n}MB_8Z_4KB.bw`
	echo `cat ${n}MB_8Z_4KB.bw | tr ' ' ',' > ${n}MB_8Z_4KB.csv`
	n=$(( $n * 2 ))
done
