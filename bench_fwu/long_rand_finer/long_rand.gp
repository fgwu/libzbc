reset

set terminal postscript eps color enhanced size 5,3.5 font "Times-Roman" 22
set output 'long_rand.eps'

set ylabel "Latency (ms)"
set xlabel 'Operation Number'

#set xrange[1:1400]
#set yrange[0:1000000]


set border 3 back
set tics nomirror out scale 0.75



set multiplot layout 2,1

plot "bw_range_zone256_4000000.csv" u 2:1 t 'read after write'

set ylabel "#non-seq zone"
set xlabel 'Time (s)'

#set xrange[0:3000]
#set yrange[0:1600]
plot "range_4000000.log" u 1:2 t 'read after write'