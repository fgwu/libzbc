#!/bin/bash

if [ $# -ne 3 ]
then
    echo Usage: $0 dev file_in file_out
fi

echo fio version 2 iolog > $3
echo $1 add >> $3
echo $1 open >> $3


cat $2 | awk -F"," -v dev="/dev/sdb" '{ if ($4=="Write") print dev " write "  $5 " " $6; else print dev " read " $5 " " $6}' >> $3

echo $1 close >> $3
