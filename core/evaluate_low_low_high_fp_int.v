

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
  input [9-1:0] VREF,
  input [9-1:0] VREG,
  output [7-1:0] out
);

  reg [32-1:0] o;
  wire [39-1:0] tau_lh;
  wire [36-1:0] dodt;
  wire [43-1:0] truncR_0;
  wire [44-1:0] truncval_1;
  wire [45-1:0] toUsInt_2;
  wire [45-1:0] padr_3;
  wire [1-1:0] padr_bits_4;
  assign padr_bits_4 = 0;
  wire [96-1:0] truncR_5;
  wire [101-1:0] truncval_6;
  wire [101-1:0] padl_7;
  wire [50-1:0] padl_bits_8;
  wire [50-1:0] padr_9;
  wire [40-1:0] padr_bits_10;
  assign padr_bits_10 = 0;
  wire [1-1:0] toSInt_11;
  assign toSInt_11 = 0;
  wire [10-1:0] toSInt_imm_12;
  assign toSInt_imm_12 = { toSInt_11, VREF };
  assign padr_9 = { toSInt_imm_12, padr_bits_10 };
  assign padl_bits_8 = padr_9;
  assign padl_7 = { { 51{ padl_bits_8[49] } }, padl_bits_8 };
  wire [101-1:0] padl_13;
  wire [50-1:0] padl_bits_14;
  wire [50-1:0] padl_15;
  wire [49-1:0] padl_bits_16;
  wire [49-1:0] param_17;
  assign param_17 = VREF_to_tau_lh;
  assign padl_bits_16 = param_17;
  assign padl_15 = { { 1{ padl_bits_16[48] } }, padl_bits_16 };
  assign padl_bits_14 = padl_15;
  assign padl_13 = { { 51{ padl_bits_14[49] } }, padl_bits_14 };
  assign truncval_6 = padl_7 * padl_13;
  assign truncR_5 = truncval_6[95:0];
  wire [44-1:0] padr_18;
  wire [3-1:0] padr_bits_19;
  assign padr_bits_19 = 0;
  wire [41-1:0] padl_20;
  wire [40-1:0] padl_bits_21;
  wire [1-1:0] toSInt_22;
  assign toSInt_22 = 0;
  wire [40-1:0] toSInt_imm_23;
  wire [88-1:0] truncR_24;
  wire [92-1:0] truncval_25;
  wire [92-1:0] padl_26;
  wire [46-1:0] padl_bits_27;
  wire [46-1:0] padr_28;
  wire [37-1:0] padr_bits_29;
  assign padr_bits_29 = 0;
  assign padr_28 = { VREG, padr_bits_29 };
  assign padl_bits_27 = padr_28;
  wire [46-1:0] padl_bits_zero_30;
  assign padl_bits_zero_30 = 0;
  assign padl_26 = { padl_bits_zero_30, padl_bits_27 };
  wire [92-1:0] padl_31;
  wire [46-1:0] padl_bits_32;
  wire [46-1:0] padl_33;
  wire [44-1:0] padl_bits_34;
  wire [44-1:0] param_35;
  assign param_35 = VREG_to_tau_lh;
  assign padl_bits_34 = param_35;
  wire [2-1:0] padl_bits_zero_36;
  assign padl_bits_zero_36 = 0;
  assign padl_33 = { padl_bits_zero_36, padl_bits_34 };
  assign padl_bits_32 = padl_33;
  wire [46-1:0] padl_bits_zero_37;
  assign padl_bits_zero_37 = 0;
  assign padl_31 = { padl_bits_zero_37, padl_bits_32 };
  assign truncval_25 = padl_26 * padl_31;
  assign truncR_24 = truncval_25[87:0];
  assign toSInt_imm_23 = { toSInt_22, truncR_24[87:49] };
  assign padl_bits_21 = toSInt_imm_23;
  assign padl_20 = { { 1{ padl_bits_21[39] } }, padl_bits_21 };
  assign padr_18 = { padl_20, padr_bits_19 };
  assign padr_3 = { truncR_5[95:52] + padr_18, padr_bits_4 };
  wire [45-1:0] padl_38;
  wire [44-1:0] padl_bits_39;
  wire [1-1:0] toSInt_40;
  assign toSInt_40 = 0;
  wire [44-1:0] toSInt_imm_41;
  wire [43-1:0] param_42;
  assign param_42 = const_tau_lh;
  assign toSInt_imm_41 = { toSInt_40, param_42 };
  assign padl_bits_39 = toSInt_imm_41;
  assign padl_38 = { { 1{ padl_bits_39[43] } }, padl_bits_39 };
  assign toUsInt_2 = padr_3 + padl_38;
  assign truncval_1 = toUsInt_2[41:0];
  assign truncR_0 = truncval_1[42:0];
  assign tau_lh = truncR_0[42:4];
  wire [32-1:0] truncR_43;
  assign truncR_43 = o;
  assign out = truncR_43[31:25];
  wire [36-1:0] padl_44;
  wire [9-1:0] padl_bits_45;
  wire [36-1:0] truncR_46;
  wire [96-1:0] truncR_47;
  wire [125-1:0] truncval_48;
  wire [125-1:0] padl_49;
  wire [62-1:0] padl_bits_50;
  wire [62-1:0] padl_51;
  wire [32-1:0] padl_bits_52;
  wire [32-1:0] padr_53;
  wire [25-1:0] padr_bits_54;
  assign padr_bits_54 = 0;
  wire [7-1:0] const_55;
  assign const_55 = 105;
  assign padr_53 = { const_55, padr_bits_54 };
  assign padl_bits_52 = padr_53 - o;
  wire [30-1:0] padl_bits_zero_56;
  assign padl_bits_zero_56 = 0;
  assign padl_51 = { padl_bits_zero_56, padl_bits_52 };
  assign padl_bits_50 = padl_51;
  wire [63-1:0] padl_bits_zero_57;
  assign padl_bits_zero_57 = 0;
  assign padl_49 = { padl_bits_zero_57, padl_bits_50 };
  wire [125-1:0] padl_58;
  wire [62-1:0] padl_bits_59;
  wire [62-1:0] padr_60;
  wire [30-1:0] padr_bits_61;
  assign padr_bits_61 = 0;
  wire [39-1:0] truncval_62;
  assign truncval_62 = 40'd549755813888 / tau_lh;
  assign padr_60 = { truncval_62[31:0], padr_bits_61 };
  assign padl_bits_59 = padr_60;
  wire [63-1:0] padl_bits_zero_63;
  assign padl_bits_zero_63 = 0;
  assign padl_58 = { padl_bits_zero_63, padl_bits_59 };
  assign truncval_48 = padl_49 * padl_58;
  assign truncR_47 = truncval_48[95:0];
  assign truncR_46 = truncR_47[95:60];
  assign padl_bits_45 = truncR_46[35:27];
  assign padl_44 = { { 27{ padl_bits_45[8] } }, padl_bits_45 };
  assign dodt = padl_44;
  wire [32-1:0] padr_64;
  wire [19-1:0] padr_bits_65;
  assign padr_bits_65 = 0;
  wire [13-1:0] padl_66;
  wire [12-1:0] padl_bits_67;
  wire [13-1:0] toUsInt_68;
  wire [65-1:0] truncR_69;
  wire [136-1:0] truncval_70;
  wire [136-1:0] padl_71;
  wire [81-1:0] padl_bits_72;
  wire [81-1:0] padl_73;
  wire [46-1:0] padl_bits_74;
  wire [1-1:0] toSInt_75;
  assign toSInt_75 = 0;
  wire [46-1:0] toSInt_imm_76;
  wire [45-1:0] const_77;
  assign const_77 = 175;
  assign toSInt_imm_76 = { toSInt_75, const_77 };
  assign padl_bits_74 = toSInt_imm_76;
  assign padl_73 = { { 35{ padl_bits_74[45] } }, padl_bits_74 };
  assign padl_bits_72 = padl_73;
  assign padl_71 = { { 55{ padl_bits_72[80] } }, padl_bits_72 };
  wire [136-1:0] padl_78;
  wire [81-1:0] padl_bits_79;
  wire [81-1:0] padr_80;
  wire [45-1:0] padr_bits_81;
  assign padr_bits_81 = 0;
  assign padr_80 = { dodt, padr_bits_81 };
  assign padl_bits_79 = padr_80;
  assign padl_78 = { { 55{ padl_bits_79[80] } }, padl_bits_79 };
  assign truncval_70 = padl_71 * padl_78;
  assign truncR_69 = truncval_70[64:0];
  assign toUsInt_68 = truncR_69[64:52];
  assign padl_bits_67 = toUsInt_68[9:0];
  wire [1-1:0] padl_bits_zero_82;
  assign padl_bits_zero_82 = 0;
  assign padl_66 = { padl_bits_zero_82, padl_bits_67 };
  assign padr_64 = { padl_66, padr_bits_65 };

  always @(posedge clk) begin
    if(reset) begin
      o <= 0;
    end else begin
      o <= o + padr_64;
    end
  end


endmodule

