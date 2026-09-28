// This module mixes audio for each together whenever that respetive key is pressed and
// when read is active from the Audio driver, it is then sent to the audio drivers to be played
// inputs
// 8 key: keys where each bit repersents a different key
// reset: Resets the counters
// clk: for the module
// read: read signal from audio driver
//output:
//  24 bit signed: The value for the note after mixing all active keys together
module note_player (reset, clk, read, key, note);
	input logic reset, clk, read;
	input logic [7:0] key;
	output logic signed [23:0] note;
	
	logic [12:0] C4_address, D4_address, E4_address, F4_address, G4_address, A4_address,
					B4_address, C5_address;
	logic [23:0] C4_raw, D4_raw, E4_raw, F4_raw, G4_raw, A4_raw, B4_raw, C5_raw;
	
	localparam logic [12:0] C4_Max = 16'd4647;
	localparam logic [12:0] D4_Max = 16'd4727;
	localparam logic [12:0] E4_Max = 16'd4733;
	localparam logic [12:0] F4_Max = 16'd4472;
	localparam logic [12:0] G4_Max = 16'd4419;
	localparam logic [12:0] A4_Max = 16'd4739;
	localparam logic [12:0] B4_Max = 16'd4223;
	localparam logic [12:0] C5_Max = 16'd4619;
	
	C4_ROM C4Note (C4_address, clk, C4_raw);
	
	D4_ROM D4Note (D4_address, clk, D4_raw);
	
	E4_ROM E4Note (E4_address, clk, E4_raw);
	
	F4_ROM F4Note (F4_address, clk, F4_raw);
	
	G4_ROM G4Note (G4_address, clk, G4_raw);
	
	A4_ROM A4Note (A4_address, clk, A4_raw);
	
	B4_ROM B4Note (B4_address, clk, B4_raw);
	
	C5_ROM C5Note (C5_address, clk, C5_raw);
	
	logic signed [23:0] C4, D4, E4, F4, G4, A4, B4, C5;
	
	assign C4 = key[0] ? $signed(C4_raw) : '0;
	assign D4 = key[1] ? $signed(D4_raw) : '0;
	assign E4 = key[2] ? $signed(E4_raw) : '0;
	assign F4 = key[3] ? $signed(F4_raw) : '0;
	assign G4 = key[4] ? $signed(G4_raw) : '0;
	assign A4 = key[5] ? $signed(A4_raw) : '0;
	assign B4 = key[6] ? $signed(B4_raw) : '0;
	assign C5 = key[7] ? $signed(C5_raw) : '0;
	

	//counter for each note 
	
	//C4_counter
	always_ff @(posedge clk) begin
			if(reset || C4_address == C4_Max || ~key[0]) 
				C4_address <= 13'd0;
			else
				if(read && (key[0]))
					C4_address <= C4_address + 13'd1;
				else 
					C4_address <= C4_address;
		end
	
	//D4_counter 
	always_ff @(posedge clk) begin
			if(reset || D4_address == D4_Max || ~key[1]) 
				D4_address <= 13'd0;
			else
				if(read && (key[1]))
					D4_address <= D4_address + 13'd1;
				else 
					D4_address <= D4_address;
		end
	
	//E4_counter
	always_ff @(posedge clk) begin
			if(reset || E4_address == E4_Max || ~key[2]) 
				E4_address <= 13'd0;
			else
				if(read && (key[2]))
					E4_address <= E4_address + 13'd1;
				else 
					E4_address <= E4_address;
		end
	//F4_counter
	always_ff @(posedge clk) begin
			if(reset || F4_address == F4_Max || ~key[3]) 
				F4_address <= 13'd0;
			else
				if(read && (key[3]))
					F4_address <= F4_address + 13'd1;
				else 
					F4_address <= F4_address;
		end
		
	//G4_counter
	always_ff @(posedge clk) begin
			if(reset || G4_address == G4_Max || ~key[4]) 
				G4_address <= 13'd0;
			else
				if(read && (key[4]))
					G4_address <= G4_address + 13'd1;
				else 
					G4_address <= G4_address;
		end
		
	//A4_counter
	always_ff @(posedge clk) begin
			if(reset || A4_address == A4_Max || ~key[5]) 
				A4_address <= 13'd0;
			else
				if(read && (key[5]))
					A4_address <= A4_address + 13'd1;
				else 
					A4_address <= A4_address;
		end
	
	
	//B4_counter
	always_ff @(posedge clk) begin
			if(reset || B4_address == B4_Max || ~key[6]) 
				B4_address <= 13'd0;
			else
				if(read && (key[6]))
					B4_address <= B4_address + 13'd1;
				else 
					B4_address <= B4_address;
		end
		
	//C5_counter
	always_ff @(posedge clk) begin
			if(reset || C5_address == C5_Max || ~key[7]) 
				C5_address <= 13'd0;
			else
				if(read && (key[7]))
					C5_address <= C5_address + 13'd1;
				else 
					C5_address <= C5_address;
		end
		
		
		
		//assign note = (C4 + D4 + E4 + F4 + G4 + A4 + B4 + C5)/ (24'd8);
		
		
	logic signed [27:0] sum;
    
    always_comb begin
        sum = {{4{C4[23]}}, C4}
            + {{4{D4[23]}}, D4}
            + {{4{E4[23]}}, E4}
            + {{4{F4[23]}}, F4}
            + {{4{G4[23]}}, G4}
            + {{4{A4[23]}}, A4}
            + {{4{B4[23]}}, B4}
            + {{4{C5[23]}}, C5};
    
        note = sum >>> 3;
    end
		
	
	
		
	
		
		
	
	
	
		
		
endmodule 
		
		
		
		