

module evaluate_low_low_high_fp_int #
(
  parameter VREF_to_tau_lh = -1115,
  parameter VREG_to_tau_lh = 1131,
  parameter const_tau_lh = 1529
)
(
  input sys_clk,
  input clk,
  input reset,
  input [11-1:0] VREF,
  input [11-1:0] VREG,
  output [9-1:0] out
);

  reg [34-1:0] o;
  wire [39-1:0] tau_lh;
  wire [36-1:0] dodt;
  wire [43-1:0] truncR_0;
  wire [44-1:0] truncval_1;
  wire [45-1:0] toUsInt_2;
  wire [45-1:0] padr_3;
  wire [1-1:0] padr_bits_4;
  assign padr_bits_4 = 0;
  wire [96-1:0] truncR_5;
  wire [103-1:0] truncval_6;
  wire [103-1:0] padl_7;
  wire [51-1:0] padl_bits_8;
  wire [51-1:0] padr_9;
  wire [40-1:0] padr_bits_10;
  assign padr_bits_10 = 0;
  assign padr_9 = { VREF, padr_bits_10 };
  assign padl_bits_8 = padr_9;
  assign padl_7 = { { 52{ padl_bits_8[50] } }, padl_bits_8 };
  wire [103-1:0] padl_11;
  wire [51-1:0] padl_bits_12;
  wire [51-1:0] padl_13;
  wire [49-1:0] padl_bits_14;
  wire [49-1:0] param_15;
  assign param_15 = VREF_to_tau_lh;
  assign padl_bits_14 = param_15;
  assign padl_13 = { { 2{ padl_bits_14[48] } }, padl_bits_14 };
  assign padl_bits_12 = padl_13;
  assign padl_11 = { { 52{ padl_bits_12[50] } }, padl_bits_12 };
  assign truncval_6 = padl_7 * padl_11;
  assign truncR_5 = truncval_6[95:0];
  wire [44-1:0] padr_16;
  wire [3-1:0] padr_bits_17;
  assign padr_bits_17 = 0;
  wire [90-1:0] truncR_18;
  wire [97-1:0] truncval_19;
  wire [97-1:0] padl_20;
  wire [48-1:0] padl_bits_21;
  wire [48-1:0] padr_22;
  wire [37-1:0] padr_bits_23;
  assign padr_bits_23 = 0;
  assign padr_22 = { VREG, padr_bits_23 };
  assign padl_bits_21 = padr_22;
  assign padl_20 = { { 49{ padl_bits_21[47] } }, padl_bits_21 };
  wire [97-1:0] padl_24;
  wire [48-1:0] padl_bits_25;
  wire [48-1:0] padl_26;
  wire [45-1:0] padl_bits_27;
  wire [1-1:0] toSInt_28;
  assign toSInt_28 = 0;
  wire [45-1:0] toSInt_imm_29;
  wire [44-1:0] param_30;
  assign param_30 = VREG_to_tau_lh;
  assign toSInt_imm_29 = { toSInt_28, param_30 };
  assign padl_bits_27 = toSInt_imm_29;
  assign padl_26 = { { 3{ padl_bits_27[44] } }, padl_bits_27 };
  assign padl_bits_25 = padl_26;
  assign padl_24 = { { 49{ padl_bits_25[47] } }, padl_bits_25 };
  assign truncval_19 = padl_20 * padl_24;
  assign truncR_18 = truncval_19[89:0];
  assign padr_16 = { truncR_18[89:49], padr_bits_17 };
  assign padr_3 = { truncR_5[95:52] + padr_16, padr_bits_4 };
  wire [45-1:0] padl_31;
  wire [44-1:0] padl_bits_32;
  wire [1-1:0] toSInt_33;
  assign toSInt_33 = 0;
  wire [44-1:0] toSInt_imm_34;
  wire [43-1:0] param_35;
  assign param_35 = const_tau_lh;
  assign toSInt_imm_34 = { toSInt_33, param_35 };
  assign padl_bits_32 = toSInt_imm_34;
  assign padl_31 = { { 1{ padl_bits_32[43] } }, padl_bits_32 };
  assign toUsInt_2 = padr_3 + padl_31;
  assign truncval_1 = toUsInt_2[41:0];
  assign truncR_0 = truncval_1[42:0];
  assign tau_lh = truncR_0[42:4];
  wire [34-1:0] truncR_36;
  assign truncR_36 = o;
  assign out = truncR_36[33:25];
  wire [36-1:0] padl_37;
  wire [9-1:0] padl_bits_38;
  wire [36-1:0] truncR_39;
  wire [96-1:0] truncR_40;
  wire [129-1:0] truncval_41;
  wire [129-1:0] padl_42;
  wire [64-1:0] padl_bits_43;
  wire [64-1:0] padl_44;
  wire [34-1:0] padl_bits_45;
  wire [34-1:0] padr_46;
  wire [25-1:0] padr_bits_47;
  assign padr_bits_47 = 0;
  wire [9-1:0] padl_48;
  wire [8-1:0] padl_bits_49;
  wire [1-1:0] toSInt_50;
  assign toSInt_50 = 0;
  wire [8-1:0] toSInt_imm_51;
  wire [7-1:0] const_52;
  assign const_52 = 105;
  assign toSInt_imm_51 = { toSInt_50, const_52 };
  assign padl_bits_49 = toSInt_imm_51;
  assign padl_48 = { { 1{ padl_bits_49[7] } }, padl_bits_49 };
  assign padr_46 = { padl_48, padr_bits_47 };
  assign padl_bits_45 = padr_46 - o;
  assign padl_44 = { { 30{ padl_bits_45[33] } }, padl_bits_45 };
  assign padl_bits_43 = padl_44;
  assign padl_42 = { { 65{ padl_bits_43[63] } }, padl_bits_43 };
  wire [129-1:0] padl_53;
  wire [64-1:0] padl_bits_54;
  wire [64-1:0] padr_55;
  wire [30-1:0] padr_bits_56;
  assign padr_bits_56 = 0;
  wire [1-1:0] toSInt_57;
  assign toSInt_57 = 0;
  wire [34-1:0] toSInt_imm_58;
  wire [39-1:0] truncval_59;
  assign truncval_59 = 40'd549755813888 / tau_lh;
  assign toSInt_imm_58 = { toSInt_57, truncval_59[32:0] };
  assign padr_55 = { toSInt_imm_58, padr_bits_56 };
  assign padl_bits_54 = padr_55;
  assign padl_53 = { { 65{ padl_bits_54[63] } }, padl_bits_54 };
  assign truncval_41 = padl_42 * padl_53;
  assign truncR_40 = truncval_41[95:0];
  assign truncR_39 = truncR_40[95:60];
  assign padl_bits_38 = truncR_39[35:27];
  assign padl_37 = { { 27{ padl_bits_38[8] } }, padl_bits_38 };
  assign dodt = padl_37;
  wire [34-1:0] padr_60;
  wire [21-1:0] padr_bits_61;
  assign padr_bits_61 = 0;
  wire [13-1:0] padl_62;
  wire [11-1:0] padl_bits_63;
  wire [63-1:0] truncR_64;
  wire [134-1:0] truncval_65;
  wire [134-1:0] padl_66;
  wire [80-1:0] padl_bits_67;
  wire [80-1:0] padl_68;
  wire [45-1:0] padl_bits_69;
  wire [1-1:0] toSInt_70;
  assign toSInt_70 = 0;
  wire [45-1:0] toSInt_imm_71;
  wire [44-1:0] const_72;
  assign const_72 = 175;
  assign toSInt_imm_71 = { toSInt_70, const_72 };
  assign padl_bits_69 = toSInt_imm_71;
  assign padl_68 = { { 35{ padl_bits_69[44] } }, padl_bits_69 };
  assign padl_bits_67 = padl_68;
  assign padl_66 = { { 54{ padl_bits_67[79] } }, padl_bits_67 };
  wire [134-1:0] padl_73;
  wire [80-1:0] padl_bits_74;
  wire [80-1:0] padr_75;
  wire [44-1:0] padr_bits_76;
  assign padr_bits_76 = 0;
  assign padr_75 = { dodt, padr_bits_76 };
  assign padl_bits_74 = padr_75;
  assign padl_73 = { { 54{ padl_bits_74[79] } }, padl_bits_74 };
  assign truncval_65 = padl_66 * padl_73;
  assign truncR_64 = truncval_65[62:0];
  assign padl_bits_63 = truncR_64[62:52];
  assign padl_62 = { { 2{ padl_bits_63[10] } }, padl_bits_63 };
  assign padr_60 = { padl_62, padr_bits_61 };

  always @(posedge clk) begin
    if(reset) begin
      o <= 0;
    end else begin
      o <= o + padr_60;
    end
  end


endmodule

