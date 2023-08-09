.global __start
__start:
addi x0, x0, 0
lw x2, 4(x0)


# 08
lw x4, 8(x0)


# 0C
add x1, x2, x4


# 10
addi x3, x1, -1


# 14
lw x5, 12(x0)


# 18
lw x6, 16(x0)


# 1C
lw x7, 20(x0)


# 20
sub x8,x4,x2


# 24
addi x9,x10,-3


# 28
beq  x4,x5,label0


# 2C
beq  x4,x4,label0


# 30
addi x20,x0,48


# 34
addi x20,x0,52


# 38
addi x20,x0,56


# 3C
addi x20,x0,60

# 40
label0:
lui  x10,4


# 44
jal  x11,20


# 48
addi x20,x0,72


# 4C
addi x20,x0,76


# 50
addi x20,x0,80


# 54
addi x20,x0,84


# 58
auipc x12, 0xffff0


# 5C
div x13, x7, x2


# 60
mul x14, x4, x5


# 64
mul x15, x13, x2


# 68
addi x16, x0, 4


# 6C
jalr x17,0(x0)