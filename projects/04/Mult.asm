// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.

// For R1 times, Add R0 to R2

// Set the loop counter variable i
  @R1
  D=M
  @i
  M=D

// Set the R2 value to 0
  @R2
  M=0

// Start the loop
(LOOP)
// Exit early in case R1 is 0
  @R1
  D=M
  @END
  D; JEQ
// Add R0 to R2
  @R0
  D=M
  @R2
  M=D+M
// Break condition
  @i
  D=M
  D=D-1
  @END
  D; JEQ
// decrement i
  @i
  M=D
// Back to top of the loop
  @LOOP
  0;JMP


// End of the program
(END)
  @END
  0; JMP
