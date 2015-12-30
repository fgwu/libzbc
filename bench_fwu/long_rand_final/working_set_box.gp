reset

set terminal postscript eps color enhanced size 5,3.5 font "Times-Roman" 22
set output 'working_set_box.eps'


set style fill solid 0.25 border -1
set style boxplot nooutliers pointtype 7 labels off
set style data boxplot
set boxwidth  0.5
set pointsize 0.5

#unset key
#set border 2
set xtics ("256 w/o" 1, "8 w/o" 2, "256 w" 3, "8 w" 4) scale 0.0
set xtics nomirror
#set ytics nomirror
#set yrange [0:100]

#plot 'silver.dat' using (1):2, '' using (2):(5*$3)

set xtics auto
set yrange [*:*]
#set title "Distribution of energy usage of the continents, grouped by type of energy source\n"
#set ylabel "Billion Tons of Oil Equivalent"

plot 'bw_zone256_wo_cache_400000.csv' u (1):1 t '256 zone w/o cache',\
     'bw_zone8_wo_cache_400000.csv' u (2):1 t '8 zone w/o cache',\
     'bw_zone256_w_cache_400000.csv' u (3):1 t '256 zone w/ cache',\
     'bw_zone8_w_cache_400000.csv' u (4):1 t '8 zone w/ cache'


