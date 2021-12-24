module BranchCond (
    input   [2:0]   branch,
    input           zero,
    input           less,
    output          PCAsrc,
    output          PCBsrc  
);

assign PCAsrc = (~branch[2] & branch[0]) | 
                (~branch[1] & branch[0] & ~zero) | 
                (~branch[2] & branch[1]) | 
                (branch[1] & ~branch[0] & less) | 
                (branch[2] & ~branch[1] & ~branch[0] & zero) | 
                (branch[1] & branch[0] & ~less);

assign PCBsrc = (~branch[2] & branch[1] & ~branch[0]);

endmodule