// This module checks to see if an area is colored correctly when a key is displayed
// It also checks to make sure there isn't keys that are improperply being displayed. 
module piano_display_tb();
	
	 logic [9:0] x;           
	 logic [8:0] y;          
	 logic [7:0] active_keys;
    logic [7:0] r, g, b;
		
	 piano_display dut (.*);
	

	task check_color(
        input logic [9:0] testX,
        input logic [8:0] testY,
        input logic [7:0] keys,
        input logic [7:0] R,
        input logic [7:0] G,
        input logic [7:0] B,
        input string name
    );
			begin
            x = testX;
            y = testY;
            active_keys = keys;
            #1;

            if (r !== R || g !== G || b !== B) begin
                $display("didn't get correct RGB values %s", name);
                $display("  At x=%0d y=%0d active_keys=%b", x, y, active_keys);
                $display("  Supposed to be RGB = %h %h %h", R, G, B);
                $display("  Got RGB = %h %h %h", r, g, b);
            end else begin
                $display("got correct values %s", name);
            end
        end
   endtask

	initial begin
		active_keys = 8'b00000000;
      x = 0;
      y = 0;
      #10;
		
		//top area
		check_color(100, 20, 8'b00000000, 8'h0F, 8'h11, 8'h17, "Background above piano");
		#10;
		
		//unpressed key color
		check_color(40, 100, 8'b00000000, 8'hF0, 8'hEE, 8'hE8, "Unpressed key fill");
		#10;
		
		//check C4
		check_color(40, 100, 8'b00000001, 8'hFF, 8'h4D, 8'h4D,
            "C4 red");
				#10;
				
		check_color(120, 100, 8'b00000010, 8'hFF, 8'hA0, 8'h30,
            "D4 orange");
			#10;
				
		
		check_color(200, 100, 8'b00000100, 8'hFF, 8'hD6, 8'h00,
            "E4 yellow");
			#10;
		
		check_color(280, 100, 8'b00001000, 8'h5C, 8'hE8, 8'h5C,
            "F4 green");
				
		check_color(360, 100, 8'b00010000, 8'h00, 8'hE0, 8'hE0,
            "G4 cyan");
			#10;
				
		check_color(440, 100, 8'b00100000, 8'h44, 8'hAA, 8'hFF,
            "A4 blue");
			#10;
				
		check_color(520, 100, 8'b01000000, 8'hBB, 8'h66, 8'hFF,
            "B4 violet");
			#10;
		
		check_color(600, 100, 8'b10000000, 8'hFF, 8'h55, 8'hCC,
            "C5 pink");
			#10;
			
			check_color(40,  100, 8'b11111111, 8'hFF, 8'h4D, 8'h4D,
            "All pressed: C4 red");
			#10;

			check_color(120, 100, 8'b11111111, 8'hFF, 8'hA0, 8'h30,
							"All pressed: D4 orange ");

			check_color(200, 100, 8'b11111111, 8'hFF, 8'hD6, 8'h00,
							"All pressed: E4 yellow");
			#10;

			check_color(280, 100, 8'b11111111, 8'h5C, 8'hE8, 8'h5C,
							"All pressed: F4 green");
			#10;

			check_color(360, 100, 8'b11111111, 8'h00, 8'hE0, 8'hE0,
							"All pressed: G4 cyan ");
			#10;

			check_color(440, 100, 8'b11111111, 8'h44, 8'hAA, 8'hFF,
							"All pressed: A4 blue");
			#10;

			check_color(520, 100, 8'b11111111, 8'hBB, 8'h66, 8'hFF,
							"All pressed: B4 violet");
			#10;

			check_color(600, 100, 8'b11111111, 8'hFF, 8'h55, 8'hCC,
							"All pressed: C5 pink");
			#10;
			
			//false check to make sure test it self is working making sure that one key 
			//pressed doesn't bleed over or affect other keys
			check_color(120, 100, 8'b10000001, 8'hFF, 8'hA0, 8'h30,
							"D4 pressed");
			
		
		$stop;
	end
endmodule

