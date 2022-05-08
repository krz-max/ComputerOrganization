`timescale 1ns/1ps

module alu(
	input                   rst_n,         // negative reset            (input)
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output       [32-1:0]	result,        // 32 bits result            (output)
	output                  zero,          // 1 bit when the output is 0, zero must be set (output)
	output                  cout,          // 1 bit carry out           (output)
	output                  overflow       // 1 bit overflow            (output)
	);

/* Write your code HERE */
// subtraction or Set less than
wire [32-1:0] c_out;
reg [2-1:0] operation;
reg Ainv, Binv, cin;

assign zero = (result == 0) ? 1 : 0;
assign cout = (operation == 2'b10) ? c_out[31] : 0;
assign overflow = (c_out[30] != c_out[31]);

assign set = c_out[30] ^ src1[31] ^ !src2[31];

always @(*) begin
	case(ALU_control)
		0: begin
			operation = 2'b00;
			Ainv = 0;
			Binv = 0;
			cin = 1'b0;
		end
		1: begin
			operation = 2'b01;
			Ainv = 0;
			Binv = 0;
			cin = 1'b0;
		end
		2: begin
			operation = 2'b10;
			Ainv = 0;
			Binv = 0;
			cin = 1'b0;
		end
		6: begin
			operation = 2'b10;
			Ainv = 0;
			Binv = 1;
			cin = 1'b1;
		end
		7: begin
			operation = 2'b11;
			Ainv = 0;
			Binv = 1;
			cin = 1'b1;
		end
		12: begin
			operation = 2'b00;
			Ainv = 1;
			Binv = 1;
			cin = 1'b0;
		end
		13: begin
			operation = 2'b01;
			Ainv = 1;
			Binv = 1;
			cin = 1'b0;
		end
		default: begin
			operation = 2'b00;
			Ainv = 1'b0;
			Binv = 1'b0;
			cin = 1'b0;
		end
	endcase
end

generate;
	genvar i;
	alu_1bit u1(.src1(src1[0]), .src2(src2[0]), .less(set), .Ainvert(Ainv), .Binvert(Binv),
				.cin(cin), .operation(operation), .result(result[0]), .cout(c_out[0]));
	for(i = 1; i < 32; i=i+1)
	begin : res
		alu_1bit u1(.src1(src1[i]), .src2(src2[i]), .less(1'b0), .Ainvert(Ainv), .Binvert(Binv), 
				.cin(c_out[i-1]), .operation(operation), .result(result[i]), .cout(c_out[i]));
	end
endgenerate

endmodule