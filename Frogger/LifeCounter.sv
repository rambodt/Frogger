module LifeCounter(
    input  logic clk,
    input  logic reset,
    input  logic loss,
    output logic [3:0] lives,
   output logic game_over,
	 output logic [6:0] scoreSeg
);

 seg7 win (.bcd(lives), .inverse(scoreSeg));

 
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            lives <= 4'd3; // Start with 3 lives
        end else if (loss && lives > 4'd0) begin
            lives <= lives - 1; // Decrease lives on loss
        end
    end

    assign game_over = (lives == 2'd0); // Game over when lives reach 0

endmodule



module LifeCounter_testbench(); 
	logic clk; 
	logic reset; 
	logic loss; 
	logic [3:0] lives; 
	logic game_over;
	logic [6:0] scoreSeg;
	logic CLOCK_50;

	LifeCounter dut ( 
		 .clk (clk), .reset, .loss, .lives, .game_over, .scoreSeg); 
	 
	parameter CLOCK_PERIOD = 20;
	initial begin 
		 CLOCK_50 = 0; 
		 forever #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50; 
		 loss = 0;
	end 
	
	  initial begin
        reset <= 1; loss <= 0; @(posedge CLOCK_50);
        repeat(10) @(posedge CLOCK_50);
		  reset <= 0; @(posedge CLOCK_50);
        repeat(10) @(posedge CLOCK_50);
		  loss<= 0;
		  @(posedge CLOCK_50);
		  loss<= 1;
		  @(posedge CLOCK_50);
		  loss<= 0;
		  @(posedge CLOCK_50);
		  loss<= 1;
		  @(posedge CLOCK_50);
  loss<= 0;		  @(posedge CLOCK_50);
		  loss<= 1;
		  @(posedge CLOCK_50);
  loss<= 0;		  @(posedge CLOCK_50);
		  loss<= 1;
		   @(posedge CLOCK_50);
  loss<= 0;		  @(posedge CLOCK_50);
		  loss<= 1;
		   @(posedge CLOCK_50);
  loss<= 0;		  @(posedge CLOCK_50);
		  loss<= 1;
		 
        
		  

		$stop;
    end
endmodule