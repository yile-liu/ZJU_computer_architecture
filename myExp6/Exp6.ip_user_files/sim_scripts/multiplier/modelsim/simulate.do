onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -L xbip_utils_v3_0_10 -L xbip_pipe_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_16 -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.multiplier

do {wave.do}

view wave
view structure
view signals

do {multiplier.udo}

run -all

quit -force
