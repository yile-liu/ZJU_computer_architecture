.global __start
__start:
addi x0, x0, 0
lw x2, 4(x0)


# 08
lw x4, 8(x0)


# 0C
add x1, x2, x4


# 10
addi x1, x1, -1


# 14
lw x5, 12(x0)


# 18
lw x6, 16(x0)


# 1C
lw x7, 20(x0)


# 20
sub x1,x4,x2


# 24
addi x1,x10,-3


# 28
beq  x4,x5,label0


# 2C
beq  x4,x4,label0


# 30
addi x0,x0,0


# 34
addi x0,x0,0


# 38
addi x0,x0,0

# 3C
addi x0,x0,0

# 40
label0:
lui  x1,4


# 44
jal  x1,12


# 48
addi x0,x0,0


# 4C
addi x0,x0,0


# 50
auipc x1, 0xffff0


# 54
div x8, x7, x2


# 58
mul x9, x4, x5


# 5C
mul x9, x8, x2


# 60
addi x2, x0, 4


# 64
jalr x1,0(x0)