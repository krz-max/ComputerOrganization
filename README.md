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
---
~~~
/**************************** Template ******************************/
## Labxx: 
1. Goal
   - 
2. Attached Files
   - 
3. Lab Description
   - 
4. Reference Link
   - 
/**************************** Template ******************************/
