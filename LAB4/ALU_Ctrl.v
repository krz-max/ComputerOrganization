
`timescale 1ns/1ps
/*instr[30,14:12]*/
module ALU_Ctrl(
    input       [4-1:0] instr,
    input       [2-1:0] ALUOp,
    output reg  [4-1:0] ALU_Ctrl_o
);
wire [2:0] func3;
assign func3 = instr[2:0];
/* Write your code HERE */

wire [6-1:0] instr_ALUOp;
assign instr_ALUOp = {instr, ALUOp};

// 6'b????00 : I type, S type
// 6'b????01 : B type
// 6'b????10 : R type
always @(*) begin
	casez(instr_ALUOp)
		6'b????00: ALU_Ctrl_o = 4'b0010; // ld sd, add
		6'b????01: ALU_Ctrl_o = 4'b0110; // beq, sub
		6'b000010: ALU_Ctrl_o = 4'b0010; // add
		6'b100010: ALU_Ctrl_o = 4'b0110; // sub
		6'b011110: ALU_Ctrl_o = 4'b0000; // and
		6'b011010: ALU_Ctrl_o = 4'b0001; // or
		6'b001010: ALU_Ctrl_o = 4'b0111; // slt
		6'b110110: ALU_Ctrl_o = 4'b1000; // sra
		6'b000110: ALU_Ctrl_o = 4'b1001; // sll
		6'b010010: ALU_Ctrl_o = 4'b1010; // xor
		default: ALU_Ctrl_o = 4'b0000;
	endcase
end
endmodule

