#!/bin/sh


#cat $1 | grep BW | awk '{ print $2  }' 

echo evg BW $1
cat $1 | grep BW | awk '{ total += $2; count++  } END {print total/count}' 

echo evg IOPS $1
cat $1 | grep IOPS | awk '{ total += $2; count++  } END {print total/count}' 
