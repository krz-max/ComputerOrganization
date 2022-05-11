`timescale 1ns/1ps

module Decoder(
    input   [7-1:0]        instr_i,
    output  reg            RegWrite,
    output  reg            Branch,
    output  reg            Jump,
    output  reg            WriteBack1,
    output  reg            WriteBack0,
    output  reg            MemRead,
    output  reg            MemWrite,
    output  reg            ALUSrcA,
    output  reg            ALUSrcB,
    output  reg[2-1:0]     ALUOp
);

/* Write your code HERE */
always @(*) begin
	casez(instr_i)
		7'b0110011: begin //R-type
            RegWrite = 1;
            Branch = 0;
            Jump = 0;
            WriteBack1 = 0;
            WriteBack0 = 0;
            MemRead = 0;
            MemWrite = 0;
            ALUSrcA = 1'bx;
            ALUSrcB = 0;
            ALUOp = 2'b10;
		end
        7'b0010011: begin //addi
            RegWrite = 1;
            Branch = 0;
            Jump = 0;
            WriteBack1 = 0;
            WriteBack0 = 0;
            MemRead = 0;
            MemWrite = 0;
            ALUSrcA = 1'bx;
            ALUSrcB = 1;
            ALUOp = 2'b00;
        end
		7'b0000011: begin //Load
            RegWrite = 1;
            Branch = 0;
            Jump = 0;
            WriteBack1 = 0;
            WriteBack0 = 1;
            MemRead = 1;
            MemWrite = 0;
            ALUSrcA = 1'bx;
            ALUSrcB = 1;
            ALUOp = 2'b00;
		end
		7'b0100011: begin //Store
            RegWrite = 0;
            Branch = 0;
            Jump = 0;
            WriteBack1 = 1'bx;
            WriteBack0 = 1'bx;
            MemRead = 0;
            MemWrite = 1;
            ALUSrcA = 1'bx;
            ALUSrcB = 1;
            ALUOp = 2'b00;
		end
		7'b1100011: begin //Branch
            RegWrite = 0;
            Branch = 1;
            Jump = 0;
            WriteBack1 = 1'bx;
            WriteBack0 = 1'bx;
            MemRead = 0;
            MemWrite = 0;
            ALUSrcA = 0;
            ALUSrcB = 0;
            ALUOp = 2'b01;
		end
        7'b1101111: begin //jal
            RegWrite = 1;
            Branch = 0;
            Jump = 1;
            WriteBack1 = 1;
            WriteBack0 = 1'bx;
            MemRead = 0;
            MemWrite = 0;
            ALUSrcA = 0;
            ALUSrcB = 1'bx;
            ALUOp = 2'bxx;
        end
        7'b1100111: begin //jalr
            RegWrite = 1;
            Branch = 0;
            Jump = 1;
            WriteBack1 = 1;
            WriteBack0 = 1'bx;
            MemRead = 0;
            MemWrite = 0;
            ALUSrcA = 1;
            ALUSrcB = 1'bx;
            ALUOp = 2'bxx;
        end
        default: begin
            RegWrite = 0;
            Branch = 0;
            Jump = 0;
            WriteBack1 = 1'bx;
            WriteBack0 = 1'bx;
            MemRead = 0;
            MemWrite = 0;
            ALUSrcA = 1'bx;
            ALUSrcB = 1'bx;
            ALUOp = 2'bxx;
        end
	endcase
end

endmodule
