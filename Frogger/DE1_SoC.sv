module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, KEY, SW, GPIO_1); 
	input logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [35:0] GPIO_1;


    logic reset;
    assign reset = SW[9];
	

    assign HEX1 = 7'b111_1111;
    assign HEX2 = 7'b111_1111;
    assign HEX3 = 7'b111_1111;
    assign HEX4 = 7'b111_1111;
    //assign HEX5 = 7'b111_1111;

	  parameter whichClock = 10;  // 10 is good
    logic [31:0] div_clk;
    logic system_clk;

 clock_divider cdiv (
        .clock(CLOCK_50), 
        .reset(reset), 
        .divided_clocks(div_clk)
    ); 
	 
`ifdef ALTERA_RESERVED_QIS 
	assign system_clk = div_clk[whichClock]; // for board 
 `else 
	assign system_clk = CLOCK_50; // for simulation 
  `endif 

  
	 
	 logic [2:0] speed;
	 assign speed = SW[2:0];
	 logic up, down, left, right;

    user_input up_in (.clk(system_clk), .reset(reset), .button(~KEY[1]), .out(up));
    user_input down_in (.clk(system_clk), .reset(reset), .button(~KEY[2]), .out(down));
    user_input left_in (.clk(system_clk), .reset(reset), .button(~KEY[0]), .out(left));
    user_input right_in (.clk(system_clk), .reset(reset), .button(~KEY[3]), .out(right));


    logic [15:0][15:0] RedPixels, GrnPixels;

    Frogger game_inst (
	 .speed(speed),
        .clk         (system_clk),
        .reset       (reset),
        .move_up      (up),
        .move_down    (down),
        .move_left    (left),
        .move_right   (right),
        .red_pixels   (RedPixels),
        .green_pixels   (GrnPixels),
        .HEX0        (HEX0),
		  .HEX5        (HEX5)
    );



	 LEDDriver #(.FREQDIV(0)) driver_inst (
        .CLK         (system_clk),
        .RST         (reset),
        .EnableCount (1'b1),
        .RedPixels   (RedPixels),
        .GrnPixels   (GrnPixels),
        .GPIO_1      (GPIO_1)
    );
	

endmodule




module DE1_SoC_testbench(); 
	logic CLOCK_50; 
	logic [3:0] KEY; 
	logic [9:0] SW; 
	logic [9:0] LEDR; 
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [35:0] GPIO_1;

	DE1_SoC dut ( 
		 .CLOCK_50 (CLOCK_50), .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .KEY, .SW, .GPIO_1); 
	 
	parameter CLOCK_PERIOD = 20;
	initial begin 
		 CLOCK_50 = 0; 
		 forever #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50; 
	end 
	 
	  initial begin
        SW[9] = 1; @(posedge CLOCK_50);
        repeat(10) @(posedge CLOCK_50);
		  SW[9] = 0; @(posedge CLOCK_50);
        repeat(10) @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 1; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 1; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 1; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;@(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;@(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  
		  
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 1; KEY[2] = 0; KEY[3] = 0;
		   @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 1;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 1;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 1;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 1;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 1; KEY[3] = 0;
		  @(posedge CLOCK_50);
		  KEY[0] = 0; KEY[1] = 0; KEY[2] = 0; KEY[3] = 0;
		  repeat(10)@(posedge CLOCK_50);
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  SW[9] = 0; @(posedge CLOCK_50);
        repeat(10) @(posedge CLOCK_50);
        
		  

		$stop;
    end
endmodule























