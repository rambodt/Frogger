module Victory(
    input  logic clk,
    input  logic reset,
    input  logic frogReachedTop,
    output logic midReset,
    output logic [6:0] scoreDisplay
);

    typedef enum logic { IDLE, INCREMENT_SCORE } state_t;
    state_t ps, ns;

    logic [3:0] score;
    logic scoreLatch;  // Latch to prevent multiple increments

    seg7 scoreDecoder (.bcd(score), .inverse(scoreDisplay));

    always_comb begin
        ns = (ps == IDLE && frogReachedTop && !scoreLatch) ? INCREMENT_SCORE : IDLE;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            ps <= IDLE;
            score <= 4'd0;
            scoreLatch <= 1'b0;
        end else begin
            ps <= ns;

            if (ps == IDLE && ns == INCREMENT_SCORE) begin
                if (score < 4'd9) // Prevent score from exceeding 9
                    score <= score + 1;
                scoreLatch <= 1'b1;
            end 

            if (!frogReachedTop) begin
                scoreLatch <= 1'b0;
            end
        end
    end

    assign midReset = (ps == INCREMENT_SCORE); // midReset is high only in INCREMENT_SCORE

endmodule


module Victory_testbench();
  logic clk;
  logic reset;
  logic frogReachedTop;
  logic [6:0] scoreDisplay;
  logic midReset;
   
  Victory dut(.clk(clk), .reset(reset), .frogReachedTop(frogReachedTop), .midReset(midReset), .scoreDisplay(scoreDisplay));
  parameter CLOCK_PERIOD = 20;
  
  initial begin 
     clk = 0; 
     forever #(CLOCK_PERIOD/2) clk = ~clk; 
  end
  
  initial begin
    
    @(posedge clk);
    reset = 1; 
    repeat(5) @(posedge clk);
    reset = 0;
    repeat(5) @(posedge clk);
    frogReachedTop = 0;
    repeat(8) @(posedge clk);

    frogReachedTop = 1;
    @(posedge clk);

    frogReachedTop = 0;
    repeat(5) @(posedge clk);
    
    reset = 1;
    repeat(5) @(posedge clk);
    reset = 0;
    repeat(5) @(posedge clk);
    
    $stop;
  end
endmodule
