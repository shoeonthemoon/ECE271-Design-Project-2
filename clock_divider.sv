module clock_divider #(
    parameter N = 8,       // Width of the counter (number of bits)
    parameter B = 10       // Value to compare the counter against
)(
    input  logic counter_clk,          // Clock signal for the counter
    input  logic fast_clk,             // Fast clock signal
    input  logic disable_divider,      // Disable signal (true to stop the counter and prevent reset)
    input  logic manual_reset,         // Manual reset signal
    output logic q,                    // Output signal
    output logic [N-1:0] counter_value // Current counter value
);

    // Counter register
    logic [N-1:0] counter;

    // Counter increment and reset logic
    always_ff @(posedge counter_clk or posedge manual_reset) begin
        if (manual_reset) begin
            // Counter resets only if disable_divider is low
            if (!disable_divider) begin
                counter <= 0;
            end
        end else if (!disable_divider) begin
            // Increment counter if disable_divider is low
            if (counter >= B) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Output the current counter value
    assign counter_value = counter;

    // Output logic
    always_ff @(posedge fast_clk or posedge manual_reset) begin
        if (manual_reset) begin
            q <= 0; // Reset the output
        end else begin
            q <= (counter >= B); // Output high only when fast_clk is high AND counter >= B
        end
    end

endmodule
