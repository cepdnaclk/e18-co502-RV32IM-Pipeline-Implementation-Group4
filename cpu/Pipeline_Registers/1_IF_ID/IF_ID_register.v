// Advanced Computer Architecture (CO502)
// Design: IF_ID Pipeline Register
// Group Number: 4
// E Numbers: E/18/077, E/18/397, E/18/402
// Names: Nipun Dharmarathne, Shamod Wijerathne, Chatura Wimalasiri  

`timescale  1ns/100ps

module IF_ID_register(
	CLK,
	RESET,
	INSTRUCTION_IN,
	PC_PLUS_4_IN,
	PC_DIRECT_IN,
	INSTRUCTION_OUT,
	PC_PLUS_4_OUT,
	PC_DIRECT_OUT,
	BUSYWAIT
);
	
	//port declaration
	input CLK, RESET, BUSYWAIT;
	input [31:0] INSTRUCTION_IN, PC_PLUS_4_IN, PC_DIRECT_IN;
	
	output reg [31:0] INSTRUCTION_OUT, PC_PLUS_4_OUT, PC_DIRECT_OUT;
	
	// reset the register
	always @ (*) begin
        if (RESET) begin
            #1;
            INSTRUCTION_OUT = 32'd0;
            PC_PLUS_4_OUT = 32'd0;
			PC_DIRECT_OUT = 32'd0;
        end
    end

	// input data tranmits to outputs at the positive edge of the clock
	// At this moment, reset must be low
	// Assignments to outputs happen simultaneously
	always @ (*) begin
        if (BUSYWAIT == 1'b0 ) begin
			#2
            INSTRUCTION_OUT <= INSTRUCTION_IN;
           PC_PLUS_4_OUT <= PC_PLUS_4_IN;
		 	PC_DIRECT_OUT <= PC_DIRECT_IN;
        end
    end


	 initial
    begin
        $dumpfile("cpu_wavedata.vcd");
        $dumpvars(1,INSTRUCTION_OUT);
		$dumpvars(1,PC_DIRECT_OUT);
		$dumpvars(1,PC_PLUS_4_OUT);
    end    


endmodule