#!/bin/sh
cat $1 | grep timestamp | awk '{ print $2  }'  
