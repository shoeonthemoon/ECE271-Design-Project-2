vsim -gui work.parser
add wave *

force value 8'b00000000 @ 0, 8'b00001000 @ 5, 8'b00100000 @ 10

run 20