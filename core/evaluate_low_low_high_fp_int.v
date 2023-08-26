

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
  input [8-1:0] VREF,
  input [9-1:0] VREG,
  output [7-1:0] out
);

  reg [6-1:0] o;
  wire [39-1:0] tau;
  wire [34-1:0] dodt;
  wire [43-1:0] truncR_0;
  wire [44-1:0] toUsInt_1;
  wire [95-1:0] truncR_2;
  wire [99-1:0] truncval_3;
  wire [99-1:0] padl_4;
  wire [49-1:0] padl_bits_5;
  wire [49-1:0] padr_6;
  wire [40-1:0] padr_bits_7;
  assign padr_bits_7 = 0;
  wire [1-1:0] toSInt_8;
  assign toSInt_8 = 0;
  wire [9-1:0] toSInt_imm_9;
  assign toSInt_imm_9 = { toSInt_8, VREF };
  assign padr_6 = { toSInt_imm_9, padr_bits_7 };
  assign padl_bits_5 = padr_6;
  assign padl_4 = { { 50{ padl_bits_5[48] } }, padl_bits_5 };
  wire [99-1:0] padl_10;
  wire [49-1:0] padl_bits_11;
  wire [49-1:0] padl_12;
  wire [48-1:0] padl_bits_13;
  wire [48-1:0] param_14;
  assign param_14 = VREF_to_tau;
  assign padl_bits_13 = param_14;
  assign padl_12 = { { 1{ padl_bits_13[47] } }, padl_bits_13 };
  assign padl_bits_11 = padl_12;
  assign padl_10 = { { 50{ padl_bits_11[48] } }, padl_bits_11 };
  assign truncval_3 = padl_4 * padl_10;
  assign truncR_2 = truncval_3[94:0];
  wire [44-1:0] padr_15;
  wire [4-1:0] padr_bits_16;
  assign padr_bits_16 = 0;
  wire [1-1:0] toSInt_17;
  assign toSInt_17 = 0;
  wire [40-1:0] toSInt_imm_18;
  wire [88-1:0] truncR_19;
  wire [92-1:0] truncval_20;
  wire [92-1:0] padl_21;
  wire [46-1:0] padl_bits_22;
  wire [46-1:0] padr_23;
  wire [37-1:0] padr_bits_24;
  assign padr_bits_24 = 0;
  assign padr_23 = { VREG, padr_bits_24 };
  assign padl_bits_22 = padr_23;
  wire [46-1:0] padl_bits_zero_25;
  assign padl_bits_zero_25 = 0;
  assign padl_21 = { padl_bits_zero_25, padl_bits_22 };
  wire [92-1:0] padl_26;
  wire [46-1:0] padl_bits_27;
  wire [46-1:0] padl_28;
  wire [44-1:0] padl_bits_29;
  wire [44-1:0] param_30;
  assign param_30 = VREG_to_tau;
  assign padl_bits_29 = param_30;
  wire [2-1:0] padl_bits_zero_31;
  assign padl_bits_zero_31 = 0;
  assign padl_28 = { padl_bits_zero_31, padl_bits_29 };
  assign padl_bits_27 = padl_28;
  wire [46-1:0] padl_bits_zero_32;
  assign padl_bits_zero_32 = 0;
  assign padl_26 = { padl_bits_zero_32, padl_bits_27 };
  assign truncval_20 = padl_21 * padl_26;
  assign truncR_19 = truncval_20[87:0];
  assign toSInt_imm_18 = { toSInt_17, truncR_19[87:49] };
  assign padr_15 = { toSInt_imm_18, padr_bits_16 };
  wire [1-1:0] toSInt_33;
  assign toSInt_33 = 0;
  wire [44-1:0] toSInt_imm_34;
  wire [43-1:0] param_35;
  assign param_35 = const_tau;
  assign toSInt_imm_34 = { toSInt_33, param_35 };
  assign toUsInt_1 = truncR_2[94:51] + padr_15 + toSInt_imm_34;
  assign truncR_0 = toUsInt_1[40:0];
  assign tau = truncR_0[42:4];
  wire [7-1:0] padr_36;
  wire [1-1:0] padr_bits_37;
  assign padr_bits_37 = 0;
  assign padr_36 = { o, padr_bits_37 };
  assign out = padr_36;
  wire [34-1:0] padl_38;
  wire [3-1:0] padl_bits_39;
  wire [7-1:0] const_40;
  assign const_40 = 105;
  wire [7-1:0] padr_41;
  wire [1-1:0] padr_bits_42;
  assign padr_bits_42 = 0;
  assign padr_41 = { o, padr_bits_42 };
  assign padl_bits_39 = (const_40 - padr_41) / tau;
  assign padl_38 = { { 31{ padl_bits_39[2] } }, padl_bits_39 };
  assign dodt = padl_38;
  wire [12-1:0] truncR_43;
  wire [12-1:0] padl_44;
  wire [10-1:0] padl_bits_45;
  wire [11-1:0] toUsInt_46;
  wire [63-1:0] truncR_47;
  wire [131-1:0] truncval_48;
  wire [131-1:0] padl_49;
  wire [78-1:0] padl_bits_50;
  wire [78-1:0] padl_51;
  wire [45-1:0] padl_bits_52;
  wire [1-1:0] toSInt_53;
  assign toSInt_53 = 0;
  wire [45-1:0] toSInt_imm_54;
  wire [44-1:0] const_55;
  assign const_55 = 175;
  assign toSInt_imm_54 = { toSInt_53, const_55 };
  assign padl_bits_52 = toSInt_imm_54;
  assign padl_51 = { { 33{ padl_bits_52[44] } }, padl_bits_52 };
  assign padl_bits_50 = padl_51;
  assign padl_49 = { { 53{ padl_bits_50[77] } }, padl_bits_50 };
  wire [131-1:0] padl_56;
  wire [78-1:0] padl_bits_57;
  wire [78-1:0] padr_58;
  wire [44-1:0] padr_bits_59;
  assign padr_bits_59 = 0;
  assign padr_58 = { dodt, padr_bits_59 };
  assign padl_bits_57 = padr_58;
  assign padl_56 = { { 53{ padl_bits_57[77] } }, padl_bits_57 };
  assign truncval_48 = padl_49 * padl_56;
  assign truncR_47 = truncval_48[62:0];
  assign toUsInt_46 = truncR_47[62:52];
  assign padl_bits_45 = toUsInt_46[7:0];
  wire [2-1:0] padl_bits_zero_60;
  assign padl_bits_zero_60 = 0;
  assign padl_44 = { padl_bits_zero_60, padl_bits_45 };
  assign truncR_43 = padl_44;

  always @(posedge clk) begin
    if(reset) begin
      o <= 0;
    end else begin
      o <= o + truncR_43[11:6];
    end
  end


endmodule

