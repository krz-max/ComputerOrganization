`timescale 1ns/1ps
module ForwardingUnit (
    input [5-1:0] IDEXE_RS1,
    input [5-1:0] IDEXE_RS2,
    input [5-1:0] EXEMEM_RD,
    input [5-1:0] MEMWB_RD,
    input EXEMEM_RegWrite,
    input MEMWB_RegWrite,
    output reg [2-1:0] ForwardA,
    output reg [2-1:0] ForwardB
);
// might be wrong
/* Write your code HERE */
always @* begin
    if(EXEMEM_RegWrite==1'b1 & IDEXE_RS1==EXEMEM_RD)begin
        ForwardA = 2'b10;
    end else if(MEMWB_RegWrite==1'b1 & EXEMEM_RegWrite==1'b0 & IDEXE_RS1==EXEMEM_RD)begin
        ForwardA = 2'b01
    end else begin 
        ForwardA = 2'b00;
    end
    
    if(EXEMEM_RegWrite==1'b1 & IDEXE_RS2==EXEMEM_RD)begin
        ForwardB =  2'b10;
    end else if(MEMWB_RegWrite==1'b1 & EXEMEM_RegWrite==1'b0 & IDEXE_RS2==EXEMEM_RD) begin
        ForwardB = 2'b01
    end else  begin
        ForwardB = 2'b00;
    end
end
endmodule
