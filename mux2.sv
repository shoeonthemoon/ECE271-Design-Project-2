module mux2 #(
    parameter BUS_WIDTH = 8
)(
    input  logic [BUS_WIDTH-1:0] d0,
    input  logic [BUS_WIDTH-1:0] d1,
    input  logic s,
    output logic [BUS_WIDTH-1:0] y
);
    assign y = s ? d1 : d0;
endmodule
