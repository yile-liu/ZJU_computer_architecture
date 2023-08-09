onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib divider_opt

do {wave.do}

view wave
view structure
view signals

do {divider.udo}

run -all

quit -force
