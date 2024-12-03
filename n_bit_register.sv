module n_bit_register #(
    parameter N = 8 // Width of the register, default is 8-bit
)(
    input wire clk,              // Clock signal
    input wire reset,            // Asynchronous reset signal
    input wire enable,           // Enable signal for loading data
    input wire [N-1:0] data_in,  // Data input
    output reg [N-1:0] data_out  // Data output
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 0;          // Reset the output to 0
    end else if (enable) begin
        data_out <= data_in;     // Load the input data when enabled
    end
    // If enable is low, keep the current value of data_out
end

endmodule
