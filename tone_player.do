vsim -gui work.tone_player

add wave *

force clk 0 @ 0, 1 @ 1 -r 2
force START 0 @ 0, 1 @ 3
force STOP 1

run 1000000