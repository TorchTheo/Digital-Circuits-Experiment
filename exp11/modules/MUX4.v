module MUX4 (
    input   [31:0]  in_1,
    input   [31:0]  in_2,
    input   [31:0]  in_3,
    input   [31:0]  in_4,
    input   [1:0]   control,
    output  [31:0]  out
);

assign out = (control == 0 ? in_1 : (control == 1 ? in_2 : (control == 2 ? in_3 : in_4)));

endmodule //MUX4