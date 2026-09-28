// This module tests for all the ROM values within each ROM
// It test to make sure the audio mixer is working well
// It tests to see if read or reset makes the notes zero.
`timescale 1ps/1ps
module note_player_tb();
	logic reset, clk, read;
	logic [7:0] key;
	logic signed [23:0] note;
	
	
	note_player dut (.*);
	
	parameter CLOCK_PERIOD=100;
	initial begin	
		clk <= 0;	
		forever #(CLOCK_PERIOD/2) clk <= ~clk;	// Forever toggle the clock
	end


	initial begin
		reset <= 1; key = 8'b00000000; read <= 0; @(posedge clk);
		reset <= 0; key = 8'b00000000; read <= 0; @(posedge clk);
		
		//read every value from C4 
		reset <= 0; key = 8'b00000001; read <= 1; repeat (4650) @(posedge clk);
		#1;
		if(note == 24'd0)
			$display("time=%0t,note=%0d has looped", $time, note);
		else 
			$display("time=%0t,note=%0d has not looped", $time, note);
		
		reset <= 0; key = 8'b00000001; read <= 0; repeat (2) @(posedge clk);
		//read every value from D4 
		reset <= 0; key = 8'b00000010; read <= 1; repeat (4730) @(posedge clk);
		#1;
		if(note == 24'd0)
			$display("time=%0t,note=%0d has looped", $time, note);
		else 
			$display("time=%0t,note=%0d has not looped", $time, note);
		
		reset <= 0; key = 8'b00000001; read <= 0; repeat (2) @(posedge clk);
		
		//read every value from E4
		reset <= 0; key = 8'b00000100; read <= 1; repeat (4736) @(posedge clk);
		#1;
		if(note == 24'd0)
			$display("time=%0t,note=%0d has looped", $time, note);
		else 
			$display("time=%0t,note=%0d has not looped", $time, note);
		
		reset <= 0; key = 8'b00000001; read <= 0; repeat (2) @(posedge clk);
		
		//read every value from F4
		reset <= 0; key = 8'b00001000; read <= 1; repeat (4475) @(posedge clk);
		#1;
		if(note == 24'd0)
			$display("time=%0t,note=%0d has looped", $time, note);
		else 
			$display("time=%0t,note=%0d has not looped", $time, note);
		
		reset <= 0; key = 8'b00000001; read <= 0; repeat (2) @(posedge clk);
		
		//read evert value from G4
		reset <= 0; key = 8'b00010000; read <= 1; repeat (4422) @(posedge clk);
		#1;
		if(note == 24'd0)
			$display("time=%0t,note=%0d has looped", $time, note);
		else 
			$display("time=%0t,note=%0d has not looped", $time, note);
		
		reset <= 0; key = 8'b00000001; read <= 0; repeat (2) @(posedge clk);
		
		//read every value from A4
		reset <= 0; key = 8'b00100000; read <= 1; repeat (4742) @(posedge clk);
		
		reset <= 0; key = 8'b00000001; read <= 0; repeat (2) @(posedge clk);
		
		//read every value from B4
		reset <= 0; key = 8'b01000000; read <= 1; repeat (4226) @(posedge clk);
		#1;
		if(note == 24'd0)
			$display("time=%0t,note=%0d has looped", $time, note);
		else 
			$display("time=%0t,note=%0d has not looped", $time, note);
		
		reset <= 0; key = 8'b00000001; read <= 0; repeat (2) @(posedge clk);
		
		//read every value from C5
		reset <= 0; key = 8'b10000000; read <= 1; repeat (4622) @(posedge clk);
		#1;
		if(note == 24'd0)
			$display("time=%0t,note=%0d has looped", $time, note);
		else 
			$display("time=%0t,note=%0d has not looped", $time, note);
		
		
		reset <= 0; key = 8'b00000000; read <= 0; repeat (2) @(posedge clk);
		reset <= 1; key = 8'b00000000; read <= 0; repeat (2) @(posedge clk);
		reset <= 0; key = 8'b00000000; read <= 0; repeat (2) @(posedge clk);
		
		//all playing at the same time 
		reset <= 0; key = 8'b11111111; read <= 1; repeat (5) @(posedge clk);
		#1;
		if(note == 24'd505603)
			$display("time=%0t,note=%0d is equal to 505603", $time, note);
		else 
			$display("time=%0t,note=%0d is not equal to 505603", $time, note);
		
		
		$stop;
	end
endmodule

