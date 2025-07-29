module Frogger(
input logic [2:0] speed,
    input  logic clk,
    input  logic reset,
    input  logic move_up, move_down, move_left, move_right,
    output logic [15:0][15:0] red_pixels,
    output logic [15:0][15:0] green_pixels,
    output logic [6:0] HEX0, HEX5
);
    
    // Car lanes
    logic [15:0] traffic_lanes [15:0];
    
    Car car_generator (
	 .speed(speed),
        .clk(clk), .reset(reset),
        .lane_1(traffic_lanes[1]),  .lane_2(traffic_lanes[2]),  .lane_3(traffic_lanes[3]),  .lane_4(traffic_lanes[4]),
        .lane_5(traffic_lanes[5]),  .lane_6(traffic_lanes[6]),  .lane_7(traffic_lanes[7]), .lane_9(traffic_lanes[9]),
        .lane_10(traffic_lanes[10]), .lane_11(traffic_lanes[11]), .lane_12(traffic_lanes[12]),
        .lane_13(traffic_lanes[13]), .lane_14(traffic_lanes[14]), .lane_15(traffic_lanes[15])
    );
    
    logic mid_reset, frog_at_top, frog_loss;
    Victory victory_counter (.clk(clk), .reset(reset),.frogReachedTop(frog_at_top), .midReset(mid_reset), .scoreDisplay(HEX0));
	 
    LifeCounter life_counter (.clk(clk), .reset(reset), .loss(frog_loss), .lives(lives),  .scoreSeg(HEX5));
    
    logic [3:0] frog_row, frog_col;
	 
    always_ff @(posedge clk) begin
	  frog_loss <= 0;
        if (reset || mid_reset) begin
            frog_row <= 4'd15; // Start from the bottom
            frog_col <= 4'd7;
			frog_loss <= 0;
        end else begin
            // Movement logic
            if (move_up    && frog_row > 4'd0)  frog_row <= frog_row - 4'd1;
            if (move_down  && frog_row < 4'd15) frog_row <= frog_row + 4'd1;
            if (move_left  && frog_col > 4'd0)  frog_col <= frog_col - 4'd1;
            if (move_right && frog_col < 4'd15) frog_col <= frog_col + 4'd1;
            
            // Collision Check 
            for (int i = 1; i <= 7; i++)
                if (frog_row == i && traffic_lanes[i][frog_col]) begin
                    frog_row <= 4'd15;
                    frog_col <= 4'd7;
					  frog_loss <= 1;
                end
			 
            for (int i = 9; i <= 15; i++)
                if (frog_row == i && traffic_lanes[i][frog_col]) begin
                    frog_row <= 4'd15;
                    frog_col <= 4'd7;
					  frog_loss <= 1;
                end
        end
    end
	 
    assign frog_at_top = (frog_row == 4'd0);
    
    always_comb begin
        red_pixels = '0;
        green_pixels = '0;
        
        for (int i = 1; i <= 7; i++)
            red_pixels[i] = traffic_lanes[i];
        for (int i = 9; i <= 15; i++)
            red_pixels[i] = traffic_lanes[i];
        
        green_pixels[frog_row][frog_col] = 1'b1;
    end
	 
endmodule


module Frogger_testbench();
	   logic CLOCK_50;
      logic reset;
      logic move_up;
      logic move_down;
      logic move_left;
      logic move_right;

     logic [15:0][15:0] red_pixels;
     logic [15:0][15:0] green_pixels;
	  logic [6:0] HEX0, HEX5;
	  
	  
	  Frogger dut(.clk(CLOCK_50), .reset(reset), .move_up(move_up), .move_down(move_down), .move_left(move_left), .move_right(move_right), .red_pixels(red_pixels), .green_pixels(green_pixels), .HEX0(HEX0), .HEX5(HEX5));
	  
  parameter CLOCK_PERIOD = 20;
	initial begin 
		 CLOCK_50 = 0; 
		 forever #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50; 
	end
	
	
	initial begin
    
    @(posedge CLOCK_50);
    reset = 1; 
    repeat(5) @(posedge CLOCK_50);
    reset = 0;
    @(posedge CLOCK_50);
    move_up = 0; move_down = 0; move_left = 0; move_right = 0;
    repeat(5) @(posedge CLOCK_50);

    move_up = 0; move_down =0 ; move_left = 1; move_right = 0;
    @(posedge CLOCK_50);
	 move_up = 0; move_down =0 ; move_left = 2; move_right = 0;
    @(posedge CLOCK_50);
	 move_up = 0; move_down = 0; move_left = 1; move_right = 0;
    @(posedge CLOCK_50);
	 move_up = 0; move_down = 0; move_left = 0; move_right = 4;
    @(posedge CLOCK_50);
	 move_up = 0; move_down = 0; move_left = 0; move_right = 1;
    @(posedge CLOCK_50);
	 move_up = 0; move_down = 0; move_left = 0; move_right = 1;
    @(posedge CLOCK_50);
	 repeat(5) @(posedge CLOCK_50);
	 move_up = 0; move_down = 0; move_left = 1; move_right = 1;
  repeat(5) @(posedge CLOCK_50);
	 move_up = 2; move_down = 0; move_left = 0; move_right = 0;
	 repeat(5) @(posedge CLOCK_50);
	 move_up = 0; move_down = 1; move_left = 0; move_right = 0;
	 repeat(5) @(posedge CLOCK_50);
	 move_up = 1; move_down = 1; move_left = 0; move_right = 0;
	 
	 
	 repeat(5) @(posedge CLOCK_50);

    
    reset = 1;
    repeat(5) @(posedge CLOCK_50);
    reset = 0;
    repeat(5) @(posedge CLOCK_50);
    
    $stop;
  end
endmodule


