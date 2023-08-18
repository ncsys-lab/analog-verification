

module vco_fp_int
(
  input sys_clk,
  input clk,
  input reset,
  input [17-1:0] w,
  output [14-1:0] out
);

  reg [14-1:0] x;
  reg [14-1:0] v;
  wire [15-1:0] dvdt;
  wire [14-1:0] dxdt;
  wire [17-1:0] truncval_0;
  wire [31-1:0] truncR_1;
  wire [31-1:0] padl_2;
  wire [15-1:0] padl_bits_3;
  wire [15-1:0] neg_imm_4;
  wire [1-1:0] toSInt_5;
  assign toSInt_5 = 0;
  wire [15-1:0] toSInt_imm_6;
  wire [34-1:0] truncR_7;
  wire [34-1:0] padl_8;
  wire [17-1:0] padl_bits_9;
  assign padl_bits_9 = w;
  wire [17-1:0] padl_bits_zero_10;
  assign padl_bits_zero_10 = 0;
  assign padl_8 = { padl_bits_zero_10, padl_bits_9 };
  wire [34-1:0] padl_11;
  wire [17-1:0] padl_bits_12;
  assign padl_bits_12 = w;
  wire [17-1:0] padl_bits_zero_13;
  assign padl_bits_zero_13 = 0;
  assign padl_11 = { padl_bits_zero_13, padl_bits_12 };
  assign truncR_7 = padl_8 * padl_11;
  assign toSInt_imm_6 = { toSInt_5, truncR_7[33:20] };
  assign neg_imm_4 = -toSInt_imm_6;
  assign padl_bits_3 = neg_imm_4;
  assign padl_2 = { { 16{ padl_bits_3[14] } }, padl_bits_3 };
  wire [31-1:0] padl_14;
  wire [15-1:0] padl_bits_15;
  wire [15-1:0] padr_16;
  wire [1-1:0] padr_bits_17;
  assign padr_bits_17 = 0;
  assign padr_16 = { x, padr_bits_17 };
  assign padl_bits_15 = padr_16;
  assign padl_14 = { { 16{ padl_bits_15[14] } }, padl_bits_15 };
  assign truncR_1 = padl_2 * padl_14;
  assign truncval_0 = truncR_1[30:14];
  assign dvdt = truncval_0[16:2];
  assign dxdt = v;
  assign out = x;
  wire [21-1:0] truncR_18;
  wire [23-1:0] truncval_19;
  wire [43-1:0] truncR_20;
  wire [43-1:0] padl_21;
  wire [21-1:0] padl_bits_22;
  wire [1-1:0] toSInt_23;
  assign toSInt_23 = 0;
  wire [21-1:0] toSInt_imm_24;
  wire [20-1:0] const_25;
  assign const_25 = 10485;
  assign toSInt_imm_24 = { toSInt_23, const_25 };
  assign padl_bits_22 = toSInt_imm_24;
  assign padl_21 = { { 22{ padl_bits_22[20] } }, padl_bits_22 };
  wire [43-1:0] padl_26;
  wire [21-1:0] padl_bits_27;
  wire [21-1:0] padr_28;
  wire [6-1:0] padr_bits_29;
  assign padr_bits_29 = 0;
  assign padr_28 = { dvdt, padr_bits_29 };
  assign padl_bits_27 = padr_28;
  assign padl_26 = { { 22{ padl_bits_27[20] } }, padl_bits_27 };
  assign truncR_20 = padl_21 * padl_26;
  assign truncval_19 = truncR_20[42:20];
  assign truncR_18 = truncval_19[22:2];
  wire [20-1:0] truncR_30;
  wire [22-1:0] truncval_31;
  wire [43-1:0] truncR_32;
  wire [43-1:0] padl_33;
  wire [21-1:0] padl_bits_34;
  wire [1-1:0] toSInt_35;
  assign toSInt_35 = 0;
  wire [21-1:0] toSInt_imm_36;
  wire [20-1:0] const_37;
  assign const_37 = 10485;
  assign toSInt_imm_36 = { toSInt_35, const_37 };
  assign padl_bits_34 = toSInt_imm_36;
  assign padl_33 = { { 22{ padl_bits_34[20] } }, padl_bits_34 };
  wire [43-1:0] padl_38;
  wire [21-1:0] padl_bits_39;
  wire [21-1:0] padr_40;
  wire [7-1:0] padr_bits_41;
  assign padr_bits_41 = 0;
  assign padr_40 = { dxdt, padr_bits_41 };
  assign padl_bits_39 = padr_40;
  assign padl_38 = { { 22{ padl_bits_39[20] } }, padl_bits_39 };
  assign truncR_32 = padl_33 * padl_38;
  assign truncval_31 = truncR_32[42:21];
  assign truncR_30 = truncval_31[21:2];

  always @(posedge clk) begin
    if(reset) begin
      v <= 0;
    end else begin
      v <= v + truncR_18[20:7];
    end
    if(reset) begin
      x <= 6471;
    end else begin
      x <= x + truncR_30[19:6];
    end
  end


endmodule

