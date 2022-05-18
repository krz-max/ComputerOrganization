`timescale 1ns/1ps
module Pipeline_CPU(
    clk_i,
    rst_i
);

//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
wire [31:0] PC_i;
wire [31:0] PC_o;
wire [31:0] MUXMemtoReg_o;
wire [31:0] ALUResult;
wire [31:0] MUXALUSrc_o;//not yet
wire [31:0] Decoder_o;//note yet
wire [31:0] RSdata_o;
wire [31:0] RTdata_o;
wire [31:0] Imm_Gen_o;
wire [31:0] ALUSrc1_o;
wire [31:0] ALUSrc2_o;
wire [7:0]  MUX_control_o; // WB(2, WB0+WB1)+M(2, MR+MW)+EX(4, ALUSrcA+ALUSrcB+ALUOp)

wire [31:0] PC_Add_Immediate;

wire [1:0] ALUOp;
wire PC_write;
wire ALUSrc;
wire RegWrite;
wire Branch;
wire MUXControl; // generated by hazard detection unit
wire Jump;

wire [31:0] SL1_o;
wire [3:0] ALU_Ctrl_o;
wire ALU_zero;
wire Branch_zero;
wire MUXPCSrc;
wire [31:0] DM_o;//not yet
wire MemtoReg, MemRead, MemWrite;
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [31:0] PC_Add4;


//Pipeline Register Signals
//IFID
wire [31:0] IFID_PC_o;
wire [31:0] IFID_Instr_o;
wire IFID_Write;
wire IFID_Flush;
wire [31:0]IFID_PC_Add4_o;

//IDEXE
wire [31:0] IDEXE_Instr_o;
wire [2:0] IDEXE_WB_o;
wire [1:0] IDEXE_Mem_o;
wire [2:0] IDEXE_Exe_o;
wire [31:0] IDEXE_PC_o;
wire [31:0] IDEXE_RSdata_o;
wire [31:0] IDEXE_RTdata_o;
wire [31:0] IDEXE_ImmGen_o;
wire [3:0] IDEXE_Instr_30_14_12_o;
wire [4:0] IDEXE_Instr_11_7_o;
wire [31:0]IDEXE_PC_add4_o;

//EXEMEM
wire [31:0] EXEMEM_Instr_o;
wire [2:0] EXEMEM_WB_o;
wire [1:0] EXEMEM_Mem_o;
wire [31:0] EXEMEM_PCsum_o;
wire EXEMEM_Zero_o;
wire [31:0] EXEMEM_ALUResult_o;
wire [31:0] EXEMEM_RTdata_o;
wire [4:0]  EXEMEM_Instr_11_7_o;
wire [31:0] EXEMEM_PC_Add4_o;

//MEMWB
wire [2:0] MEMWB_WB_o;
wire [31:0] MEMWB_DM_o;
wire [31:0] MEMWB_ALUresult_o;
wire [4:0]  MEMWB_Instr_11_7_o;
wire [31:0] MEMWB_PC_Add4_o;

//constant (added)
wire [32-1:0] Imm_4 = 4;
wire [31:0] IM_Instr_o;
wire Zero;


// IF
MUX_2to1 MUX_PCSrc( //115
    .data0_i(PC_Add4),
    .data1_i(PC_Add_Immediate),
    .select_i(MUXPCSrc),
    .data_o(PC_i)
);

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(PC_i),
    .pc_o(PC_o)
);

Adder PC_plus_4_Adder(
    .src1_i(PC_o),
    .src2_i(Imm_4),
    .sum_o(PC_Add4)
);

Instr_Memory IM(
    .addr_i(PC_o),
    .instr_o(IM_Instr_o)
);

IFID_register IFtoID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IFID_Flush), //branch hazard
    .address_i(),//
    .instr_i(IM_Instr_o),
    .pc_add4_i(PC_o),

    .address_o(),//
    .instr_o(IFID_Instr_o),
    .pc_add4_o(IFID_PC_Add4_o)
);

// ID
Hazard_detection Hazard_detection_obj(
    .IFID_regRs(IFID_Instr_o[19:15]),
    .IFID_regRt(IFID_Instr_o[24:20]),
    .IDEXE_regRd(IDEXE_Instr_o[11:7]),
    .IDEXE_memRead(),//

    .PC_write(PC_write),
    .IFID_write(IFID_Write),
    .control_output_select(MUXControl)
);

MUX_2to1 MUX_control(
    .data0_i(0),
    .data1_i({}),//
    .select_i(MUXControl),
    .data_o(MUX_control_o)
);

Decoder Decoder(
    .instr_i(IFID_Instr_o),
    .Branch(Branch), // determined at ID stage
    .ALUSrc(ALUSrc), // choose immd or rs2
    .RegWrite(RegWrite), // sent to MEM/WB
    .ALUOp(ALUOp), // 
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .Jump(Jump)
);

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(IFID_Instr_o[19:15]),
    .RTaddr_i(IFID_Instr_o[24:20]),
    .RDaddr_i(IFID_Instr_o[11:7]),
    .RDdata_i(MUXMemtoReg_o),
    .RegWrite_i(RegWrite),
    .RSdata_o(RSdata_o),
    .RTdata_o(RTdata_o)
);

Imm_Gen ImmGen(
    .instr_i(IFID_Instr_o),
    .Imm_Gen_o(Imm_Gen_o)
);

Shift_Left_1 SL1(
    .data_i(Imm_Gen_o),
    .data_o(SL1_o)
);

Adder Branch_Adder(
    .src1_i(SL1_o),
    .src2_i(IFID_PC_o),
    .sum_o(PC_Add_Immediate)
);

IDEXE_register IDtoEXE(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_i(IFID_Instr_o),
    .WB_i(IFID_Write),
    .Mem_i(),//
    .Exe_i(),//
    .data1_i(RSdata_o),
    .data2_i(RTdata_o),
    .immgen_i(Imm_Gen_o),
    .alu_ctrl_instr(ALU_Ctrl_o),
    .WBreg_i(),//
    .pc_add4_i(),//

    .instr_o(IDEXE_Instr_o),
    .WB_o(IDEXE_WB_o),
    .Mem_o(IDEXE_Mem_o),
    .Exe_o(IDEXE_Exe_o),
    .data1_o(IDEXE_RSdata_o),
    .data2_o(IDEXE_RTdata_o),
    .immgen_o(),//
    .alu_ctrl_input(),//
    .WBreg_o(),//
    .pc_add4_o(IDEXE_PC_add4_o)
);

// EXE
MUX_2to1 MUX_ALUSrc(
    .data0_i(),
    .data1_i(),
    .select_i(ALUSrc[1]),//ALUSrcA
    .data_o()
);

ForwardingUnit FWUnit(
    .IDEXE_RS1(IDEXE_RSdata_o),
    .IDEXE_RS2(IDEXE_RTdata_o),
    .EXEMEM_RD(),
    .MEMWB_RD(),
    .EXEMEM_RegWrite(),
    .MEMWB_RegWrite(),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

MUX_3to1 MUX_ALU_src1(
    .data0_i(IDEXE_RS1),
    .data1_i(),
    .data2_i(),
    .select_i(ForwardA),
    .data_o(ALUSrc1_o)
);

MUX_3to1 MUX_ALU_src2(
    .data0_i(IDEXE_RS2),
    .data1_i(),
    .data2_i(),
    .select_i(ForwardB),
    .data_o(ALUSrc2_o)
);

ALU_Ctrl ALU_Ctrl(
    .instr(IDEXE_Instr_30_14_12_o),
    .ALUOp(ALUOp),
    .ALU_Ctrl_o(ALU_Ctrl_o)
);

alu alu(
    .rst_n(rst_i),
    .src1(ALUSrc1_o),
    .src2(ALUSrc2_o),
    .ALU_control(ALU_Ctrl_o),
    .result(ALUResult),
    .Zero(Zero)
);

EXEMEM_register EXEtoMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_i(),//
    .WB_i(MEMWB_WB_o),
    .Mem_i(),
    .zero_i(),
    .alu_ans_i(ALUResult),
    .rtdata_i(),
    .WBreg_i(),
    .pc_add4_i(MEMWB_PC_Add4_o),

    .instr_o(EXEMEM_Instr_o),
    .WB_o(EXEMEM_WB_o),
    .Mem_o(EXEMEM_Mem_o),
    .zero_o(EXEMEM_Zero_o),
    .alu_ans_o(EXEMEM_ALUResult_o),
    .rtdata_o(),
    .WBreg_o(),
    .pc_add4_o(EXEMEM_PC_Add4_o)
);

// MEM
Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(MEMWB_ALUresult_o),
    .data_i(MEMWB_DM_o),
    .MemRead_i(),
    .MemWrite_i(),

    .data_o(MEMWB_RD)
);

MEMWB_register MEMtoWB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .WB_i(IDEXE_WB_o),
    .DM_i(),
    .alu_ans_i(ALUResult),
    .WBreg_i(),
    .pc_add4_i(IDEXE_PC_add4_o),

    .WB_o(MEMWB_WB_o),
    .DM_o(MEMWB_DM_o),
    .alu_ans_o(MEMWB_ALUresult_o),
    .WBreg_o(),
    .pc_add4_o(MEMWB_PC_Add4_o)
);

// WB
MUX_3to1 MUX_MemtoReg(
    .data0_i(),
    .data1_i(),
    .data2_i(),
    .select_i(),
    .data_o(MUXMemtoReg_o)
);

endmodule



