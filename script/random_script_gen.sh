#!/bin/bash

for i in `seq 1 $1`
do
#    echo $RANDOM
	if [ $2 -ge 64 ] && [ $2 -le 29809 ]; then
		echo    `shuf -i 64-$2 -n 1` `shuf -i 0-524288 -n 1` 8 4096 1
	else
		echo    `shuf -i 64-29809 -n 1` `shuf -i 0-524288 -n 1` 8 4096 1
	fi
done