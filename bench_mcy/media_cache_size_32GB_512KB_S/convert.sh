#!/bin/bash

n=$(( 8 ))
for i in `seq 0 8` 
do
	echo `cat 32GB_${n}Z_512KB.out | grep BW > 32GB_${n}Z_512KB.bw`
	echo `cat 32GB_${n}Z_512KB.bw | tr ' ' ',' > 32GB_${n}Z_512KB.csv`
	n=$(( $n * 2 ))
done
