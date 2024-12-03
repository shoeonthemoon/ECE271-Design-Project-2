`include "mux2.sv"
`include "parser.sv"
`include "sevenseg.sv"

module switching_dual_seven_seg_driver #(
    parameter BUS_WIDTH = 8
)(
    input  logic [BUS_WIDTH-1:0] value0,
    input  logic [BUS_WIDTH-1:0] value1,
    input  logic s,
    output logic [6:0] ones_segments,
    output logic [6:0] tens_segments
);

    logic [BUS_WIDTH-1:0] mux_out;
    logic [3:0] ones, tens;

    mux2 #(
        .BUS_WIDTH(BUS_WIDTH)
    ) mux_inst (
        .d0(value0),
        .d1(value1),
        .s(s),
        .y(mux_out)
    );

    parser #(
        .BUS_WIDTH(BUS_WIDTH)
    ) parser_inst (
        .value(mux_out),
        .ones(ones),
        .tens(tens)
    );

    sevenseg ones_display (
        .data(ones),
        .segments(ones_segments)
    );

    sevenseg tens_display (
        .data(tens),
        .segments(tens_segments)
    );

endmodule
