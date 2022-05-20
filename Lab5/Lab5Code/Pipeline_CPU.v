`timescale 1ns/1ps
module Pipeline_CPU(
    clk_i,
    rst_i
);

//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
wire [32-1:0] PC_i;
wire [32-1:0] PC_o;
wire [32-1:0] MUXMemtoReg_o;
wire [32-1:0] ALUResult;
wire [32-1:0] MUXALUSrc_o;//not yet
wire [32-1:0] Decoder_o;//note yet
wire [32-1:0] RSdata_o;
wire [32-1:0] RTdata_o;
wire [32-1:0] Imm_Gen_o;
wire [32-1:0] ALUSrc1_o;
wire [32-1:0] ALUSrc2_o;
wire [8-1:0]  MUX_control_o; // WB(3, RegWrite+WB0+WB1)+M(2, MR+MW)+EX(3, (2)ALUOp+ALUSrcB)

wire [32-1:0] PC_Add_Immediate;

wire [2-1:0] ALUOp;
wire PC_write;
wire ALUSrc;
wire RegWrite;
wire Branch;
wire MUXControl; // generated by hazard detection unit
wire Jump;

wire [32-1:0] SL1_o;
wire [4-1:0] ALU_Ctrl_o;
wire ALU_zero;
wire Branch_zero;
wire MUXPCSrc;
wire [32-1:0] DM_o;//not yet
wire MemtoReg, MemRead, MemWrite;
wire [2-1:0] ForwardA;
wire [2-1:0] ForwardB;
wire [32-1:0] PC_Add4;


//Pipeline Register Signals
//IFID
wire [32-1:0] IFID_PC_o;
wire [32-1:0] IFID_Instr_o;
wire IFID_Write;
wire IFID_Flush;
wire [32-1:0] IFID_PC_Add4_o;

//IDEXE
wire [32-1:0] IDEXE_Instr_o;
wire [3-1:0] IDEXE_WB_o; // Writeback1 and Writeback0
wire [2-1:0] IDEXE_Mem_o; // Memread and Memwrite
wire [3-1:0] IDEXE_Exe_o; // For alu
wire [32-1:0] IDEXE_PC_o; // not used if branch is moved to ID
wire [32-1:0] IDEXE_RSdata_o;
wire [32-1:0] IDEXE_RTdata_o;
wire [32-1:0] IDEXE_ImmGen_o;
wire [4-1:0] IDEXE_Instr_30_14_12_o; // I[30] and func3
wire [5-1:0] IDEXE_Instr_11_7_o; // rd
wire [32-1:0] IDEXE_PC_add4_o;

//EXEMEM
wire [32-1:0] EXEMEM_Instr_o;
wire [3-1:0] EXEMEM_WB_o;
wire [2-1:0] EXEMEM_Mem_o;
wire [32-1:0] EXEMEM_PCsum_o;
wire EXEMEM_Zero_o;
wire [32-1:0] EXEMEM_ALUResult_o;
wire [32-1:0] EXEMEM_RTdata_o;
wire [5-1:0]  EXEMEM_Instr_11_7_o;
wire [32-1:0] EXEMEM_PC_Add4_o;

//MEMWB
wire [3-1:0] MEMWB_WB_o;
wire [32-1:0] MEMWB_DM_o;
wire [32-1:0] MEMWB_ALUresult_o;
wire [5-1:0]  MEMWB_Instr_11_7_o;
wire [32-1:0] MEMWB_PC_Add4_o;

//constant (added)
wire [32-1:0] Imm_4 = 4;
wire [32-1:0] IM_Instr_o;
wire Zero; // not used

// IF
wire [32-1:0] PCSrc_o;

// IF
// branch
MUX_2to1 MUX_PCSrc1( 
    .data0_i(PC_Add4),
    .data1_i(PC_Add_Immediate),
    .select_i(MUXPCSrc),
    .data_o(PCSrc_o)
);
// load/use hazard stall
MUX_2to1 MUX_PCSrc2(
    .data0_i(PC_o),
    .data1_i(PCSrc_o),
    .select_i(PC_write),
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
// IFID_register source
// flush : clear IF's PC
// PC_write : hold IF's PC
MUX_2to1 MUX_IFID_address(
    .data0_i(IFID_address_o), // hold value
    .data1_i(0), // update value
    .select_i(IFID_Write),
    .data_o(IFID_address_i) // input for IFID_register
);
MUX_2to1 MUX_IFID_instr(
    .data0_i(IFID_Instr_o), // hold value
    .data1_i(IM_Instr_o), // update value
    .select_i(IFID_Write),
    .data_o(IFID_Instr_i) // input for IFID_register
);
MUX_2to1 MUX_IFID_PC_Add4(
    .data0_i(IFID_PC_o), // hold value
    .data1_i(PC_Add4), // update value
    .select_i(IFID_Write),
    .data_o(IFID_PC_i) // input for IFID_register
);
IFID_register IFtoID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IFID_Flush), // branch hazard

    .address_i(IFID_address_i),// 0
    .instr_i(IFID_Instr_i),
    .pc_add4_i(IFID_PC_i),

    .address_o(IFID_address_o),//
    .instr_o(IFID_Instr_o),
    .pc_add4_o(IFID_PC_o)
);

// ID
Hazard_detection Hazard_detection_obj(
    .IFID_regRs(IFID_Instr_o[19:15]), // rs1
    .IFID_regRt(IFID_Instr_o[24:20]), // rs2
    .IDEXE_regRd(IDEXE_Instr_o[11:7]), // rd of load
    .IDEXE_memRead(), // check if it's load instruction

    .PC_write(PC_write),
    .IFID_write(IFID_Write),
    .control_output_select(MUXControl)
);

MUX_2to1 MUX_control(
    .data0_i(0),
    .data1_i({ID_WB1, ID_WB0, ID_MemRead, ID_MemWrite, ID_ALUOp, ID_ALUSrcB}),// ID_ALUSrcA ?
    .select_i(MUXControl),
    .data_o(MUX_control_o)
);

wire ID_RegWrite, ID_Branch, ID_Jump;
wire ID_WB1, ID_WB0, ID_MemRead, ID_MemWrite;
wire ID_ALUSrcA, ID_ALUSrcB;
wire [2-1:0] ID_ALUOp;
Decoder Decoder(
    .instr_i(IFID_Instr_o),
    .RegWrite(ID_RegWrite), // sent to MEM/WB
    .Branch(ID_Branch), // determined at ID stage
    .Jump(ID_Jump),
    .WriteBack1(ID_WB1),
    .WriteBack0(ID_WB0),
    .MemRead(ID_MemRead),
    .MemWrite(ID_MemWrite),
    .ALUSrc(ID_ALUSrcA), // not sure
    .ALUSrc(ID_ALUSrcB), // choose immd or rs2
    .ALUOp(ID_ALUOp), // 
);

ALU_Ctrl ALU_Ctrl(
    .instr({IFID_Instr_o[30], IFID_Instr_o[14:12]),
    .ALUOp(ID_ALUOp),
    .ALU_Ctrl_o(ALU_Ctrl_o)
);
Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(IFID_Instr_o[19:15]),
    .RTaddr_i(IFID_Instr_o[24:20]),
    .RDaddr_i(EXMEM_Rd_o[11:7]),
    .RDdata_i(MUXMemtoReg_o),
    .RegWrite_i(MEMWB_WB_o[2]),
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
wire [5-1:0] IDEXE_Rd;
IDEXE_register IDtoEXE(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .WB_i(MUX_control_o[7:5]),  // {RegWrite, WB1, WB0}
    .Mem_i(MUX_control_o[4:3]), // {ID_MEMRead, ID_MEMWrite}
    .Exe_i(MUX_control_o[2:0]), // {ALUOp, ALUSrcB}
    .data1_i(RSdata_o),
    .data2_i(RTdata_o),
    .immgen_i(Imm_Gen_o),
    .alu_ctrl_instr(ALU_Ctrl_o),
    .WBreg_i(IFID_Instr_o[11:7]), // rd
    .Rs1_i(IFID_Instr_o[19:15]), // rs1
    .Rs2_i(IFID_Instr_o[24:20]), // rs2
    // .pc_add4_i(), // originally for branch

    .instr_o(IDEXE_Instr_o),
    .WB_o(IDEXE_WB_o),
    .Mem_o(IDEXE_Mem_o),
    .Exe_o(IDEXE_Exe_o),
    .data1_o(IDEXE_RSdata_o),
    .data2_o(IDEXE_RTdata_o),
    .immgen_o(IDEXE_ImmGen_o),//
    .alu_ctrl_input(IDEXE_ALUCtrl_o),//
    .WBreg_o(IDEXE_Rd),
    .Rs1_o(IDEXE_Rs1_o),
    .Rs2_o(IDEXE_Rs2_o),
    // .pc_add4_o(IDEXE_PC_add4_o)
);

// EXE
wire [32-1:0] EXE_ALUSrc_o
MUX_2to1 MUX_ALUSrc(
    .data0_i(IDEXE_RTdata_o),
    .data1_i(IDEXE_ImmGen_o),
    .select_i(IDEXE_Exe_o[0]),//ALUSrcA (ALUSrcB?)
    .data_o(EXE_ALUSrc_o)
);

ForwardingUnit FWUnit(
    .IDEXE_RS1(IDEXE_Rs1_o), // should be address
    .IDEXE_RS2(IDEXE_Rs2_o),
    .EXEMEM_RD(EXEMEM_WB_o), // rd from EXEMEM
    .MEMWB_RD(MEMWB_WB_o),
    .EXEMEM_RegWrite(EXEMEM_RegWrite),
    .MEMWB_RegWrite(),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

MUX_3to1 MUX_ALU_src1(
    .data0_i(IDEXE_RSdata_o), // rs1
    .data1_i(MUXMemtoReg_o), // from WB stage
    .data2_i(EXEMEM_ALUResult_o),
    .select_i(ForwardA),
    .data_o(ALUSrc1_o)
);

MUX_3to1 MUX_ALU_src2(
    .data0_i(EXE_ALUSrc_o), // from rs2 or immd.
    .data1_i(MUXMemtoReg_o), // from WB stage
    .data2_i(EXEMEM_ALUresult_o), // from MEM stage
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



