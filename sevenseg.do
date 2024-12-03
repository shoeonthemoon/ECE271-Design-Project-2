vsim -gui work.sevenseg
add wave *

force data 4'h1 @ 0, 4'h4 @ 5, 4'h7 @ 10

run 25
