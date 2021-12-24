module ContrGen (
    input   [6:0]   op,
    input   [2:0]   func3,
    input   [6:0]   func7,
    output  [2:0]   ExtOp,
    output          RegWr,
    output          ALUAsrc,
    output  [1:0]   ALUBsrc,
    output  [3:0]   ALUctr,
    output  [2:0]   Branch,
    output          MemtoReg,
    output          MemWr,
    output  [2:0]   MemOp
);

assign ExtOp =  ((~op[6] & ~op[5] & op[4] & ~op[3] & ~op[2]) | 
                 (op[6] & op[5] & ~op[4] & ~op[3] & op[2] & ~func3[2] & ~func3[1] & ~func3[0]) | 
                 (~op[6] & ~op[5] & ~op[4] & ~op[3] & ~op[2])) ? 3'b000 :
                (((~op[6] & op[5] & op[4] & ~op[3] & op[2]) | 
                  (~op[6] & ~op[5] & op[4] & ~op[3] & op[2])) ? 3'b001 :
                ((~op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]) ? 3'b010 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]) ? 3'b011 :
                ((op[6] & op[5] & ~op[4] & op[3] & op[2]) ? 3'b100 : 3'bxxx))));

assign RegWr =  ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]) | 
                (~op[6] & op[5] & ~op[4] & ~op[3] & ~op[2])) ? 0 : 1;

assign Branch = (op[6] & op[5] & ~op[4] & op[3] & op[2]) ? 3'b001 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & op[2]) ? 3'b010 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & ~func3[2] & ~func3[1] & ~func3[0]) ? 3'b100 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & ~func3[2] & ~func3[1] & func3[0]) ? 3'b101 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & func3[2] & ~func3[0]) ? 3'b110 :
                ((op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & func3[2] & func3[0]) ? 3'b111 : 3'b000)))));

assign MemtoReg = ~op[6] & ~op[5] & ~op[4] & ~op[3] & ~op[2];

assign MemWr = ~op[6] & op[5] & ~op[4] & ~op[3] & ~op[2];

assign MemOp = (~op[6] & ~op[4] & ~op[3] & ~op[2]) ? func3 : 3'b000;

assign ALUAsrc = (op[6] & op[5] & ~op[4] & op[2]) | (~op[6] & ~op[5] & op[4] & ~op[3] & op[2]);

assign ALUBsrc = ((~op[6] & op[5] & op[4] & ~op[3] & ~op[2]) | 
                 (op[6] & op[5] & ~op[4] & ~op[3] & ~op[2])) ? 2'b00 :
                 (((~op[6] & ~op[5] & op[4] & ~op[3]) |
                   (~op[6] & ~op[4] & ~op[3] & ~op[2]) | 
                   (~op[6] & op[5] & op[4] & ~op[3] & op[2])) ? 2'b01 :
                 ((op[6] & op[5] & ~op[4] & op[2]) ? 2'b10 : 2'bxx));

assign ALUctr[3] =  (~op[6] & ~op[5] & op[4] & ~op[3] & ~op[2] & ((~func3[2] & func3[1] & func3[0]) | (func3[2] & ~func3[1] & func3[0] & func7[5]))) |
                    (~op[6] & op[5] & op[4] & ~op[3] & ~op[2] & ((~func3[2] & func3[1] & func3[0]) | (func7[5] & ((~func3[2] & ~func3[1] & ~func3[0]) | (func3[2] & ~func3[1] & func3[0]))))) |
                    (op[6] & op[5] & ~op[4] & ~op[3] & ~op[2] & func3[2] & func3[1]);

assign ALUctr[2] =  ~op[6] & op[4] & ~op[3] & ~op[2] & func3[2];

assign ALUctr[1] =  (~op[6] & op[5] & op[4] & ~op[3] & op[2]) | 
                    (~op[6] & op[4] & ~op[3] & ~op[2] & func3[1]) |
                    (op[6] & op[5] & ~op[4] & ~op[3] & ~op[2]);

assign ALUctr[0] =  (~op[6] & op[5] & op[4] & ~op[3] & op[2]) | 
                    (~op[6] & ~op[5] & op[4] & ~op[3] & ~op[2] & 
                        ((func3[2] & func3[0]) | 
                        (~func3[2] & ~func3[1] & func3[0] & ~func7[5]))) |
                    (~op[6] & op[5] & op[4] & ~op[3] & ~op[2] & 
                        ((~func3[2] & ~func3[1] & func3[0] & ~func7[5]) | 
                        (func3[2] & func3[0])));

endmodule //ContrGen