.global __start
__start:
addi x0, x0, 0
lw x2, 4(x0)



lw x4, 8(x0)



add x1, x2, x4



addi x1, x1, -1



lw x5, 12(x0)



lw x6, 16(x0)



lw x7, 20(x0)



sub x1,x4,x2



and x1,x4,x2



or  x1,x4,x2



xor x1,x4,x2



sll x1,x4,x2



slt x1,x4,x2



slt x1,x2,x4



srl x1, x6, x2



sra x1, x6, x2



sra x1, x7, x2



sltu x1, x6, x7



sltu x1, x7, x6



add x0,x0,x0



addi x1,x10,-3



andi x1,x4,15



ori  x1,x4,15



xori x1,x4,15



slti x1,x4,15



slli x1,x4,1



srli x1,x4,2



srai x1, x6, 12



sltiu x1, x6, -1



sltiu x1, x7, -1



beq  x4,x5,label0



beq  x4,x4,label0



addi x0,x0,0



addi x0,x0,0


label0:
bne  x4,x4,label1



bne  x4,x5,label1



addi x0,x0,0



addi x0,x0,0


label1:
blt  x5,x4,label2



blt  x4,x5,label2



addi x0,x0,0



addi x0,x0,0


label2:
bltu x6,x7,label3



bltu x7,x6,label3



addi x0,x0,0



addi x0,x0,0


label3:
bge x4,x5,label4



bge x5,x4,label4



addi x0,x0,0



addi x0,x0,0


label4:
bgeu x7,x6,label5



bgeu x6,x7,label5



addi x0,x0,0



addi x0,x0,0


label5:
bge  x4,x4,label6



addi x0,x0,0



addi x0,x0,0


label6:
lui  x1,4



jal  x1,12



addi x0,x0,0



addi x0,x0,0



lw   x8, 24(x0)



sw   x8, 28(x0)



lw   x1, 28(x0)



sh   x8, 32(x0)



lw   x1, 32(x0)



sb   x8, 36(x0)



lw   x1, 36(x0)



lh   x1, 26(x0)



lhu  x1, 26(x0)



lb   x1, 27(x0)



lbu  x1, 27(x0)



auipc x1, 0xffff0



jalr x1,0(x0)