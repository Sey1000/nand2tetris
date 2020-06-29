// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// setup constant variables
  @8192 // # of words
  D=A
  @size
  M=D

// Start the loop
(KEYBOARD_LOOP)
// Listen to Keyboard
  @KBD
  D=M
  @TURN_WHITE
  D; JEQ
  @TURN_BLACK
  0; JMP
  @KEYBOARD_LOOP
  0; JMP

// Back to the top of the LOOP
//  @LOOP
//  0; JMP

(TURN_BLACK)
// select entire screen (32 words)
  // setup local variables
  @counter
  M=0
  @SCREEN
  D=A
  @pointer
  M=D

  // loop
  //   break if size - counter = 0
  //   select screen
  //   turn black
  //   counter += 1
  //   pointer += 1
(BLACK_LOOP)
  @counter
  D=M
  @size
  D=M-D
  @KEYBOARD_LOOP
  D; JEQ
  @pointer
  A=M
  M=-1
  @counter
  M=M+1
  @pointer
  M=M+1
  @BLACK_LOOP
  0; JMP

(TURN_WHITE)
// setup local variables
  @counter
  M=0
  @SCREEN
  D=A
  @pointer
  M=D
// Loop
(WHITE_LOOP)
  @counter
  D=M
  @size
  D=M-D
  @KEYBOARD_LOOP
  D; JEQ
  @pointer
  A=M
  M=0
  @counter
  M=M+1
  @pointer
  M=M+1
  @WHITE_LOOP
  0; JMP
