// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Nov 11 13:48:38 2022
// Host        : E14-Windows running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim C:/Users/yilel/Desktop/Exp4/Exp4.runs/ROM_D_synth_1/ROM_D_sim_netlist.v
// Design      : ROM_D
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg676-2L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_D,dist_mem_gen_v8_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.2" *) 
(* NotValidForBitStream *)
module ROM_D
   (a,
    spo);
  input [9:0]a;
  output [31:0]spo;

  wire \<const0> ;
  wire [9:0]a;
  wire [31:0]\^spo ;
  wire [31:0]NLW_U0_dpo_UNCONNECTED;
  wire [31:0]NLW_U0_qdpo_UNCONNECTED;
  wire [31:0]NLW_U0_qspo_UNCONNECTED;
  wire [21:21]NLW_U0_spo_UNCONNECTED;

  assign spo[31:22] = \^spo [31:22];
  assign spo[21] = \<const0> ;
  assign spo[20:0] = \^spo [20:0];
  GND GND
       (.G(\<const0> ));
  (* C_FAMILY = "kintex7" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_DPO = "0" *) 
  (* C_HAS_DPRA = "0" *) 
  (* C_HAS_I_CE = "0" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_WE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_PIPELINE_STAGES = "0" *) 
  (* C_QCE_JOINED = "0" *) 
  (* C_QUALIFY_WE = "0" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "10" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "1024" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_clk = "0" *) 
  (* c_has_qspo = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_has_qspo_rst = "0" *) 
  (* c_has_qspo_srst = "0" *) 
  (* c_has_spo = "1" *) 
  (* c_mem_init_file = "ROM_D.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "32" *) 
  (* is_du_within_envelope = "true" *) 
  ROM_D_dist_mem_gen_v8_0_13 U0
       (.a(a),
        .clk(1'b0),
        .d({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dpo(NLW_U0_dpo_UNCONNECTED[31:0]),
        .dpra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[31:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[31:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(\^spo ),
        .we(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
M9ERyrMNmk2Jjyg6ZCGYQpTqx5C+74+ICn/vAQ5KoRuxJNbql8tHJjFcOe3FAJX14Nokq4wtfvZP
2sPXAs/eYYzjjbnt4nx8oZRRPy0XyDpvba/qxyqBSxjChIoPMDwpXnxi+chZJU5N1zCNt9FZPAep
nLCjMCkQTlKbP3cUJIY=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FBAg02qOh8M8uZkNvwWHoY3ELncwvHjjgL2y2qLN7xuxxaPQj3LdyD/IETTPdSjNCB/rhpJxbT1y
U5fbF28Hkp+bzDuxeTWPX251wMhiEmdm4jhyMl2z+GRf2Z6VJ4bVM5bieaJvsbjuyQ9Az6TDmueI
14citDEbyRCyJD9EiVckdS2mZcTl37oVFebKnIeJGmNjOc2XrcM84JVJIG5iv3ryS2hAG9/84hEr
u3DYC+xS2w5swJXVSf0zV+w8xZulS3PTPLELIM8O+SEFdHetZKnrgG1aJ7V5xu0RniGAsyVwVbgu
M1jPqNLyU+9kyETKfG9jcGEIM2I2gUfmOvRs+g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
TYvdYOtu2OcY/hp0LCFlgwGgJeLJ5MSBDPjuyI3760LiXtklDVs7CUFlvRRXMgAzbHlMXbiHp/Xl
cvmN035ayt8D8gPWRXxnbQf3kRlW6EIFwFMZ1inL9b5f47gsuvCP6MaKiTg0W7+/ZeHbM4jHXvRe
b8HXvQvK5kVwtayEwt0=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GkcGg32vdV7ZS9x4Uw9v3hZEcxD5hMmQXUqa6shDPbzqUGIxrKpTOb9W4Sgi8rq+qw7QpAZp2JW/
MkYAH1WikFlf+XWG57y55EFV7oRoKQDh2Yz0sZEwVhwTGwSAqfnjrmPITofdG5eiey1ySGprEKsT
mqWAV+ZN7TkQkKup0Ukf1O+8giYKT/7UibTRqG/CT9dgU/4atPgYh2QjNMVrsAH/uzDxh7stQMYe
nkjZBkpLWOq7mxEXTKVtYAD/8G5qCJELRcvCuUKYz4Une1wDj+L/vwRK3IAdWKQ+/5mvj0q5XEm7
IKu5HYvalbySwRWzaB00uobXZorNhfwSv45jHg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
JnT3Bfv/DUBx2mIm4+jpmHjzhKoX4mNpcc/lgscv3iYrJw8Uble396hMwPsVZ+kkAsmYtegNCiTG
Z7kqnoNeWHv+Grdizsq0QM9S2KJ5EoZhjelE+3Cii/ztNHf7Y3c0nBPnioUQ5YmWk7vgoQl3SJ3d
vwD3G0c+fGJBRpi14hTJOB2wtu4EeWcJ1f+01LjKINeucLlwacjnN0tElyRgCNKfsRDAQiMqwKqg
XCleeNY0cyLXGI30pXMpnbLizYlNKgVD6DSeNaby0dhW4phR0a+9xteo8l8eRVzTO+VSOcYSy8rU
6Uj2y0Up19vcq91C+/YeHlh24VwNI2TJeUEDwQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
AWr8D+IaT/X0jMJSrwmWnhWOjt0+8oyULINYaH7QGBLgqKCVtf8rqo68R3/TZ8gTkN73fZOx0QCU
3WEp7Ga1gUsqEgy+2zGlncYhOzx62FJm4Pm7S6LbE1qdg3/9Pp55JLaf1ouYlZccQJ+yawj0HgL4
zR0T347Zg2aIFxQZ28icCuJbxAZsZgAT30scXsTMMvXlQQ9NI21OjirKgHRn3dldIjpkL+BrVBkQ
Q7MMiTBhpCn/c+WXk4H9BPc3vMrVoh6r5oo+e1858Hk7osyxNI9zuACaGwdAatsW756kQBMsQoUj
TmJksSfucjrHVSuLFffpztOARH3LXrhZcCZdoQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fPVwMHnHe1L8weZTnbBxjlAabwZZnO4DZSHaO7tHGHAw6U+w+7Rc3BwfQXtiTyGXP15rvoLhvVpo
i1Tzs4zrV1X8vlWrxhS6XA2VO4RFkpCjmnHpvdgnW9mpk7w90QOEZIWZQST/o15t0wDT/kv4J36r
Ho59mVFCGQQSSYx0209u6sG2rNpJ5HtWMM+tDEDHUArucrBmPOoZSq0VSQsTHtjJQxr3U5fv9l6q
aEBWkjnLJ6zqLkt12B3q7V3iFORPpz6XNMqA6wzArzWirzgTCw3CduiSAgbNgoGmV4eNrVb2DfOT
5V4ni19GigMG1fHCD9dNPWGiRCWpY6iiN6iE1w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
NkQB16Pku9sdGFuAkY+DjFhWzKYvb26AsK/VO1//MS5ztnK+V9d/0K8nVee9kGDNC4zorSd1NjRc
Jkj/JJm1k/9QiQQwOSB/94zKWUyVH2Rvw3UOuaTu9pWRQsIdmPNwXBKCOF5L17HHGaNqYzvHF7YY
REIp6VR4HcyLq2beYXn09Mq0f84obUr7+CMgh8i1SaLa/ydMPS9xsm1i0NFB3qcEC0dDq6xklwsX
s198UBI5mBJTEUKi38eytWXzQPFTmqdlD3Qn4CgstxSdoLrFHchISqt+L62U4xU6aVyYXmVaeebF
I1F3MAXQZwZwGETW7RW9t/+3pJtkjPfPtdnqu/Sg+zP+vLjSV/NcONctKnTj86/z+TTehoSH8ccr
BsjV0PhAtR3+RTr3VGkKJoUNeE8yFQIHlES8UamuSNMh5XrbmcbFx22MZ9gLOa350ytm1N124jNF
V860l5gGbt/8NcGf8I3EVPrYblJ5ZLGsZkVg1cKBMUys1yMm6Ci2Mruc

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
JDELzo7luYHcwIl8sAAMR3hvm1tr+ZaD3VKTvYj1uwYFwuIPCkUfjVi8OMAgp3Hh/R1wDZSeoY7T
xpO0sKF9MsovKwwArnByLL8zZflfJIe5AmC+jE5a8qUxydp4liMdOypRTLu6U6EUYUwSj6VOR0Uj
deCoQCr/gVZ2GdNKF5sKZsGXZSvx1Wag70BiGs69qhgUvVVlpbqpNRSB0DR/2IuSKCHhkucLXiTk
zVS7zC7GiyNYE6l/Yu5Ov25Cl+lY5cMZkqKvIFm90UiTBNYk4No5ofXnH/E0rNcbydv0BvWDmgKt
NXVratbi0ztKLb27z2lw5ZZzXCihB41kx4VjqA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 11072)
`pragma protect data_block
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
rVEg02fkx395+sOO23k=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
