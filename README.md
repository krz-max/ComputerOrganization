# ComputerOrganization

## Lab01: RISC-V Programming
1. Goal
  Understand the difference between assembly and high-level languages. To test the correctness of the program, we use RISC-V simulator - Ripes
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
  [Ripes Introduction](https://github.com/mortbopet/Ripes/wiki/)
  [Ripes Download](https://github.com/mortbopet/Ripes/releases/tag/v.1.0.4)


## Lab02: 32-bit ALU
1. Goal
  Implement a 32-bit ALU using Verilog.
2. Attached Files
   - **alu_1bit.v**
   - **alu.v**
   - **MUX2to1.v**
   - **MUX4to1.v**
   - testbench.v
   - alu_1bit_tb.v
3. Lab Description
  Implement the bolded program.
  Basic instruction set:
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
  [How to use generate for in Verilog]()
/**************************** Template ******************************/
## Labxx: 
1. Goal
2. Attached Files
3. Lab Description
4. Reference Link
/**************************** Template ******************************/
