reset

set terminal postscript eps color enhanced size 5,3.5 font "Times-Roman" 22
set output 'long_rand.eps'

#set terminal jpeg size 5,3.5 "Times-Roman" 22
#set output "long_rand.jpg"

#set output '| ps2pdf - long_rand.pdf'

set ylabel "Throughput (MB/s)"
set xlabel 'Time (s)'

set xrange[0:60000]
set yrange[0:400]

set ytics 100

set border 3 back
set tics nomirror out scale 0.75


set multiplot layout 2,1

plot "bw_range_zone256_4000000.csv" u 2:1 t 'Throughput' pt "."

set ylabel "#non-seq zone"
set xlabel 'Time (s)'

set xrange[0:60000]
set yrange[0:200]

set ytics 50

plot "zone_256_4000000.csv" u 1:2 t '#nonseq zones' pt '.'