`timescale 1ns/1ps
module IFID_register (
    input clk_i,
    input rst_i,
    input flush,
    input [31:0] address_i,
    input [31:0] instr_i,
    input [31:0] pc_add4_i,
    output reg [31:0] address_o,
    output reg [31:0] instr_o,
    output reg [31:0] pc_add4_o
);
localparam NOP = 32'b0000_0000_0000_0000_0000_0000_0001_0011; // addi x0, x0, 0;

/* Write your code HERE */
always @(posedge clk_i) begin
    if(flush == 1'b1) begin // load/use stall or branch hazard flush
        instr_o <= NOP;
        address_o = 32'b0;
        pc_add4_o = 32'b0; 
    end 
    else begin
        instr_o <= instr_i;
        address_o <= address_i;
        pc_add4_o <= pc_add4_i;
    end
end
endmodule
