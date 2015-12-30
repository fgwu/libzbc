#!/bin/bash

n=$(( 1 ))
n2=$(( n*2 ))
for i in `seq 1 17` 
do
	echo `./random_script_gen.sh ${n2} 95 1024 > log/${n}MB_32Z_512KB.log`
	n=$(( $n * 2 ))
	n2=$(( n*2 ))
done