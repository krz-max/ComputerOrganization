# ComputerOrganization

## Lab01: RISC-V Programming
1. Goal
   - Understand the difference between assembly and high-level languages. To test the correctness of the program, we use RISC-V simulator - Ripes
2. Attached Files
   - factorial.c
   - factorial.s (example assembly language)
   - bubble_sort.c
   - gcd.c
   - fibonacci.c
3. Lab Description
   - Generate the RISC-V assembly code of `bubble_sort.c`, `gcd.c`, and `fibonacci.c` and run them in RISC-V simulator.
   - Count the number of instructions of each program.
   - Count the maximum number of variable pushed into the stack.
4. Reference Link
   - [Ripes Introduction](https://github.com/mortbopet/Ripes/wiki/)
   - [Ripes Download](https://github.com/mortbopet/Ripes/releases/tag/v.1.0.4)
   - [https://web.eecs.utk.edu/~smarz1/courses/ece356/notes/assembly/](https://web.eecs.utk.edu/~smarz1/courses/ece356/notes/assembly/)
   - [https://hackmd.io/@xl86305955/CA_LAB1_R32I_Simulator](https://hackmd.io/@xl86305955/CA_LAB1_R32I_Simulator)
   - [https://stackoverflow.com/questions/59813759/how-to-use-an-array-in-risc-v-assembly](https://stackoverflow.com/questions/59813759/how-to-use-an-array-in-risc-v-assembly)
   - [http://csl.snu.ac.kr/courses/4190.307/2020-1/riscv-user-isa.pdf](http://csl.snu.ac.kr/courses/4190.307/2020-1/riscv-user-isa.pdf)
   - [https://stackoverflow.com/questions/60430331/different-ways-to-traverse-arrays-in-risc-v](https://stackoverflow.com/questions/60430331/different-ways-to-traverse-arrays-in-risc-v)
   - [https://stackoverflow.com/questions/60087133/venus-risc-v-how-to-loop-compare-and-print](https://stackoverflow.com/questions/60087133/venus-risc-v-how-to-loop-compare-and-print)
   - [https://hackmd.io/@xl86305955/CA_LAB1_R32I_Simulator](https://hackmd.io/@xl86305955/CA_LAB1_R32I_Simulator)
   - [https://passlab.github.io/CSE564/notes/lecture03_ISA_Intro.pdf](https://passlab.github.io/CSE564/notes/lecture03_ISA_Intro.pdf)

## Lab02: 32-bit ALU
1. Goal
   - Implement a 32-bit ALU using Verilog.
2. Attached Files
   - **alu_1bit.v**
   - **alu.v**
   - **MUX2to1.v**
   - **MUX4to1.v**
   - testbench.v
   - alu_1bit_tb.v
3. Lab Description
   - Implement the bolded program.
   - Basic instruction set:
     | ALU operation | Function      | ALU Control   |
     | ------------- |:-------------:|:-------------:|
     | and           | AND           | 0000          |
     | or            | OR            | 0001          |
     | add           | Addition      | 0010          |
     | sub           | Subtract      | 0110          |
     | slt           | Set less than | 0111          |
     | nor           | NOR           | 1100          |
     | nand          | NAND          | 1101          |
4. Reference Link
   - [How to use generate for in Verilog](https://www.chipverify.com/verilog/verilog-generate-block)
## Lab03: Simple Single Cycle CPU (R-type)
1. Goal
   - Understand datapath and control path of a single cycle CPU.
   - Implement a single cycle CPU using Verilog.
2. Attached Files
   - Adder.v
   - **alu.v**
   - **ALU_Ctrl.v**
   - **Decoder.v**
   - Instr_Memory.v
   - ProgramCounter.v
   - Reg_File.v
   - **Simple_Single_CPU.v**
   - testbench.v
3. Lab Description
   - Modify Lab2 alu.v to support `xor(^)`, `sll(<<)`, `sra(>>>)`.
   - Finish the `Decoder.v` and `ALU_Ctrl.v` files.
   - Connect all the wires in `Simple_Single_CPU.v`.
4. Reference Link
   - Check the slide for example block diagram and other details.

## Lab04: Single Cycle CPU
1. Goal
   - Learn how to set control signal in different instruction type.
   - Learn how sign-extend work.
2. Attached Files
   - Adder.v
   - **alu.v**
   - **ALU_Ctrl.v**
   - Data_Memory.v
   - **Decoder.v**
   - **Imm_Gen.v**
   - Instr_Memory.v
   - MUX_2to1.v
   - ProgramCounter.v
   - Reg_File.v
   - **Simple_Single_CPU.v**
   - testbench.v
3. Lab Description
   - Finish the `Decoder.v` and `ALU_Ctrl.v` files to support `beq`, `jal`, `jalr`, `addi` and R-type instructions.
   - Implement `Imm_Gen.v` in different instructions.
   - Connect all the wires in `Simple_Single_CPU.v`.
4. Reference Link
   - Check the slide for example block diagram and other details.

## Lab05: Pipeline CPU
1. Goal
   - Understand how the pipeline CPU works.
   - Know how to handle data hazard and load/use hazard.
2. Attached Files
   - **Adder.v**
   - **alu.v**
   - **ALU_Ctrl.v**
   - Data_Memory.v
   - **Decoder.v**
   - **ForwardingUnit.v**
   - **Hazard_detection.v**
   - **Imm_Gen.v**
   - Instr_Memory.v
   - MUX_2to1.v
   - MUX_3to1.v
   - ProgramCounter.v
   - Reg_File.v
   - **Shift_Left_1.v** (unused)
   - **Pipeline_CPU.v**
   - **EXEMEM_register.v**
   - **IDEXE_register.v**
   - **IFID_register.v**
   - **MEMWB_register.v**
   - testbench.v
3. Lab Description
   - Finish all bolded files.
   - Connect all the wires in `Pipeline_CPU.v`.
   - Some new instructions that are not present in Lab4 should also be handled. (slli and slti)
4. Reference Link
   - Check the slide for example block diagram and other details.

## Lab06: Cache Simulator
1. Goal
   - Understand cache performance of differecnt cache architectures(direct-mapped and set-associative)
2. Attached Files
   - **direct_mapped_cache.cpp**, **direct_mapped_cache.h**
   - **set_associative_cache.cpp**, **set_associative_cache.h**
   - main.cpp
3. Lab Description
   - Direct-mapped cache (unit:Byte)
 	 | Cache size\Block size | 16 | 32 | 64 | 128 | 256 |
     | --------------------- |:--:|:--:|:--:|:---:|:---:|
     | 4k           		 |    |    |    |     |     |
     | 16k 		             |    |    |    |     |     |
     | 64k        		     |    |    |    |     |     |
     | 256k  		         |    |    |    |     |     |
   - Set-associative cache
     - Block size 64B
     - Least Recently Used conflict handling
  	 
	 | Cache size\Associativity | 1 | 2 | 4 | 8 |
     | ------------------------ |:-:|:-:|:-:|:-:|
     | 1k           		    |   |   |   |   |
	 | 2k           		    |   |   |   |   |
	 | 4k           		    |   |   |   |   |
	 | 8k           		    |   |   |   |   |
	 | 16k           		    |   |   |   |   |
	 | 32k           		    |   |   |   |   |
4. Reference Link
   - Check the slide for example block diagram and other details.
