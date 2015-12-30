reset

set terminal postscript eps color enhanced size 5,7 font "Times-Roman" 22
set output 'working_set_zoomin.eps'

set xlabel 'Time (s)'
set ylabel 'Throughput (MiB/s)'

set border 3 back
set tics nomirror out scale 0.75

unset key

set multiplot layout 4,1


set key title '256 zone: w/o cache'
set xrange [0:20]
set yrange [0:50]
plot 'bw_zone256_wo_cache.csv' u 2:1 notitle pt '.' w l


set key title '8 zone: w/o cache'
set xrange [0:20]
set yrange [0:50]
plot 'bw_zone8_wo_cache.csv' u 2:1 notitle pt '.' w l


set key title '256 zone: w cache'
set  xrange [0:20]
set yrange [0:50]
plot 'bw_zone256_w_cache.csv' u 2:1 notitle pt '.' w l



set key title '8 zone: w cache'
set xrange [0:20]
set yrange [0:50]
plot 'bw_zone8_w_cache.csv' u 2:1 notitle pt '.' w l

