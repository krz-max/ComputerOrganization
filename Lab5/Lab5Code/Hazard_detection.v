`timescale 1ns/1ps
module Hazard_detection(
    input [4:0] IFID_regRs,
    input [4:0] IFID_regRt,
    input [4:0] IDEXE_regRd,
    input IDEXE_memRead,
    output reg PC_write,
    output reg IFID_write,
    output reg control_output_select
);
// load/use hazard detection
/* Write your code HERE */
always @* begin
    if(IDEXE_memRead==1'b1 && (IDEXE_regRd == IFID_regRs || IDEXE_regRd == IFID_regRt))begin
        PC_write = 1'b0;
        IFID_write = 1'b0;
        control_output_select = 1'b0; // MUXControl
    end else begin
        PC_write = 1'b1;
        IFID_write = 1'b1;
        control_output_select = 1'b1; // MUXControl
    end         
end
endmodule

