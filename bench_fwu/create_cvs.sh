#!/bin/bash

if [ $# -ne 1 ]; then
    echo extract bandwith and IOPS infomation from the raw data.
    echo store them in cvs files.
    echo usage: $0 dir
    exit 1
fi


if [ ! -d $1 ]; then
    echo $1 is not a directory 
    exit 1
fi

mkdir -p $1/output
rm $1/output/*

for f in `ls -tr $1`; do
    if [ -d $1/$f ]; then
	continue
    fi
    echo extracting $f
    bwfile=`echo bw_$1$f | sed s/workingset//g | sed s/.txt/.csv/g | sed 's/\//_/g' | sed 's/zone_//g' `

    iopsfile=`echo iops_$1$f | sed s/workingset//g | sed s/.txt/.csv/g | sed 's/\//_/g'| sed 's/zone_//g' `

    cat $1/$f | grep BW | awk '{ print $2 }'  > $1/output/$bwfile
    cat $1/$f | grep IOPS | awk '{ print $2 }'  > $1/output/$iopsfile
done

#bwfile=`echo bw_$1.csv | sed s/workingset//g | sed 's/\///g'`
#iopsfile=`echo iops_$1.csv | sed s/workingset//g | sed 's/\///g'`

#paste -d , `ls $1/output/bw*.csv` > $1/output/$bwfile
#paste -d , `ls $1/output/iops*.csv` > $1/output/$iopsfile

cd $1/output
tarfile=`echo $1.tar| sed 's/\///g'`
echo tar -cf $tarfile *.csv
tar -cf $tarfile *.csv

mv $tarfile ../..
