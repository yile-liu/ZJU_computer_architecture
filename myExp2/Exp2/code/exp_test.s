.global __start
__start:
addi x0, x0, 0
lw x2, 4(x0)



lw x4, 8(x0)



lw x5, 12(x0)



lw x6, 16(x0)



lw x7, 20(x0)



csrrwi x1, 0x306, 16



csrr x1, 0x306



csrrw x1, 0x306, x6



csrr x1, 0x306



addi x0, x0, 0



addi x1, x0, 120



csrw 0x305, x1



addi x0, x0, 0



ecall



addi x0, x0, 0



addi x0, x0, 0 # change to illegal



addi x0, x0, 0



lw   x1, 127(x0)



lw   x1, 128(x0) # l access fault



addi x0, x0, 0



sw   x1, 128(x0) # s access fault



addi x0, x0, 0



addi x0, x0, 0



addi x0, x0, 0



addi x0, x0, 0



addi x0, x0, 0



addi x0, x0, 0



addi x0, x0, 0



jr x0


trap:
csrr x25, 0x341  # mepc



csrr x27, 0x342  # mcause



csrr x28, 0x300  # mstatus



csrr x29, 0x304  # mie



csrr x30, 0x344  # mip



addi x2, x25, 4



csrw 0x341, x2



# 30200073  mret
