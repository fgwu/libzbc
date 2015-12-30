#!/bin/bash

n=$(( 1 ))
for i in `seq 1 17` 
do
	echo `cat ${n}MB_32Z_512KB.out | grep BW > ${n}MB_32Z_512KB.bw`
	echo `cat ${n}MB_32Z_512KB.bw | tr ' ' ',' > ${n}MB_32Z_512KB.csv`
	n=$(( $n * 2 ))
done
