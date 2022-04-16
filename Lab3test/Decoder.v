`timescale 1ns/1ps

module Decoder(
	input	[32-1:0] 	instr_i,
	output reg 			ALUSrc,
	output reg 			RegWrite,
	output reg 			Branch,
	output reg  [2-1:0]	ALUOp
	);
	
//Internal Signals
wire	[7-1:0]		opcode;
wire 	[3-1:0]		funct3;
wire	[3-1:0]		Instr_field;
wire	[9-1:0]		Ctrl_o;

/* Write your code HERE */
assign opcode = instr_i[6:0];
assign funct3 = instr_i[14:12];

always @(*) begin
	case(opcode)
		7'b0110011: begin //R-type
			ALUSrc = 0;
			RegWrite = 1;
			Branch = 0;
			ALUOp = 2'b10;
		end
		7'b0000011: begin //Load
			ALUSrc = 1;
			RegWrite = 1;
			Branch = 0;
			ALUOp = 2'b00;
		end
		7'b0100011: begin //Store
			ALUSrc = 1;
			RegWrite = 0;
			Branch = 0;
			ALUOp = 2'b00;
		end
		7'b1100011: begin //Branch
			ALUSrc = 0;
			RegWrite = 0;
			Branch = 1;
			ALUOp = 2'b01;
		end
	endcase
end

endmodule





                    
                    
