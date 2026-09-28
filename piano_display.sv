// This module displays piano keys on the VGA display
// and colors the keys with their respective color if they key is being played
// inputs
// 10bit X: The x value from the VGA display and where the color will change
// 9bit Y: The y position from the VGA where the color will change
// 8 bit: active keys where each bit repersents a different key
//output:
//  8 bit RGB: The RGB value for each pixel to give to the VGA driver.
module piano_display (
    input  logic [9:0] x,           // current pixel x from video_driver (0–639)
    input  logic [8:0] y,           // current pixel y from video_driver (0–479)
    input  logic [7:0] active_keys, 
    output logic [7:0] r, g, b
);

    // Layout: 8 keys × 80px wide
    localparam KEY_W      = 80;
    localparam KEY_H      = 360;
    localparam KEY_TOP    = 60;
    localparam KEY_BOT    = KEY_TOP + KEY_H;   
	 
   
    logic [2:0] key_index;
    logic [6:0] key_local_x;
    logic       in_key_region;
    logic       pressed;
    logic       is_divider;
    logic       is_top_border;
    logic       is_bot_border;
    logic       is_left_edge;
    logic       is_right_edge;
    logic       in_highlight_band;
    logic       is_shadow_line;

    assign key_index       = x / KEY_W;                  // 0–7
    assign key_local_x     = x - (key_index * KEY_W);    // 0–79 within key
    assign in_key_region   = (y >= KEY_TOP) && (y < KEY_BOT);
    assign pressed         = active_keys[key_index];

    assign is_left_edge    = (x == 0);
    assign is_right_edge   = (x == 639);
    assign is_divider      = (key_local_x == 0) && !is_left_edge;
    assign is_top_border   = (y == KEY_TOP);
    assign is_bot_border   = (y == KEY_BOT - 1);

    assign in_highlight_band = (y < KEY_TOP + 60);        // top 60px = bright highlight
    assign is_shadow_line    = (y == KEY_BOT - 6) && !pressed;
    
    logic [7:0] note_r [0:7];
    logic [7:0] note_g [0:7];
    logic [7:0] note_b [0:7];

    always_comb begin
        note_r[0] = 8'hFF; note_g[0] = 8'h4D; note_b[0] = 8'h4D; // C4 — red
        note_r[1] = 8'hFF; note_g[1] = 8'hA0; note_b[1] = 8'h30; // D4 — orange
        note_r[2] = 8'hFF; note_g[2] = 8'hD6; note_b[2] = 8'h00; // E4 — yellow
        note_r[3] = 8'h5C; note_g[3] = 8'hE8; note_b[3] = 8'h5C; // F4 — green
        note_r[4] = 8'h00; note_g[4] = 8'hE0; note_b[4] = 8'hE0; // G4 — cyan
        note_r[5] = 8'h44; note_g[5] = 8'hAA; note_b[5] = 8'hFF; // A4 — blue
        note_r[6] = 8'hBB; note_g[6] = 8'h66; note_b[6] = 8'hFF; // B4 — violet
        note_r[7] = 8'hFF; note_g[7] = 8'h55; note_b[7] = 8'hCC; // C5 — pink
    end

    // Dimmed highlight for lower portion of pressed key
    logic [7:0] dim_r, dim_g, dim_b;
    assign dim_r = {1'b0, note_r[key_index][7:1]};
    assign dim_g = {1'b0, note_g[key_index][7:1]};
    assign dim_b = {1'b0, note_b[key_index][7:1]};

    // Color decision
    
    always_comb begin
        // Default: dark navy background
        r = 8'h0F; g = 8'h11; b = 8'h17;

        if (in_key_region) begin

            if (pressed) begin
                // Bright top band, dimmer below
                if (in_highlight_band) begin
                    r = note_r[key_index];
                    g = note_g[key_index];
                    b = note_b[key_index];
                end else begin
                    r = dim_r;
                    g = dim_g;
                    b = dim_b;
                end

            end else begin
                // Unpressed: warm white with subtle shadow line
                if (is_shadow_line) begin
                    r = 8'hD4; g = 8'hD0; b = 8'hC8;
                end else begin
                    r = 8'hF0; g = 8'hEE; b = 8'hE8;
                end
            end

            // Borders drawn on top of fill
            if (is_divider || is_top_border || is_bot_border ||
                is_left_edge || is_right_edge) begin
                r = 8'h1A; g = 8'h1A; b = 8'h2A;
            end

        end
    end

endmodule