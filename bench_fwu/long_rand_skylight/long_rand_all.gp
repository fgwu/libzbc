reset

set terminal postscript eps color enhanced size 5,3.5 font "Times-Roman" 22
set output 'long_rand_all.eps'

#set terminal jpeg size 5,3.5 "Times-Roman" 22
#set output "long_rand.jpg"

#set output '| ps2pdf - long_rand.pdf'

set ylabel "Throughput (MB/s)"
set xlabel 'Time (s)'

set xrange[0:10000]
set yrange[0:300]

set ytics 100

set border 3 back
set tics nomirror out scale 0.75


set multiplot layout 2,1

plot "bw_zone_all_1000000.csv" u 2:1 t 'Throughput' pt 7 ps .5

set ylabel "#non-seq zone"
set xlabel 'Time (s)'

set xrange[0:10000]
set yrange[0:30000]

#set ytics 10000
set ytics ("0" 0, "10k" 10000, "20k" 20000, " 30k" 30000)

plot "zone_all_1000000.csv" u 1:2 t '#nonseq zones' pt 7 ps .5