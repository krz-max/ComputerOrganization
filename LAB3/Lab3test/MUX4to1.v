module MUX4to1(
	input			src1,
	input			src2,
	input			src3,
	input			src4,
	input   [2-1:0] select,
	output reg		result
	);
/* Write your code HERE */
	
always @(*) begin
	case(select)
		0: result = src1;
		1: result = src2;
		2: result = src3;
		3: result = src4;
	endcase
end
endmodule
