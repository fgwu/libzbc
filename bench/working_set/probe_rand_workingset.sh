#!/bin/bash

result_file="bw_rand_large_20_20_200.csv"
#result_file="bw_rand_large_60_2_80.csv"
#result_file="bw_rand_large_70_1_80.csv"
result_file="bw_rand_large_1_1_20.csv"
echo "" > $result_file
#for i in 20 40 60 80 100 120 140 160 180 200
#for i in 60 62 64 66 68 70 72 74 76 78 80
#for i in 70 71 72 73 74 75 76 77 78 79 80
for i in `seq 1 20`
do
    echo  ./random_script_gen.sh $i 1024 524288
    ./random_script_gen.sh $i 1024 524288 > rand_large_$i.job
    echo ./zbc_write_zone2 -p rand_large_$i.job -k $((1000/$i)) /dev/sdb
    ./zbc_write_zone2 -p rand_large_$i.job -k $((1000/$i)) /dev/sdb > rand_large_$i.log
    ./reset_write_ptr_all.sh /dev/sdb > /dev/null
    ../extract_bw.sh rand_large_$i.log > bw_rand_large_$i.csv
    paste $result_file bw_rand_large_$i.csv > temp.csv
    mv temp.csv $result_file
done

head -n 900 $result_file > temp.csv
mv temp.csv $result_file
echo mv $result_file ~
mv $result_file ~
#tar cf ~/bw_rand_large.tar *.csv
rm *.csv *.log *.job
