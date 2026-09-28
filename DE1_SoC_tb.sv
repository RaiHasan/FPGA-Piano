//Tests the integration of task 1 and task 2
// Tests the basic cases for both and edge cases
// Checks to see if the hardware turns on and off accordingly 
`timescale 1 ps / 1 ps
module DE1_SoC_tb();	
	logic CLOCK_50, CLOCK2_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	
	wire [35:0] V_GPIO;
	logic [35:0] V_GPIO_in;
	logic [35:0] V_GPIO_dir; 
	
	
	// I2C Audio/Video config interface
	logic FPGA_I2C_SCLK;
	wire  FPGA_I2C_SDAT;
	// Audio CODEC
	logic AUD_XCK;
	logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	logic AUD_ADCDAT;
	logic AUD_DACDAT;
	
	
	
	
	//VGA signals
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	 

	
	DE1_SoC dut (.*);
	
	
	logic n8_serial_data;
	logic mode_sw;
	logic reset_sw;

	assign V_GPIO[28] = n8_serial_data; // fake N8 controller data
	assign V_GPIO[14] = mode_sw;        // mode select: 0 = N8 noteData
	assign V_GPIO[10] = reset_sw;       // reset switch
	parameter CLOCK_PERIOD=100;
	initial begin	
		CLOCK_50 <= 0;	
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;	// Forever toggle the clock
	end

	initial begin	
		CLOCK2_50 <= 0;	
		forever #(CLOCK_PERIOD/2) CLOCK2_50 <= ~CLOCK2_50;
	end
	
  
  task send_n8_data(input logic [7:0] data_value);
    integer i;
    begin
        // simulatues the N8 based on the n8 and serial driver
        @(posedge V_GPIO[26]); // latch high

        
        n8_serial_data = data_value[7];
        
        for (i = 6; i >= 0; i = i - 1) begin
            @(posedge V_GPIO[27]); 
            n8_serial_data = data_value[i]; 
        end

        
        repeat (10) @(posedge CLOCK_50);
		end
	endtask
	
	
	localparam logic [7:0] PRESS_C4 = 8'b11110111; 
	localparam logic [7:0] PRESS_D4 = 8'b11111101;
	localparam logic [7:0] PRESS_E4 = 8'b11111011; 
	localparam logic [7:0] PRESS_F4 = 8'b11111110; 
	localparam logic [7:0] PRESS_G4 = 8'b11011111; 
	localparam logic [7:0] PRESS_A4 = 8'b11101111;
	localparam logic [7:0] PRESS_B4 = 8'b01111111; 
	localparam logic [7:0] PRESS_C5 = 8'b10111111; 

	localparam logic [7:0] PRESS_NONE = 8'b11111111;
	localparam logic [7:0] PRESS_ALL  = 8'b00000000;
	
	
	//Checks to see if vga is outputting correct numbers 
	task check_vga_pixel(
	 input logic [9:0] testX,
	 input logic [8:0] testY,
	 input logic [7:0] R,
	 input logic [7:0] G,
	 input logic [7:0] B,
	 input string name
	);
	 begin
			//waits until the scanner reaches the desired pixel
		  wait (dut.x == testX && dut.y == testY);

		  #1;

		  if (dut.r !== R || dut.g !== G || dut.b !== B) begin
				$display("failed: %s", name);
				$display("  At x=%0d y=%0d", dut.x, dut.y);
				$display("  Expected RGB = %h %h %h", R, G, B);
				$display("  Got RGB      = %h %h %h", dut.r, dut.g, dut.b);
				$display("  VGA_data     = %b", dut.VGA_data);
				$display("  noteData     = %b", dut.noteData);
		  end else begin
				$display("Expected: %s", name);
				$display("  At x=%0d y=%0d RGB=%h %h %h", dut.x, dut.y, dut.r, dut.g, dut.b);
		  end
		end
	endtask
	

	
	
	
	

	initial begin	
		n8_serial_data = 1'b1;
		reset_sw = 1; @(posedge CLOCK_50);
		reset_sw = 0; @(posedge CLOCK_50);
		
		
		
		send_n8_data(PRESS_ALL);
      @(posedge CLOCK_50);
			
			
			
			check_vga_pixel(40,  100,  8'hFF, 8'h4D, 8'h4D,
            "All pressed: C4 red");
			#10;

			check_vga_pixel(120, 100,  8'hFF, 8'hA0, 8'h30,
							"All pressed: D4 orange ");

			check_vga_pixel(200, 100,  8'hFF, 8'hD6, 8'h00,
							"All pressed: E4 yellow");
			#10;

			check_vga_pixel(280, 100, 8'h5C, 8'hE8, 8'h5C,
							"All pressed: F4 green");
			#10;

			check_vga_pixel(360, 100, 8'h00, 8'hE0, 8'hE0,
							"All pressed: G4 cyan ");
			#10;

			check_vga_pixel(440, 100,  8'h44, 8'hAA, 8'hFF,
							"All pressed: A4 blue");
			#10;

			check_vga_pixel(520, 100, 8'hBB, 8'h66, 8'hFF,
							"All pressed: B4 violet");
			#10;

			check_vga_pixel(600, 100, 8'hFF, 8'h55, 8'hCC,
							"All pressed: C5 pink");
							
			
			#1;
		if(dut.noteData == 24'd505603)
			$display("dut.noteData=%0d is equal to 505603",dut.noteData);
		else 
			$display("dut.noteData=%0d is not equal to 505603", dut.noteData);
					

		

		
		
		
	
		
		$stop;
	end	
endmodule