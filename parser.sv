module parser #(
    parameter BUS_WIDTH = 8
)(
    input logic [BUS_WIDTH-1:0] value,
    output logic [3:0] ones,
    output logic [3:0] tens
);

    always_comb begin
        tens = value / 10;
        ones = value % 10;
    end

endmodule