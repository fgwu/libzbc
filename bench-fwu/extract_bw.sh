#!/bin/sh
cat $1 | grep BW | awk '{ print $2  }'  
