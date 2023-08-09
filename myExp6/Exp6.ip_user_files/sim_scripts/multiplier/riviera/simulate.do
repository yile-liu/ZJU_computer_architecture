onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+multiplier -L xbip_utils_v3_0_10 -L xbip_pipe_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_16 -L xil_defaultlib -L secureip -O5 xil_defaultlib.multiplier

do {wave.do}

view wave
view structure

do {multiplier.udo}

run -all

endsim

quit -force
