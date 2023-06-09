
`timescale 1ns/100ps

module Jump_Controller (

    BRANCH_ADDR,
    JUMP_I,
    FUNC3,
    BRANCH,
    JUMP,
    EQ_FLAG,
    LT_FLAG,
    LTU_FLAG,
    BRANCH_OR_JUMP_ADDR,
    PC_MUX_CONTROL,
    REG_FLUSH
);

input [31:0] BRANCH_ADDR,JUMP_I;
input [2:0] FUNC3;
input BRANCH,JUMP,EQ_FLAG,LT_FLAG,LTU_FLAG;

output reg PC_MUX_CONTROL ;
output reg REG_FLUSH;
output reg [31:0] BRANCH_OR_JUMP_ADDR;

wire BEQ,BGE,BNE,BLT,BLTU,BGEU;

//CREATING SUITABLE CONTROLL SIGNALS FOR EACH INSTRUCTION
assign #1 BEQ = (~FUNC3[2]) & (~FUNC3[1]) &  (~FUNC3[0]) & EQ_FLAG;
assign #1 BGE = (FUNC3[2]) & (~FUNC3[1]) &  (FUNC3[0]) & (~LT_FLAG);
assign #1 BNE = (~FUNC3[2]) & (~FUNC3[1]) &  (FUNC3[0]) & (~EQ_FLAG);
assign #1 BLT = (FUNC3[2]) & (~FUNC3[1]) &  (~FUNC3[0]) & (~EQ_FLAG) & LT_FLAG;
assign #1 BLTU = (FUNC3[2]) & (FUNC3[1]) &  (~FUNC3[0]) & (~EQ_FLAG) & LTU_FLAG;
assign #1 BGEU = (FUNC3[2]) & (FUNC3[1]) &  (FUNC3[0]) & (~LTU_FLAG);

always @(*)begin
    if(((BRANCH &(BEQ|BGE|BNE|BLT|BLTU|BGEU)) | (JUMP)) ==  1'b1) begin
        PC_MUX_CONTROL = 1'b1;
        REG_FLUSH =  1'b1;
    end
    else begin
        PC_MUX_CONTROL = 1'b0;
        REG_FLUSH =  1'b0;
    end
    // PC_MUX_CONTROL=(BRANCH &(BEQ|BGE|BNE|BLT|BLTU|BGEU)) | (JUMP);
    // REG_FLUSH = PC_MUX_CONTROL;
end



always @(*) begin
    
    if (JUMP==1'b1) begin
        BRANCH_OR_JUMP_ADDR=JUMP_I;
    end
    else begin
                                          
        BRANCH_OR_JUMP_ADDR=BRANCH_ADDR;
    end
end

// always @(*) begin
//     REG_FLUSH = REG_FLUSH | RESET;
// end


    
endmodule