onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib divider_opt

do {wave.do}

view wave
view structure
view signals

do {divider.udo}

run -all

quit -force
