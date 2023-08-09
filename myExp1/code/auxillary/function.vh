/**
 * Several module independent functions.
 * Author: Zhao, Hongyu  <power_zhy@foxmail.com>
 * Editor: Frank Shaw	 <xiaoqingzhe@gmail.com>
 */

function integer GET_WIDTH;  // get width in bits for a constant
	input [31:0] data;
	begin
		if (data[31]) GET_WIDTH=32;
		else if (data[30]) GET_WIDTH=31;
		else if (data[29]) GET_WIDTH=30;
		else if (data[28]) GET_WIDTH=29;
		else if (data[27]) GET_WIDTH=28;
		else if (data[26]) GET_WIDTH=27;
		else if (data[25]) GET_WIDTH=26;
		else if (data[24]) GET_WIDTH=25;
		else if (data[23]) GET_WIDTH=24;
		else if (data[22]) GET_WIDTH=23;
		else if (data[21]) GET_WIDTH=22;
		else if (data[20]) GET_WIDTH=21;
		else if (data[19]) GET_WIDTH=20;
		else if (data[18]) GET_WIDTH=19;
		else if (data[17]) GET_WIDTH=18;
		else if (data[16]) GET_WIDTH=17;
		else if (data[15]) GET_WIDTH=16;
		else if (data[14]) GET_WIDTH=15;
		else if (data[13]) GET_WIDTH=14;
		else if (data[12]) GET_WIDTH=13;
		else if (data[11]) GET_WIDTH=12;
		else if (data[10]) GET_WIDTH=11;
		else if (data[9]) GET_WIDTH=10;
		else if (data[8]) GET_WIDTH=9;
		else if (data[7]) GET_WIDTH=8;
		else if (data[6]) GET_WIDTH=7;
		else if (data[5]) GET_WIDTH=6;
		else if (data[4]) GET_WIDTH=5;
		else if (data[3]) GET_WIDTH=4;
		else if (data[2]) GET_WIDTH=3;
		else if (data[1]) GET_WIDTH=2;
		else if (data[0]) GET_WIDTH=1;
		else GET_WIDTH=1;
	end
	/*begin case(1):			//case的逆序使用
		data[31]: GET_WIDTH=32;
		data[30]: GET_WIDTH=31;
		data[29]: GET_WIDTH=30;
		data[28]: GET_WIDTH=29;
		data[27]: GET_WIDTH=28;
		data[26]: GET_WIDTH=27;
		data[25]: GET_WIDTH=26;
		data[24]: GET_WIDTH=25;
		data[23]: GET_WIDTH=24;
		data[22]: GET_WIDTH=23;
		data[21]: GET_WIDTH=22;
		data[20]: GET_WIDTH=21;
		data[19]: GET_WIDTH=20;
		data[18]: GET_WIDTH=19;
		data[17]: GET_WIDTH=18;
		data[16]: GET_WIDTH=17;
		data[15]: GET_WIDTH=16;
		data[14]: GET_WIDTH=15;
		data[13]: GET_WIDTH=14;
		data[12]: GET_WIDTH=13;
		data[11]: GET_WIDTH=12;
		data[10]: GET_WIDTH=11;
		data[9]: GET_WIDTH=10;
		data[8]: GET_WIDTH=9;
		data[7]: GET_WIDTH=8;
		data[6]: GET_WIDTH=7;
		data[5]: GET_WIDTH=6;
		data[4]: GET_WIDTH=5;
		data[3]: GET_WIDTH=4;
		data[2]: GET_WIDTH=3;
		data[1]: GET_WIDTH=2;
		data[0]: GET_WIDTH=1;
	endcase
	end*/
endfunction
