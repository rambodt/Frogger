module Car(
input logic [2:0] speed,
    input  logic clk,
    input  logic reset,
    output logic [15:0] lane_1, lane_2, lane_3, lane_4, lane_5,
    output logic [15:0] lane_6, lane_7, lane_9, lane_10, lane_11,
    output logic [15:0] lane_12, lane_13, lane_14, lane_15
);

    logic [15:0] traffic_lanes [15:1];  
    logic [15:0] slow_counter_primary;
    logic [15:0] PRIMARY_SHIFT_INTERVAL; 

    logic [15:0] slow_counter_secondary;
    logic [15:0] SECONDARY_SHIFT_INTERVAL;
	 
always_comb begin
    case (speed)
        3'b000: begin PRIMARY_SHIFT_INTERVAL = 16'd15000; SECONDARY_SHIFT_INTERVAL = 16'd12000; end
        3'b001: begin PRIMARY_SHIFT_INTERVAL = 16'd13000; SECONDARY_SHIFT_INTERVAL = 16'd10000; end
        3'b010: begin PRIMARY_SHIFT_INTERVAL = 16'd11000; SECONDARY_SHIFT_INTERVAL = 16'd8000; end
        3'b011: begin PRIMARY_SHIFT_INTERVAL = 16'd9000; SECONDARY_SHIFT_INTERVAL = 16'd6000; end
		  3'b100: begin PRIMARY_SHIFT_INTERVAL = 16'd7000; SECONDARY_SHIFT_INTERVAL = 16'd4000; end
		  3'b101: begin PRIMARY_SHIFT_INTERVAL = 16'd5000; SECONDARY_SHIFT_INTERVAL = 16'd2000; end
		  3'b110: begin PRIMARY_SHIFT_INTERVAL = 16'd3000; SECONDARY_SHIFT_INTERVAL = 16'd1000; end
        default: begin PRIMARY_SHIFT_INTERVAL = 16'd15000; SECONDARY_SHIFT_INTERVAL = 16'd12000; end 
    endcase
end


    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize lanes 
            traffic_lanes[1]  <= 16'b0000_0000_0000_1000;
            traffic_lanes[2]  <= 16'b0000_0000_1000_0000;
            traffic_lanes[3]  <= 16'b1000_0100_0000_0000;
            traffic_lanes[4]  <= 16'b0000_0000_0000_0000;
            traffic_lanes[5]  <= 16'b0000_1000_0000_0000;
            traffic_lanes[6]  <= 16'b0001_0000_0001_0001;
            traffic_lanes[7]  <= 16'b1000_0000_0000_0001;
            traffic_lanes[9]  <= 16'b0010_0000_0010_0000;
            traffic_lanes[10] <= 16'b0000_0110_0000_0000;
            traffic_lanes[11] <= 16'b0000_0000_0000_0001;
            traffic_lanes[12] <= 16'b1000_0000_0000_0001;
            traffic_lanes[13] <= 16'b1000_0000_0000_0001;
            traffic_lanes[14] <= 16'b1000_0000_0000_0001;
            traffic_lanes[15] <= 16'b0000_0000_0000_0000;
            slow_counter_primary <= 16'd0;
            slow_counter_secondary <= 16'd0;
        end 
        else begin
            slow_counter_primary <= slow_counter_primary + 1'b1;
            slow_counter_secondary <= slow_counter_secondary + 1'b1;
            
            if (slow_counter_primary >= PRIMARY_SHIFT_INTERVAL) begin
                slow_counter_primary <= 16'd0;
                
                traffic_lanes[1]  <= {traffic_lanes[1][14:0], traffic_lanes[1][15]};
                traffic_lanes[3]  <= {traffic_lanes[3][14:0], traffic_lanes[3][15]};
                traffic_lanes[5]  <= {traffic_lanes[5][14:0], traffic_lanes[5][15]};
                traffic_lanes[7]  <= {traffic_lanes[7][14:0], traffic_lanes[7][15]};
                traffic_lanes[9]  <= {traffic_lanes[9][14:0], traffic_lanes[9][15]};
                traffic_lanes[11] <= {traffic_lanes[11][14:0], traffic_lanes[11][15]};
                traffic_lanes[13] <= {traffic_lanes[13][14:0], traffic_lanes[13][15]};
                traffic_lanes[15] <= {traffic_lanes[15][14:0], traffic_lanes[15][15]};
            end

            if (slow_counter_secondary >= SECONDARY_SHIFT_INTERVAL) begin
                slow_counter_secondary <= 16'd0;
                
                traffic_lanes[2]  <= {traffic_lanes[2][0], traffic_lanes[2][15:1]};
                traffic_lanes[4]  <= {traffic_lanes[4][0], traffic_lanes[4][15:1]};
                traffic_lanes[6]  <= {traffic_lanes[6][0], traffic_lanes[6][15:1]};
                traffic_lanes[10] <= {traffic_lanes[10][0], traffic_lanes[10][15:1]};
                traffic_lanes[12] <= {traffic_lanes[12][0], traffic_lanes[12][15:1]};
                traffic_lanes[14] <= {traffic_lanes[14][0], traffic_lanes[14][15:1]};
            end
        end
    end

    // Assigning outputs
    assign lane_1  = traffic_lanes[1];
    assign lane_2  = traffic_lanes[2];
    assign lane_3  = traffic_lanes[3];
    assign lane_4  = traffic_lanes[4];
    assign lane_5  = traffic_lanes[5];
    assign lane_6  = traffic_lanes[6];
    assign lane_7  = traffic_lanes[7];
    assign lane_9  = traffic_lanes[9];
    assign lane_10 = traffic_lanes[10];
    assign lane_11 = traffic_lanes[11];
    assign lane_12 = traffic_lanes[12];
    assign lane_13 = traffic_lanes[13];
    assign lane_14 = traffic_lanes[14];
    assign lane_15 = traffic_lanes[15];

endmodule



module Car_testbench();
    logic [15:0] lane_1, lane_2, lane_3, lane_4, lane_5;
    logic [15:0] lane_6, lane_7, lane_10, lane_11, lane_12;
    logic [15:0] lane_13, lane_14, lane_15;
    logic clock_50MHz, reset;
    
    Car dut(
        .clk(clock_50MHz), 
        .reset(reset), 
        .lane_1(lane_1), .lane_2(lane_2), .lane_3(lane_3), .lane_4(lane_4), .lane_5(lane_5),
        .lane_6(lane_6), .lane_7(lane_7), .lane_10(lane_10), .lane_9(lane_9), .lane_11(lane_11), .lane_12(lane_12),
        .lane_13(lane_13), .lane_14(lane_14), .lane_15(lane_15)
    );
    
    parameter CLOCK_PERIOD = 20;
    initial begin 
        clock_50MHz = 0; 
        forever #(CLOCK_PERIOD/2) clock_50MHz = ~clock_50MHz; 
    end
    
    initial begin
        reset <= 1; 
        repeat(5) @(posedge clock_50MHz);
        reset <= 0; 
        repeat(100) @(posedge clock_50MHz);
        $stop;
    end
endmodule
