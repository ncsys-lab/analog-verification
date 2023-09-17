

module evaluate_low_low_high_fp_int #
(
  parameter VREF_to_tau = -1115,
  parameter VREG_to_tau = 1131,
  parameter const_tau = 1529
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
  wire [39-1:0] tau;
  wire [35-1:0] dodt;
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
  assign param_17 = VREF_to_tau;
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
  assign param_35 = VREG_to_tau;
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
  assign param_42 = const_tau;
  assign toSInt_imm_41 = { toSInt_40, param_42 };
  assign padl_bits_39 = toSInt_imm_41;
  assign padl_38 = { { 1{ padl_bits_39[43] } }, padl_bits_39 };
  assign toUsInt_2 = padr_3 + padl_38;
  assign truncval_1 = toUsInt_2[41:0];
  assign truncR_0 = truncval_1[42:0];
  assign tau = truncR_0[42:4];
  wire [32-1:0] truncR_43;
  assign truncR_43 = o;
  assign out = truncR_43[31:25];
  wire [95-1:0] truncR_44;
  wire [125-1:0] truncval_45;
  wire [125-1:0] padl_46;
  wire [62-1:0] padl_bits_47;
  wire [62-1:0] padl_48;
  wire [32-1:0] padl_bits_49;
  wire [32-1:0] padr_50;
  wire [25-1:0] padr_bits_51;
  assign padr_bits_51 = 0;
  wire [7-1:0] const_52;
  assign const_52 = 105;
  assign padr_50 = { const_52, padr_bits_51 };
  assign padl_bits_49 = padr_50 - o;
  wire [30-1:0] padl_bits_zero_53;
  assign padl_bits_zero_53 = 0;
  assign padl_48 = { padl_bits_zero_53, padl_bits_49 };
  assign padl_bits_47 = padl_48;
  wire [63-1:0] padl_bits_zero_54;
  assign padl_bits_zero_54 = 0;
  assign padl_46 = { padl_bits_zero_54, padl_bits_47 };
  wire [125-1:0] padl_55;
  wire [62-1:0] padl_bits_56;
  wire [62-1:0] padr_57;
  wire [30-1:0] padr_bits_58;
  assign padr_bits_58 = 0;
  wire [39-1:0] truncval_59;
  assign truncval_59 = 39'd549755813887 / tau;
  assign padr_57 = { truncval_59[31:0], padr_bits_58 };
  assign padl_bits_56 = padr_57;
  wire [63-1:0] padl_bits_zero_60;
  assign padl_bits_zero_60 = 0;
  assign padl_55 = { padl_bits_zero_60, padl_bits_56 };
  assign truncval_45 = padl_46 * padl_55;
  assign truncR_44 = truncval_45[94:0];
  assign dodt = truncR_44[94:60];
  wire [32-1:0] padr_61;
  wire [20-1:0] padr_bits_62;
  assign padr_bits_62 = 0;
  wire [12-1:0] padl_63;
  wire [11-1:0] padl_bits_64;
  wire [12-1:0] toUsInt_65;
  wire [64-1:0] truncR_66;
  wire [133-1:0] truncval_67;
  wire [133-1:0] padl_68;
  wire [79-1:0] padl_bits_69;
  wire [79-1:0] padl_70;
  wire [45-1:0] padl_bits_71;
  wire [1-1:0] toSInt_72;
  assign toSInt_72 = 0;
  wire [45-1:0] toSInt_imm_73;
  wire [44-1:0] const_74;
  assign const_74 = 175;
  assign toSInt_imm_73 = { toSInt_72, const_74 };
  assign padl_bits_71 = toSInt_imm_73;
  assign padl_70 = { { 34{ padl_bits_71[44] } }, padl_bits_71 };
  assign padl_bits_69 = padl_70;
  assign padl_68 = { { 54{ padl_bits_69[78] } }, padl_bits_69 };
  wire [133-1:0] padl_75;
  wire [79-1:0] padl_bits_76;
  wire [79-1:0] padr_77;
  wire [44-1:0] padr_bits_78;
  assign padr_bits_78 = 0;
  assign padr_77 = { dodt, padr_bits_78 };
  assign padl_bits_76 = padr_77;
  assign padl_75 = { { 54{ padl_bits_76[78] } }, padl_bits_76 };
  assign truncval_67 = padl_68 * padl_75;
  assign truncR_66 = truncval_67[63:0];
  assign toUsInt_65 = truncR_66[63:52];
  assign padl_bits_64 = toUsInt_65[8:0];
  wire [1-1:0] padl_bits_zero_79;
  assign padl_bits_zero_79 = 0;
  assign padl_63 = { padl_bits_zero_79, padl_bits_64 };
  assign padr_61 = { padl_63, padr_bits_62 };

  always @(posedge clk) begin
    if(reset) begin
      o <= 0;
    end else begin
      o <= o + padr_61;
    end
  end


endmodule

