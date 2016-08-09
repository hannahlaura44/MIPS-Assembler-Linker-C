# proj2-1-starter

In this part of the project, we will be writing an assembler that translates a subset of the MIPS instruction set to machine code. Our assembler is a two-pass assembler similar to the one described in lecture. However, we will only assemble the .text segment. At a high level, the functionality of our assembler can be divided as follows:

Pass 1: Reads the input (.s) file. Comments are stripped, pseudoinstructions are expanded, and the address of each label is recorded into the symbol table. Input validation of the labels and pseudoinstructions is performed here. The output is written to an intermediate (.int) file .

Pass 2: Reads the intermediate file and translates each instruction to machine code. Instruction syntax and arguments are validated at this step. The relocation table is generated, and the instructions, symbol table, and relocation table are written to an object (.out) file.

detailed specs here: http://www-inst.eecs.berkeley.edu/~cs61c/sp16/projs/02-1/


# proj2-2
In part 1 of this project, we wrote an assembler in C. Now, we will continue where we left off by implementing a linker in MIPS. The linker processes object files (which in our project are .out files) and generates an executable file. In the rest of this document, "input" will be used interchangeably with "object file", and "output" with "executable file".

The linker has two main tasks, combining code and relocating symbols. Code from each input file's .text segment is merged together to create an executable. This also determines the absolute address of each symbol (recall that the assembler outputs a symbol table containing the relative address of each symbol). Since the absolute address is known, instructions that rely on absolute addressing can have the addresses filled in.

The skeleton files contain many lines of code, and it can be easy to get lost in the details. Here is a overview of how the linker functions:

Create an empty (global) symbol table. This table will contain absolute addresses.
For each input file, create a separate relocation table. This table will contain relative addresses (why?).
Open each input file. For each input, iterate through line-by-line and look for .text, .symbol, and .relocation sections.
If the .text section is found, count the number of instructions in this section and determine the number of bytes the instructions will take.
If the .symbol section is found, read each symbol and store it into the symbol table. Convert the local addresses of each symbol to an absolute address (how do you do this?).
If the .relocation section is found, read each symbol and store it into the input file's relocation table.
Open the output file.
For each input file, find the .text section and read one instruction at a time. Check whether the instruction requires relocation. If it does, use the symbol table and the relocation table for this input file to relocate. Then, write it into the next line of the output file. If the instruction does not require relocation, write it into the output file directly.
For the sake of simplicity, we will skip many of the error checking steps that a linker would normally perform. The checks that you do need to perform are stated in the instructions.