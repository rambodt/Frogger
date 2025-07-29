module user_input (
    input logic clk, reset, button,
    output logic out
);
    logic buttonc, buttonp;
    always_ff @(posedge clk) begin
        if (reset) 
		  {buttonp, buttonc} <= 2'b00;
        else 
		  {buttonp, buttonc} <= {buttonc, button};
    end
    assign out = buttonc & ~buttonp;
endmodule

module user_input_testbench();
    logic CLOCK_50, reset, button, out;
   parameter CLOCK_PERIOD = 20;
	initial begin 
		 CLOCK_50 = 0; 
		 forever #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50; 
	end 
	
	user_input dut(.out, .clk(CLOCK_50), .reset, .button);
	
	
	initial begin
	 reset<=1;
	 button<=0;
	 repeat(3) @(posedge CLOCK_50); 
	 reset<=0;
	 button<=1;
	 repeat(4) @(posedge CLOCK_50); 
	 button<=0;
	 repeat(4) @(posedge CLOCK_50); 
	 button<=1;
	 repeat(4)@(posedge CLOCK_50); 
	 button<=1;
	 @(posedge CLOCK_50); 
	 reset<=1;
	 @(posedge CLOCK_50);
	 $stop;
	 end
endmodule