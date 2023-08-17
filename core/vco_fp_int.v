

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
  wire [15-1:0] neg_imm_2;
  wire [1-1:0] toSInt_3;
  assign toSInt_3 = 0;
  wire [15-1:0] toSInt_imm_4;
  wire [34-1:0] truncR_5;
  assign truncR_5 = w * w;
  assign toSInt_imm_4 = { toSInt_3, truncR_5[33:20] };
  assign neg_imm_2 = -toSInt_imm_4;
  wire [15-1:0] padr_6;
  wire [1-1:0] padr_bits_7;
  assign padr_bits_7 = 0;
  assign padr_6 = { x, padr_bits_7 };
  assign truncR_1 = neg_imm_2 * padr_6;
  assign truncval_0 = truncR_1[30:14];
  assign dvdt = truncval_0[16:15];
  assign dxdt = v;
  assign out = x;
  wire [21-1:0] truncR_8;
  wire [23-1:0] truncval_9;
  wire [43-1:0] truncR_10;
  wire [1-1:0] toSInt_11;
  assign toSInt_11 = 0;
  wire [21-1:0] toSInt_imm_12;
  wire [20-1:0] const_13;
  assign const_13 = 10485;
  assign toSInt_imm_12 = { toSInt_11, const_13 };
  wire [21-1:0] padr_14;
  wire [6-1:0] padr_bits_15;
  assign padr_bits_15 = 0;
  assign padr_14 = { dvdt, padr_bits_15 };
  assign truncR_10 = toSInt_imm_12 * padr_14;
  assign truncval_9 = truncR_10[42:20];
  assign truncR_8 = truncval_9[22:21];
  wire [20-1:0] truncR_16;
  wire [22-1:0] truncval_17;
  wire [43-1:0] truncR_18;
  wire [1-1:0] toSInt_19;
  assign toSInt_19 = 0;
  wire [21-1:0] toSInt_imm_20;
  wire [20-1:0] const_21;
  assign const_21 = 10485;
  assign toSInt_imm_20 = { toSInt_19, const_21 };
  wire [21-1:0] padr_22;
  wire [7-1:0] padr_bits_23;
  assign padr_bits_23 = 0;
  assign padr_22 = { dxdt, padr_bits_23 };
  assign truncR_18 = toSInt_imm_20 * padr_22;
  assign truncval_17 = truncR_18[42:21];
  assign truncR_16 = truncval_17[21:20];

  always @(posedge clk) begin
    if(reset) begin
      v <= 7782;
    end else begin
      v <= v + truncR_8[20:7];
    end
    if(reset) begin
      x <= 7782;
    end else begin
      x <= x + truncR_16[19:6];
    end
  end


endmodule

