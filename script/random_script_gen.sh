#!/bin/bash

for i in {1..100}
do
#    echo $RANDOM
    echo    `shuf -i 64-29809 -n 1` `shuf -i 0-524288 -n 1` 8 4096 1
done
