//Noah Yoon, Raiyan Hasan
//Student ID’s: 2320472, 2103444
//EE 371
//6/10/2026

//This module connects the piano FPGA to all the drivers and uses the N8 driver to controll it. 
// On LabsLand 
// W = C4
// A = D4
// S = E4
// D = F4
// H = G4
// J = A4
// K= B4
// L = C5

//reset = switch 5
//switch 9 = the switch from N8 controller to keys on FPGA
 
//where the letters are the keyboard inputs
module DE1_SoC (CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT,
	AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT,
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO,
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);

	input logic CLOCK_50, CLOCK2_50;
	//input logic [3:0] KEY;
	//input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	inout [35:0] V_GPIO;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	
	
	
	//VGA signals
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	
	
	// Local wires
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	
	wire latchSignal;
	wire pulse;
	    
	wire C4;
	wire D4;
	wire E4;
	wire F4;
	wire G4;
	wire A4;
	wire B4;
	wire C5;
	assign V_GPIO[27] = pulse;
   assign V_GPIO[26] = latchSignal;
	
	n8_driver driver(
        .clk(CLOCK_50),
        .data_in(V_GPIO[28]),
        .latch(latchSignal),
        .pulse(pulse),
        .up(C4),
        .down(E4),
        .left(D4),
        .right(F4),
        .select(G4),
        .start(A4),
        .a(B4),
        .b(C5)
    );
	 
	 
	 video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);

	 
	
	//sw5
	assign reset = V_GPIO[10];
	
	assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = '1;
	//assign LEDR = {V_GPIO[14],V_GPIO[13],V_GPIO[12],V_GPIO[11],V_GPIO[10],V_GPIO[9],V_GPIO[8],V_GPIO[7],V_GPIO[6],V_GPIO[5]};
	//assign LEDR = {~V_GPIO[3]~V_GPIO[2],~V_GPIO[1],~V_GPIO[0]};
	
	
	logic [7:0] keyData;
	
	assign keyData = {V_GPIO[8],V_GPIO[7],V_GPIO[6],V_GPIO[5],~V_GPIO[3],~V_GPIO[2],
		~V_GPIO[1],~V_GPIO[0]}; 
	
	// only read or write when both are possible
	
	logic [7:0] noteData; 
	
	assign noteData = {C5,B4,A4,G4,F4,E4,D4,C4};
	
	logic [7:0] VGA_input;
	
	assign VGA_input = {B4,C5,A4,G4,F4,E4,D4,C4};
	
	logic [23:0] notes;
	
	logic [7:0] inputData;
	
	logic [7:0] VGA_data;
	
	assign inputData = V_GPIO[14] ? keyData : noteData;
	
	assign VGA_data = V_GPIO[14] ? keyData : VGA_input;
	
	assign LEDR = V_GPIO[14] ? keyData : noteData; 
	

	
	note_player piano (.reset, .clk(CLOCK_50), .read, .key(inputData), .note(notes));
	
	piano_display piano_vga (.x, .y, .active_keys(VGA_data), .r, .g, .b);

	
	assign writedata_left = inputData ? notes : 24'sd0;
    assign writedata_right = inputData ? notes : 24'sd0;		
	
	assign read = read_ready & write_ready;
	assign write = read_ready & write_ready;
	
	
	

	
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		1'b0,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		1'b0,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		1'b0,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


