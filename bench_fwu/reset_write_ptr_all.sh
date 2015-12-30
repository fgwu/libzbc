#!/bin/bash



if [ $# -ne 1 ]; then
    echo $0: reset the write pointer for all opened zones
    echo usage: $0 dev
    exit 1
fi

zbc_report_zones $1 | grep Implicit | awk '{ print $2}' | sed 's/://g' > temp-implicit.log

zbc_report_zones $1 | grep Explicit | awk '{ print $2}' | sed 's/://g' > temp-explicit.log

zbc_report_zones $1 | grep Full | awk '{ print $2}' | sed 's/://g' > temp-full.log

zbc_report_zones $1 | grep Closed | awk '{ print $2}' | sed 's/://g' > temp-closed.log

#for i in `seq $2 $3`;
#do
#    echo zbc_reset_write_ptr $1 $i
#    zbc_reset_write_ptr $1 $i > /dev/null
#done

echo zbc_reset_write_ptr $1 -1
zbc_reset_write_ptr $1 -1 > /dev/null


echo reset `cat temp-implicit.log temp-explicit.log temp-full.log temp-closed.log|wc -l ` zones 
echo `wc -l temp-implicit.log` implicit-open zones 
echo `wc -l temp-implicit.log` explicit-open zones 
echo `wc -l temp-full.log` full-open zones 
echo `wc -l temp-closed.log` closed zones 
rm temp-implicit.log
rm temp-explicit.log
rm temp-full.log
rm temp-closed.log
