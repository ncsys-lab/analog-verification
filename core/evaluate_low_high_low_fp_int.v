

module evaluate_low_high_low_fp_int #
(
  parameter VREF_to_tau = 1037,
  parameter VREG_to_tau = -1248,
  parameter const_tau = 1042
)
(
  input sys_clk,
  input clk,
  input reset,
  input [14-1:0] VREF,
  input [14-1:0] VREG,
  output [12-1:0] out
);

  reg [11-1:0] o;
  wire [41-1:0] tau;
  wire [35-1:0] dvdt;
  wire [42-1:0] truncval_0;
  wire [43-1:0] toUsInt_1;
  wire [88-1:0] truncR_2;
  wire [95-1:0] truncval_3;
  wire [95-1:0] padl_4;
  wire [47-1:0] padl_bits_5;
  wire [47-1:0] padr_6;
  wire [33-1:0] padr_bits_7;
  assign padr_bits_7 = 0;
  assign padr_6 = { VREF, padr_bits_7 };
  assign padl_bits_5 = padr_6;
  assign padl_4 = { { 48{ padl_bits_5[46] } }, padl_bits_5 };
  wire [95-1:0] padl_8;
  wire [47-1:0] padl_bits_9;
  wire [47-1:0] padl_10;
  wire [44-1:0] padl_bits_11;
  wire [1-1:0] toSInt_12;
  assign toSInt_12 = 0;
  wire [44-1:0] toSInt_imm_13;
  wire [43-1:0] param_14;
  assign param_14 = VREF_to_tau;
  assign toSInt_imm_13 = { toSInt_12, param_14 };
  assign padl_bits_11 = toSInt_imm_13;
  assign padl_10 = { { 3{ padl_bits_11[43] } }, padl_bits_11 };
  assign padl_bits_9 = padl_10;
  assign padl_8 = { { 48{ padl_bits_9[46] } }, padl_bits_9 };
  assign truncval_3 = padl_4 * padl_8;
  assign truncR_2 = truncval_3[87:0];
  wire [43-1:0] truncR_shift_15;
  assign truncR_shift_15 = truncR_2 >>> 45;
  wire [43-1:0] truncR_imm_16;
  assign truncR_imm_16 = (truncR_2[87])? truncR_shift_15[42:0] : truncR_2[87:45];
  wire [88-1:0] truncR_17;
  wire [95-1:0] truncval_18;
  wire [95-1:0] padl_19;
  wire [47-1:0] padl_bits_20;
  wire [47-1:0] padr_21;
  wire [33-1:0] padr_bits_22;
  assign padr_bits_22 = 0;
  assign padr_21 = { VREG, padr_bits_22 };
  assign padl_bits_20 = padr_21;
  assign padl_19 = { { 48{ padl_bits_20[46] } }, padl_bits_20 };
  wire [95-1:0] padl_23;
  wire [47-1:0] padl_bits_24;
  wire [47-1:0] padl_25;
  wire [45-1:0] padl_bits_26;
  wire [45-1:0] param_27;
  assign param_27 = VREG_to_tau;
  assign padl_bits_26 = param_27;
  assign padl_25 = { { 2{ padl_bits_26[44] } }, padl_bits_26 };
  assign padl_bits_24 = padl_25;
  assign padl_23 = { { 48{ padl_bits_24[46] } }, padl_bits_24 };
  assign truncval_18 = padl_19 * padl_23;
  assign truncR_17 = truncval_18[87:0];
  wire [43-1:0] truncR_shift_28;
  assign truncR_shift_28 = truncR_17 >>> 45;
  wire [43-1:0] truncR_imm_29;
  assign truncR_imm_29 = (truncR_17[87])? truncR_shift_28[42:0] : truncR_17[87:45];
  wire [43-1:0] padl_30;
  wire [42-1:0] padl_bits_31;
  wire [1-1:0] toSInt_32;
  assign toSInt_32 = 0;
  wire [42-1:0] toSInt_imm_33;
  wire [41-1:0] param_34;
  assign param_34 = const_tau;
  assign toSInt_imm_33 = { toSInt_32, param_34 };
  assign padl_bits_31 = toSInt_imm_33;
  assign padl_30 = { { 1{ padl_bits_31[41] } }, padl_bits_31 };
  assign toUsInt_1 = truncR_imm_16 + truncR_imm_29 + padl_30;
  assign truncval_0 = toUsInt_1[39:0];
  assign tau = truncval_0[40:0];
  wire [12-1:0] padr_35;
  wire [1-1:0] padr_bits_36;
  assign padr_bits_36 = 0;
  assign padr_35 = { o, padr_bits_36 };
  assign out = padr_35;
  wire [35-1:0] padl_37;
  wire [12-1:0] padl_bits_38;
  wire [35-1:0] truncR_39;
  wire [51-1:0] truncR_40;
  wire [83-1:0] truncval_41;
  wire [83-1:0] padl_42;
  wire [41-1:0] padl_bits_43;
  wire [41-1:0] padl_44;
  wire [12-1:0] padl_bits_45;
  wire [12-1:0] neg_imm_46;
  wire [12-1:0] padr_47;
  wire [1-1:0] padr_bits_48;
  assign padr_bits_48 = 0;
  assign padr_47 = { o, padr_bits_48 };
  assign neg_imm_46 = -padr_47;
  assign padl_bits_45 = neg_imm_46;
  assign padl_44 = { { 29{ padl_bits_45[11] } }, padl_bits_45 };
  assign padl_bits_43 = padl_44;
  assign padl_42 = { { 42{ padl_bits_43[40] } }, padl_bits_43 };
  wire [83-1:0] padl_49;
  wire [41-1:0] padl_bits_50;
  wire [41-1:0] padr_51;
  wire [8-1:0] padr_bits_52;
  assign padr_bits_52 = 0;
  wire [1-1:0] toSInt_53;
  assign toSInt_53 = 0;
  wire [33-1:0] toSInt_imm_54;
  wire [41-1:0] truncval_55;
  assign truncval_55 = 42'd2199023255552 / tau;
  assign toSInt_imm_54 = { toSInt_53, truncval_55[31:0] };
  assign padr_51 = { toSInt_imm_54, padr_bits_52 };
  assign padl_bits_50 = padr_51;
  assign padl_49 = { { 42{ padl_bits_50[40] } }, padl_bits_50 };
  assign truncval_41 = padl_42 * padl_49;
  assign truncR_40 = truncval_41[50:0];
  wire [35-1:0] truncR_shift_56;
  assign truncR_shift_56 = truncR_40 >>> 16;
  wire [35-1:0] truncR_imm_57;
  assign truncR_imm_57 = (truncR_40[50])? truncR_shift_56[34:0] : truncR_40[50:16];
  assign truncR_39 = truncR_imm_57;
  wire [12-1:0] truncR_shift_58;
  assign truncR_shift_58 = truncR_39 >>> 23;
  wire [12-1:0] truncR_imm_59;
  assign truncR_imm_59 = (truncR_39[34])? truncR_shift_58[11:0] : truncR_39[34:23];
  assign padl_bits_38 = truncR_imm_59;
  assign padl_37 = { { 23{ padl_bits_38[11] } }, padl_bits_38 };
  assign dvdt = padl_37;
  wire [14-1:0] truncR_60;
  wire [14-1:0] padl_61;
  wire [12-1:0] padl_bits_62;
  wire [85-1:0] truncR_63;
  wire [154-1:0] truncval_64;
  wire [154-1:0] padl_65;
  wire [88-1:0] padl_bits_66;
  wire [88-1:0] padl_67;
  wire [54-1:0] padl_bits_68;
  wire [1-1:0] toSInt_69;
  assign toSInt_69 = 0;
  wire [54-1:0] toSInt_imm_70;
  wire [53-1:0] const_71;
  assign const_71 = 900719;
  assign toSInt_imm_70 = { toSInt_69, const_71 };
  assign padl_bits_68 = toSInt_imm_70;
  assign padl_67 = { { 34{ padl_bits_68[53] } }, padl_bits_68 };
  assign padl_bits_66 = padl_67;
  assign padl_65 = { { 66{ padl_bits_66[87] } }, padl_bits_66 };
  wire [154-1:0] padl_72;
  wire [88-1:0] padl_bits_73;
  wire [88-1:0] padr_74;
  wire [53-1:0] padr_bits_75;
  assign padr_bits_75 = 0;
  assign padr_74 = { dvdt, padr_bits_75 };
  assign padl_bits_73 = padr_74;
  assign padl_72 = { { 66{ padl_bits_73[87] } }, padl_bits_73 };
  assign truncval_64 = padl_65 * padl_72;
  assign truncR_63 = truncval_64[84:0];
  wire [12-1:0] truncR_shift_76;
  assign truncR_shift_76 = truncR_63 >>> 73;
  wire [12-1:0] truncR_imm_77;
  assign truncR_imm_77 = (truncR_63[84])? truncR_shift_76[11:0] : truncR_63[84:73];
  assign padl_bits_62 = truncR_imm_77;
  assign padl_61 = { { 2{ padl_bits_62[11] } }, padl_bits_62 };
  assign truncR_60 = padl_61;
  wire [11-1:0] truncR_shift_78;
  assign truncR_shift_78 = truncR_60 >>> 3;
  wire [11-1:0] truncR_imm_79;
  assign truncR_imm_79 = (truncR_60[13])? truncR_shift_78[10:0] : truncR_60[13:3];

  always @(posedge clk) begin
    if(reset) begin
      o <= 422;
    end else begin
      o <= o + truncR_imm_79;
    end
  end


endmodule

