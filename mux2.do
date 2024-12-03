vsim -gui work.mux2

add wave *

force d0 8'b00001111
force d1 8'b11110000
force s 0
run 100
force s 1
run 100