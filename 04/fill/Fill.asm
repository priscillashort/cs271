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

(INFINITELOOP)

@KBD
D=M
@UNFILL
D;JEQ

@KBD
D=M
@FILL
D;JGT

(FILL)

@8192
D=A
@FILLEND
D;JLE
@iterations
M=D
@SCREEN
D=A
@screenaddress
M=D

(FILLLOOP)
    @screenaddress
    A=M
    M=-1
    @screenaddress
    D=M
    @1
    D=D+A
    @screenaddress
    M=D
    @iterations
    MD=M-1
    @FILLLOOP
    D;JGT
(FILLEND)

@INFINITELOOP
0;JMP

(UNFILL)

@8192
D=A
@UNFILLEND
D;JLE
@iterations
M=D
@SCREEN
D=A
@screenaddress
M=D

(UNFILLLOOP)
    @screenaddress
    A=M
    M=1
    @screenaddress
    D=M
    @1
    D=D+A
    @screenaddress
    M=D
    @iterations
    MD=M-1
    @UNFILLLOOP
    D;JGT
(UNFILLEND)

@INFINITELOOP
0;JMP