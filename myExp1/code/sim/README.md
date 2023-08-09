To simulate, the ROM and RAM should be implemented like:

```verilog
	reg[31:0] data [0:X];
    initial	begin
        $readmemh("XXX", data);
    end
```

"XXX" is the initialization file with path. If written in relative form, the path is relative to the source file (like `ROM.v`) in Synthesis and to the `$(ProjectName).sim\sim_x\behav\xsim\.` in Simulation.