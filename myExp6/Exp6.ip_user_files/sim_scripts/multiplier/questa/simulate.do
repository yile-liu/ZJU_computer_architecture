onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib multiplier_opt

do {wave.do}

view wave
view structure
view signals

do {multiplier.udo}

run -all

quit -force
