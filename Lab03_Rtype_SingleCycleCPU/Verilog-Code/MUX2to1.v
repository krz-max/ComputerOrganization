module MUX2to1(
	input      src1,
	input      src2,
	input	   select,
	output reg result
	);
/* Write your code HERE */

always @(*) begin
	case(select)
		0: result = src1;
		1: result = src2;
	endcase
end

endmodule
