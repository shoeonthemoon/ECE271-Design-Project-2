module tone_player #(
    parameter integer INPUT_FREQ_HZ = 50_000_000 // Input clock frequency in Hz
)(
    input logic CLK,                // 50 MHz input clock
    input logic START,              // Start signal (rising edge)
    input logic STOP,               // Stop signal (rising edge)
    output logic BUZZER             // Output for the buzzer
);

    // Define note frequencies in Hz
    localparam integer NOTE_C = 262; // C4
    localparam integer NOTE_D = 294; // D4
    localparam integer NOTE_E = 330; // E4
    localparam integer NOTE_F = 349; // F4
    localparam integer NOTE_G = 392; // G4
    localparam integer NOTE_A = 440; // A4
    localparam integer SILENCE = 0;  // No tone (silence)

    // Define note durations in clock cycles
    localparam integer NOTE_DURATION = INPUT_FREQ_HZ * 0.5; // 0.5 seconds per note
    localparam integer REST_DURATION = INPUT_FREQ_HZ * 0.1; // 0.1 seconds rest

    // State machine for notes and rests
    typedef enum logic [5:0] {
        STATE_IDLE, STATE_C, STATE_REST1, STATE_C2, STATE_REST2,
        STATE_G, STATE_REST3, STATE_G2, STATE_REST4,
        STATE_A, STATE_REST5, STATE_A2, STATE_REST6,
        STATE_G3, STATE_REST7, STATE_F, STATE_REST8,
        STATE_F2, STATE_REST9, STATE_E, STATE_REST10,
        STATE_E2, STATE_REST11, STATE_D, STATE_REST12,
        STATE_D2, STATE_REST13, STATE_C3, STATE_REST14,
        STATE_SILENCE
    } state_t;

    state_t current_state = STATE_IDLE, next_state; // State registers

    integer tone_counter = 0;        // Counts clock cycles for each note or rest duration
    integer tone_div_counter = 0;    // Clock divider counter
    logic tone_clk = 0;              // Tone clock
    integer tone_frequency = SILENCE; // Current tone frequency
    logic song_active = 0;           // Indicates whether the song is active

    // Detect rising edges of START and STOP signals
    logic prev_start, prev_stop;
    always_ff @(posedge CLK) begin
        prev_start <= START;
        prev_stop <= STOP;
    end
    wire start_rising_edge = START && !prev_start;
    wire stop_rising_edge = STOP && !prev_stop;

    // Activate or deactivate the song based on control signals
    always_ff @(posedge CLK) begin
        if (start_rising_edge) begin
            song_active <= 1; // Start the song
        end else if (stop_rising_edge) begin
            song_active <= 0; // Stop the song
        end
    end

    // Clock divider for tone generation
    always_ff @(posedge CLK) begin
        if (tone_frequency != SILENCE && tone_div_counter >= (INPUT_FREQ_HZ / (tone_frequency * 2)) - 1) begin
            tone_div_counter <= 0;
            tone_clk <= ~tone_clk; // Toggle tone clock
        end else begin
            tone_div_counter <= tone_div_counter + 1;
        end
    end

    // Tone and rest duration control
    always_ff @(posedge CLK) begin
        if ((tone_frequency == SILENCE && tone_counter >= REST_DURATION) ||
            (tone_frequency != SILENCE && tone_counter >= NOTE_DURATION)) begin
            tone_counter <= 0; // Reset counter at the end of a note or rest
            if (song_active) begin
                current_state <= next_state; // Transition to the next state
            end else begin
                current_state <= STATE_IDLE; // Return to idle if song is deactivated
            end
        end else begin
            tone_counter <= tone_counter + 1; // Increment counter
        end
    end

    // State machine for melody with rests
    always_comb begin
        case (current_state)
            STATE_IDLE: begin
                if (song_active) begin
                    next_state = STATE_C;
                    tone_frequency = SILENCE;
                end else begin
                    next_state = STATE_IDLE;
                    tone_frequency = SILENCE;
                end
            end
            STATE_C:      begin next_state = STATE_REST1; tone_frequency = NOTE_C; end
            STATE_REST1:  begin next_state = STATE_C2;   tone_frequency = SILENCE; end
            STATE_C2:     begin next_state = STATE_REST2; tone_frequency = NOTE_C; end
            STATE_REST2:  begin next_state = STATE_G;    tone_frequency = SILENCE; end
            STATE_G:      begin next_state = STATE_REST3; tone_frequency = NOTE_G; end
            STATE_REST3:  begin next_state = STATE_G2;   tone_frequency = SILENCE; end
            STATE_G2:     begin next_state = STATE_REST4; tone_frequency = NOTE_G; end
            STATE_REST4:  begin next_state = STATE_A;    tone_frequency = SILENCE; end
            STATE_A:      begin next_state = STATE_REST5; tone_frequency = NOTE_A; end
            STATE_REST5:  begin next_state = STATE_A2;   tone_frequency = SILENCE; end
            STATE_A2:     begin next_state = STATE_REST6; tone_frequency = NOTE_A; end
            STATE_REST6:  begin next_state = STATE_G3;   tone_frequency = SILENCE; end
            STATE_G3:     begin next_state = STATE_REST7; tone_frequency = NOTE_G; end
            STATE_REST7:  begin next_state = STATE_F;    tone_frequency = SILENCE; end
            STATE_F:      begin next_state = STATE_REST8; tone_frequency = NOTE_F; end
            STATE_REST8:  begin next_state = STATE_F2;   tone_frequency = SILENCE; end
            STATE_F2:     begin next_state = STATE_REST9; tone_frequency = NOTE_F; end
            STATE_REST9:  begin next_state = STATE_E;    tone_frequency = SILENCE; end
            STATE_E:      begin next_state = STATE_REST10; tone_frequency = NOTE_E; end
            STATE_REST10: begin next_state = STATE_E2;   tone_frequency = SILENCE; end
            STATE_E2:     begin next_state = STATE_REST11; tone_frequency = NOTE_E; end
            STATE_REST11: begin next_state = STATE_D;    tone_frequency = SILENCE; end
            STATE_D:      begin next_state = STATE_REST12; tone_frequency = NOTE_D; end
            STATE_REST12: begin next_state = STATE_D2;   tone_frequency = SILENCE; end
            STATE_D2:     begin next_state = STATE_REST13; tone_frequency = NOTE_D; end
            STATE_REST13: begin next_state = STATE_C3;   tone_frequency = SILENCE; end
            STATE_C3:     begin next_state = STATE_REST14; tone_frequency = NOTE_C; end
            STATE_REST14: begin next_state = STATE_SILENCE; tone_frequency = SILENCE; end
            STATE_SILENCE: begin next_state = STATE_IDLE; tone_frequency = SILENCE; end
            default:      begin next_state = STATE_IDLE; tone_frequency = SILENCE; end
        endcase
    end
