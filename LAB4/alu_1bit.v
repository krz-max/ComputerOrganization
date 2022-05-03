`timescale 1ns/1ps

module alu_1bit(
	input				src1,       //1 bit source 1  (input)
	input				src2,       //1 bit source 2  (input)
	input				less,       //1 bit less      (input)
	input 				Ainvert,    //1 bit A_invert  (input)
	input				Binvert,    //1 bit B_invert  (input)
	input 				cin,        //1 bit carry in  (input)
	input 	    [2-1:0] operation,  //2 bit operation (input)
	output              result,     //1 bit result    (output)
	output              cout        //1 bit carry out (output)
	);

/* Write your code HERE */
wire a, b;
MUX2to1 m1(.src1(src1), .src2(~src1), .select(Ainvert), .result(a));
MUX2to1 m2(.src1(src2), .src2(~src2), .select(Binvert), .result(b));

MUX4to1 m3(.src1(a&b), .src2(a|b), .src3(a^b^cin), .src4(less), .select(operation), .result(result));

assign cout = (operation == 2'b10 || operation == 2'b11) ? a&b | a&cin | b&cin : 0;
// wire Add_or_Sub = operation != 2'b10 || operation != 2'b11;
// MUX2to1 m4(.src1(Carry), .src2(1'b0), .select(Add_or_Sub), .result(cout));
endmodule
