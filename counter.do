vsim -gui work.counter

add wave *

force clk 0 @ 0, 1 @ 1 -r 2
force reset 1 @ 0, 0 @ 1

run 100
