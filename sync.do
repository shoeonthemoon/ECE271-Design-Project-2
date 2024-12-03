vsim -gui work.sync
add wave *

force clk 0 @ 0, 1 @ 1 -r 2
force d 0 @ 0, 1 @ 2, 0 @ 6 -r 10

run 100