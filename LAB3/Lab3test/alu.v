
module alu(
	input                   rst_n,         // negative reset            (input)
	input signed [32-1:0]   src1,          // 32 bits source 1          (input)
	input signed [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output                  zero,          // 1 bit when the output is 0, zero must be set (output)
	output                  cout,          // 1 bit carry out           (output)
	output                  overflow       // 1 bit overflow            (output)
	);

/* Write your code HERE */
wire [32-1:0] c_out, result0;
wire set;
reg [2-1:0] operation;
reg Ainv, Binv, cin;

assign zero = (result == 0) ? 1 : 0;
assign cout = (ALU_control == 4'b0010 || ALU_control == 4'b0110) ? c_out[31] : 0;
assign overflow = (c_out[30] != c_out[31]);
assign set = c_out[30] ^ src1[31] ^ !src2[31];

always @(*) begin
	case(ALU_control)
		4'b0000: begin // AND
			operation = 2'b00;
			Ainv = 0;
			Binv = 0;
			cin = 1'b0;
			result = result0;
		end
		4'b0001: begin // OR
			operation = 2'b01;
			Ainv = 0;
			Binv = 0;
			cin = 1'b0;
			result = result0;
		end
		4'b0010: begin // add
			operation = 2'b10;
			Ainv = 0;
			Binv = 0;
			cin = 1'b0;
			result = result0;
		end
		4'b0110: begin // sub
			operation = 2'b10;
			Ainv = 0;
			Binv = 1;
			cin = 1'b1;
			result = result0;
		end
		4'b0111: begin // slt
			operation = 2'b11;
			Ainv = 0;
			Binv = 1;
			cin = 1'b1;
			result = result0;
		end
		4'b1100: begin // NOR
			operation = 2'b00;
			Ainv = 1;
			Binv = 1;
			cin = 1'b0;
			result = result0;
		end
		4'b1101: begin // NAND
			operation = 2'b01;
			Ainv = 1;
			Binv = 1;
			cin = 1'b0;
			result = result0;
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
			operation = 2'b00;
			Ainv = 1'b0;
			Binv = 1'b0;
			cin = 1'b0;
			result = 0;
		end
	endcase
end

generate;
	genvar i;
	alu_1bit u1(.src1(src1[0]), .src2(src2[0]), .less(set), .Ainvert(Ainv), .Binvert(Binv),
				.cin(cin), .operation(operation), .result(result0[0]), .cout(c_out[0]));
	for(i = 1; i < 32; i=i+1)
	begin : res
		alu_1bit u1(.src1(src1[i]), .src2(src2[i]), .less(1'b0), .Ainvert(Ainv), .Binvert(Binv), 
				.cin(c_out[i-1]), .operation(operation), .result(result0[i]), .cout(c_out[i]));
	end
endgenerate


endmodule
