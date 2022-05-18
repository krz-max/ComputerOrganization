`timescale 1ns/1ps

module alu(
    input                   rst_n,         // negative reset            (input)
    input        [32-1:0]   src1,          // 32 bits source 1          (input)
    input        [32-1:0]   src2,          // 32 bits source 2          (input)
    input        [ 4-1:0]   ALU_control,   // 4 bits ALU control input  (input)
    output reg   [32-1:0]   result,        // 32 bits result            (output)
    output reg              zero           // 1 bit when the output is 0, zero must be set (output)
);

/* Write your code HERE */
assign Zero = (result == 0) ? 1 : 0;

always @(*) begin
	casez(ALU_control)
		4'b0000: begin // AND
			result = src1 & src2;
		end
		4'b0001: begin // OR
			result = src1 | src2;
		end
		4'b0010: begin // add
			result = src1 + src2;
		end
		4'b0110: begin // sub
			result = src1 - src2;
		end
		4'b0111: begin // slt
			result = (src1 < src2) ? 1 : 0;
		end
		4'b1100: begin // NOR
			result = src1 ~| src2;
		end
		4'b1101: begin // NAND
			result = src1 ~& src2;
		end
		4'b1000: begin // sra
			result = src1 >>> src2;
		end
		4'b1001: begin // sll
			result = src1 << src2;
		end
		4'b1010: begin // xor
			result = src1 ^ src2;
		end
		default: begin
			result = 0;
		end
	endcase
end
endmodule
