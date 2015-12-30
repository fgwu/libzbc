reset

set terminal postscript eps color enhanced size 5,3.5 font "Times-Roman" 22
set output 'long_rand_finer2.eps'

set xlabel 'Time (s)'
set ylabel 'Throughput (MiB/s)'

set border 3 back
set tics nomirror out scale 0.75

unset key

#set multiplot layout 2,1

plot 'bw_range_zone8_4000000.csv' u 2:1 pt '.'

#set ytics 1
#set ylabel "#non-seq zones"
#set yrange [0:9000]
#plot 'nonseq_range8_4000000.csv' u 1:2 w l ps .6

