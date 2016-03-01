#!/bin/bash
n=256
i=0

sudo zbc_reset_write_ptr /dev/sdb -1
while [ $i -lt $n ];
do
    echo sudo zbc_open_zone /dev/sdb $(($i + 64))
    sudo zbc_open_zone /dev/sdb $(($i + 64))
    i=$(($i+1))
done 
echo sudo zbc_report_zones /dev/sdb | grep "\-open"
sudo zbc_report_zones /dev/sdb | grep "\-open" | wc -l
echo sudo zbc_report_zones /dev/sdb | grep "Explicit\-open"
sudo zbc_report_zones /dev/sdb | grep "Explicit\-open" | wc -l
