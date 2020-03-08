//This is just a comment
@i
M=1
@sum //this is also a comment
M=0
(LOOP)
    @i
    D=M
    @R0
    D=D-M
    @END
    D;JGT
    @R1
    D=M
    @sum
    M=D+M
    @i
    M=M+1
    @LOOP
    0;JMP
(END)
@sum
D=M
@R2
M=D
(PROGEND)
@PROGEND
0;JMP
