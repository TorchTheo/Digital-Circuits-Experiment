module MUX2 (
    input   [31:0]  a,
    input   [31:0]  b,
    input           control,
    output  [31:0]  out
);

assign out = (control == 0) ? a : b;

endmodule //MUX2