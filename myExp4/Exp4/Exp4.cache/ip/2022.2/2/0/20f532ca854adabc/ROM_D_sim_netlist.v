// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Nov 11 13:48:37 2022
// Host        : E14-Windows running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ROM_D_sim_netlist.v
// Design      : ROM_D
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg676-2L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_D,dist_mem_gen_v8_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dist_mem_gen_v8_0_13 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 11120)
`pragma protect data_block
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
BHvJBVQ=
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
