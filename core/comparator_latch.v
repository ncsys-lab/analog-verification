

module comparator_latch #
(
  parameter VREF_to_response_time = -1020,
  parameter VREG_to_response_time = -1038,
  parameter const_response_time = 1285,
  parameter VREF_to_tau = 1037,
  parameter VREG_to_tau = -1248,
  parameter const_tau = 1042,
  parameter VREF_to_response_time_lh = -1006,
  parameter VREG_to_response_time_lh = -1752,
  parameter const_response_time_lh = 1185,
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
  output [25-1:0] out
);

  reg [20-1:0] state_cycle_counter;
  reg [1-1:0] prev_sys_clk;
  reg [34-1:0] o;
  wire [9-1:0] wait_time;
  wire [37-1:0] tau;
  wire [35-1:0] dvdt;
  wire [8-1:0] wait_time_lh;
  wire [39-1:0] tau_lh;
  wire [36-1:0] dodt;
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  wire [34-1:0] padl_0;
  wire [32-1:0] padl_bits_1;
  wire [32-1:0] padr_2;
  wire [25-1:0] padr_bits_3;
  assign padr_bits_3 = 0;
  wire [7-1:0] const_4;
  assign const_4 = 105;
  assign padr_2 = { const_4, padr_bits_3 };
  assign padl_bits_1 = padr_2;
  wire [2-1:0] padl_bits_zero_5;
  assign padl_bits_zero_5 = 0;
  assign padl_0 = { padl_bits_zero_5, padl_bits_1 };
  wire [31-1:0] truncR_6;
  wire [31-1:0] padr_7;
  wire [12-1:0] padr_bits_8;
  assign padr_bits_8 = 0;
  wire [19-1:0] padr_9;
  wire [6-1:0] padr_bits_10;
  assign padr_bits_10 = 0;
  wire [15-1:0] truncval_11;
  wire [34-1:0] truncR_12;
  assign truncR_12 = o;
  assign truncval_11 = truncR_12[33:19];
  assign padr_9 = { truncval_11[12:0], padr_bits_10 };
  assign padr_7 = { padr_9, padr_bits_8 };
  assign truncR_6 = padr_7;
  assign out = truncR_6[30:6];
  wire [62-1:0] truncR_13;
  wire [131-1:0] truncval_14;
  wire [131-1:0] padl_15;
  wire [80-1:0] padl_bits_16;
  wire [80-1:0] padl_17;
  wire [45-1:0] padl_bits_18;
  wire [45-1:0] padr_19;
  wire [2-1:0] padr_bits_20;
  assign padr_bits_20 = 0;
  wire [94-1:0] truncR_21;
  wire [101-1:0] truncval_22;
  wire [101-1:0] padl_23;
  wire [50-1:0] padl_bits_24;
  wire [50-1:0] padr_25;
  wire [39-1:0] padr_bits_26;
  assign padr_bits_26 = 0;
  assign padr_25 = { VREF, padr_bits_26 };
  assign padl_bits_24 = padr_25;
  assign padl_23 = { { 51{ padl_bits_24[49] } }, padl_bits_24 };
  wire [101-1:0] padl_27;
  wire [50-1:0] padl_bits_28;
  wire [50-1:0] padl_29;
  wire [48-1:0] padl_bits_30;
  wire [48-1:0] param_31;
  assign param_31 = VREF_to_response_time;
  assign padl_bits_30 = param_31;
  assign padl_29 = { { 2{ padl_bits_30[47] } }, padl_bits_30 };
  assign padl_bits_28 = padl_29;
  assign padl_27 = { { 51{ padl_bits_28[49] } }, padl_bits_28 };
  assign truncval_22 = padl_23 * padl_27;
  assign truncR_21 = truncval_22[93:0];
  assign padr_19 = { truncR_21[93:51], padr_bits_20 };
  wire [98-1:0] truncR_32;
  wire [105-1:0] truncval_33;
  wire [105-1:0] padl_34;
  wire [52-1:0] padl_bits_35;
  wire [52-1:0] padr_36;
  wire [41-1:0] padr_bits_37;
  assign padr_bits_37 = 0;
  assign padr_36 = { VREG, padr_bits_37 };
  assign padl_bits_35 = padr_36;
  assign padl_34 = { { 53{ padl_bits_35[51] } }, padl_bits_35 };
  wire [105-1:0] padl_38;
  wire [52-1:0] padl_bits_39;
  wire [52-1:0] padl_40;
  wire [50-1:0] padl_bits_41;
  wire [50-1:0] param_42;
  assign param_42 = VREG_to_response_time;
  assign padl_bits_41 = param_42;
  assign padl_40 = { { 2{ padl_bits_41[49] } }, padl_bits_41 };
  assign padl_bits_39 = padl_40;
  assign padl_38 = { { 53{ padl_bits_39[51] } }, padl_bits_39 };
  assign truncval_33 = padl_34 * padl_38;
  assign truncR_32 = truncval_33[97:0];
  wire [45-1:0] padr_43;
  wire [1-1:0] padr_bits_44;
  assign padr_bits_44 = 0;
  wire [44-1:0] padl_45;
  wire [43-1:0] padl_bits_46;
  wire [1-1:0] toSInt_47;
  assign toSInt_47 = 0;
  wire [43-1:0] toSInt_imm_48;
  wire [42-1:0] param_49;
  assign param_49 = const_response_time;
  assign toSInt_imm_48 = { toSInt_47, param_49 };
  assign padl_bits_46 = toSInt_imm_48;
  assign padl_45 = { { 1{ padl_bits_46[42] } }, padl_bits_46 };
  assign padr_43 = { padl_45, padr_bits_44 };
  assign padl_bits_18 = padr_19 + truncR_32[97:53] + padr_43;
  assign padl_17 = { { 35{ padl_bits_18[44] } }, padl_bits_18 };
  assign padl_bits_16 = padl_17;
  assign padl_15 = { { 51{ padl_bits_16[79] } }, padl_bits_16 };
  wire [131-1:0] padl_50;
  wire [80-1:0] padl_bits_51;
  wire [80-1:0] padr_52;
  wire [43-1:0] padr_bits_53;
  assign padr_bits_53 = 0;
  wire [1-1:0] toSInt_54;
  assign toSInt_54 = 0;
  wire [37-1:0] toSInt_imm_55;
  wire [36-1:0] const_56;
  assign const_56 = 186;
  assign toSInt_imm_55 = { toSInt_54, const_56 };
  assign padr_52 = { toSInt_imm_55, padr_bits_53 };
  assign padl_bits_51 = padr_52;
  assign padl_50 = { { 51{ padl_bits_51[79] } }, padl_bits_51 };
  assign truncval_14 = padl_15 * padl_50;
  assign truncR_13 = truncval_14[61:0];
  assign wait_time = truncR_13[61:53];
  wire [34-1:0] padl_57;
  wire [32-1:0] padl_bits_58;
  wire [32-1:0] padr_59;
  wire [25-1:0] padr_bits_60;
  assign padr_bits_60 = 0;
  wire [7-1:0] const_61;
  assign const_61 = 105;
  assign padr_59 = { const_61, padr_bits_60 };
  assign padl_bits_58 = padr_59;
  wire [2-1:0] padl_bits_zero_62;
  assign padl_bits_zero_62 = 0;
  assign padl_57 = { padl_bits_zero_62, padl_bits_58 };
  wire [31-1:0] truncR_63;
  wire [31-1:0] padr_64;
  wire [12-1:0] padr_bits_65;
  assign padr_bits_65 = 0;
  wire [19-1:0] padr_66;
  wire [6-1:0] padr_bits_67;
  assign padr_bits_67 = 0;
  wire [15-1:0] truncval_68;
  wire [34-1:0] truncR_69;
  assign truncR_69 = o;
  assign truncval_68 = truncR_69[33:19];
  assign padr_66 = { truncval_68[12:0], padr_bits_67 };
  assign padr_64 = { padr_66, padr_bits_65 };
  assign truncR_63 = padr_64;
  wire [41-1:0] truncR_70;
  wire [42-1:0] truncval_71;
  wire [43-1:0] toUsInt_72;
  wire [43-1:0] padr_73;
  wire [3-1:0] padr_bits_74;
  assign padr_bits_74 = 0;
  wire [88-1:0] truncR_75;
  wire [95-1:0] truncval_76;
  wire [95-1:0] padl_77;
  wire [47-1:0] padl_bits_78;
  wire [47-1:0] padr_79;
  wire [36-1:0] padr_bits_80;
  assign padr_bits_80 = 0;
  assign padr_79 = { VREF, padr_bits_80 };
  assign padl_bits_78 = padr_79;
  assign padl_77 = { { 48{ padl_bits_78[46] } }, padl_bits_78 };
  wire [95-1:0] padl_81;
  wire [47-1:0] padl_bits_82;
  wire [47-1:0] padl_83;
  wire [44-1:0] padl_bits_84;
  wire [1-1:0] toSInt_85;
  assign toSInt_85 = 0;
  wire [44-1:0] toSInt_imm_86;
  wire [43-1:0] param_87;
  assign param_87 = VREF_to_tau;
  assign toSInt_imm_86 = { toSInt_85, param_87 };
  assign padl_bits_84 = toSInt_imm_86;
  assign padl_83 = { { 3{ padl_bits_84[43] } }, padl_bits_84 };
  assign padl_bits_82 = padl_83;
  assign padl_81 = { { 48{ padl_bits_82[46] } }, padl_bits_82 };
  assign truncval_76 = padl_77 * padl_81;
  assign truncR_75 = truncval_76[87:0];
  wire [88-1:0] truncR_88;
  wire [95-1:0] truncval_89;
  wire [95-1:0] padl_90;
  wire [47-1:0] padl_bits_91;
  wire [47-1:0] padr_92;
  wire [36-1:0] padr_bits_93;
  assign padr_bits_93 = 0;
  assign padr_92 = { VREG, padr_bits_93 };
  assign padl_bits_91 = padr_92;
  assign padl_90 = { { 48{ padl_bits_91[46] } }, padl_bits_91 };
  wire [95-1:0] padl_94;
  wire [47-1:0] padl_bits_95;
  wire [47-1:0] padl_96;
  wire [45-1:0] padl_bits_97;
  wire [45-1:0] param_98;
  assign param_98 = VREG_to_tau;
  assign padl_bits_97 = param_98;
  assign padl_96 = { { 2{ padl_bits_97[44] } }, padl_bits_97 };
  assign padl_bits_95 = padl_96;
  assign padl_94 = { { 48{ padl_bits_95[46] } }, padl_bits_95 };
  assign truncval_89 = padl_90 * padl_94;
  assign truncR_88 = truncval_89[87:0];
  assign padr_73 = { truncR_75[87:48] + truncR_88[87:48], padr_bits_74 };
  wire [43-1:0] padl_99;
  wire [42-1:0] padl_bits_100;
  wire [1-1:0] toSInt_101;
  assign toSInt_101 = 0;
  wire [42-1:0] toSInt_imm_102;
  wire [41-1:0] param_103;
  assign param_103 = const_tau;
  assign toSInt_imm_102 = { toSInt_101, param_103 };
  assign padl_bits_100 = toSInt_imm_102;
  assign padl_99 = { { 1{ padl_bits_100[41] } }, padl_bits_100 };
  assign toUsInt_72 = padr_73 + padl_99;
  assign truncval_71 = toUsInt_72[39:0];
  assign truncR_70 = truncval_71[40:0];
  assign tau = truncR_70[40:4];
  wire [26-1:0] truncR_104;
  wire [28-1:0] truncval_105;
  wire [28-1:0] padr_106;
  wire [18-1:0] padr_bits_107;
  assign padr_bits_107 = 0;
  wire [10-1:0] padr_108;
  wire [1-1:0] padr_bits_109;
  assign padr_bits_109 = 0;
  wire [34-1:0] truncR_110;
  assign truncR_110 = o;
  assign padr_108 = { truncR_110[33:25], padr_bits_109 };
  assign padr_106 = { padr_108, padr_bits_107 };
  assign truncval_105 = padr_106;
  assign truncR_104 = truncval_105[25:0];
  wire [35-1:0] padl_111;
  wire [9-1:0] padl_bits_112;
  wire [35-1:0] truncR_113;
  wire [45-1:0] truncR_114;
  wire [77-1:0] truncval_115;
  wire [77-1:0] padl_116;
  wire [38-1:0] padl_bits_117;
  wire [38-1:0] padl_118;
  wire [9-1:0] padl_bits_119;
  wire [9-1:0] neg_imm_120;
  wire [34-1:0] truncR_121;
  assign truncR_121 = o;
  assign neg_imm_120 = -truncR_121[33:25];
  assign padl_bits_119 = neg_imm_120;
  assign padl_118 = { { 29{ padl_bits_119[8] } }, padl_bits_119 };
  assign padl_bits_117 = padl_118;
  assign padl_116 = { { 39{ padl_bits_117[37] } }, padl_bits_117 };
  wire [77-1:0] padl_122;
  wire [38-1:0] padl_bits_123;
  wire [38-1:0] padr_124;
  wire [5-1:0] padr_bits_125;
  assign padr_bits_125 = 0;
  wire [1-1:0] toSInt_126;
  assign toSInt_126 = 0;
  wire [33-1:0] toSInt_imm_127;
  wire [37-1:0] truncval_128;
  assign truncval_128 = 38'd137438953472 / tau;
  assign toSInt_imm_127 = { toSInt_126, truncval_128[31:0] };
  assign padr_124 = { toSInt_imm_127, padr_bits_125 };
  assign padl_bits_123 = padr_124;
  assign padl_122 = { { 39{ padl_bits_123[37] } }, padl_bits_123 };
  assign truncval_115 = padl_116 * padl_122;
  assign truncR_114 = truncval_115[44:0];
  assign truncR_113 = truncR_114[44:10];
  assign padl_bits_112 = truncR_113[34:26];
  assign padl_111 = { { 26{ padl_bits_112[8] } }, padl_bits_112 };
  assign dvdt = padl_111;
  wire [34-1:0] padr_129;
  wire [26-1:0] padr_bits_130;
  assign padr_bits_130 = 0;
  wire [14-1:0] truncR_131;
  wire [14-1:0] padl_132;
  wire [12-1:0] padl_bits_133;
  wire [64-1:0] truncR_134;
  wire [133-1:0] truncval_135;
  wire [133-1:0] padl_136;
  wire [79-1:0] padl_bits_137;
  wire [79-1:0] padl_138;
  wire [45-1:0] padl_bits_139;
  wire [1-1:0] toSInt_140;
  assign toSInt_140 = 0;
  wire [45-1:0] toSInt_imm_141;
  wire [44-1:0] const_142;
  assign const_142 = 175;
  assign toSInt_imm_141 = { toSInt_140, const_142 };
  assign padl_bits_139 = toSInt_imm_141;
  assign padl_138 = { { 34{ padl_bits_139[44] } }, padl_bits_139 };
  assign padl_bits_137 = padl_138;
  assign padl_136 = { { 54{ padl_bits_137[78] } }, padl_bits_137 };
  wire [133-1:0] padl_143;
  wire [79-1:0] padl_bits_144;
  wire [79-1:0] padr_145;
  wire [44-1:0] padr_bits_146;
  assign padr_bits_146 = 0;
  assign padr_145 = { dvdt, padr_bits_146 };
  assign padl_bits_144 = padr_145;
  assign padl_143 = { { 54{ padl_bits_144[78] } }, padl_bits_144 };
  assign truncval_135 = padl_136 * padl_143;
  assign truncR_134 = truncval_135[63:0];
  assign padl_bits_133 = truncR_134[63:52];
  assign padl_132 = { { 2{ padl_bits_133[11] } }, padl_bits_133 };
  assign truncR_131 = padl_132;
  assign padr_129 = { truncR_131[13:6], padr_bits_130 };
  wire [61-1:0] truncR_147;
  wire [131-1:0] truncval_148;
  wire [131-1:0] padl_149;
  wire [80-1:0] padl_bits_150;
  wire [80-1:0] padl_151;
  wire [45-1:0] padl_bits_152;
  wire [45-1:0] padr_153;
  wire [1-1:0] padr_bits_154;
  assign padr_bits_154 = 0;
  wire [44-1:0] padr_155;
  wire [1-1:0] padr_bits_156;
  assign padr_bits_156 = 0;
  wire [94-1:0] truncR_157;
  wire [101-1:0] truncval_158;
  wire [101-1:0] padl_159;
  wire [50-1:0] padl_bits_160;
  wire [50-1:0] padr_161;
  wire [39-1:0] padr_bits_162;
  assign padr_bits_162 = 0;
  assign padr_161 = { VREF, padr_bits_162 };
  assign padl_bits_160 = padr_161;
  assign padl_159 = { { 51{ padl_bits_160[49] } }, padl_bits_160 };
  wire [101-1:0] padl_163;
  wire [50-1:0] padl_bits_164;
  wire [50-1:0] padl_165;
  wire [48-1:0] padl_bits_166;
  wire [48-1:0] param_167;
  assign param_167 = VREF_to_response_time_lh;
  assign padl_bits_166 = param_167;
  assign padl_165 = { { 2{ padl_bits_166[47] } }, padl_bits_166 };
  assign padl_bits_164 = padl_165;
  assign padl_163 = { { 51{ padl_bits_164[49] } }, padl_bits_164 };
  assign truncval_158 = padl_159 * padl_163;
  assign truncR_157 = truncval_158[93:0];
  assign padr_155 = { truncR_157[93:51], padr_bits_156 };
  wire [98-1:0] truncR_168;
  wire [105-1:0] truncval_169;
  wire [105-1:0] padl_170;
  wire [52-1:0] padl_bits_171;
  wire [52-1:0] padr_172;
  wire [41-1:0] padr_bits_173;
  assign padr_bits_173 = 0;
  assign padr_172 = { VREG, padr_bits_173 };
  assign padl_bits_171 = padr_172;
  assign padl_170 = { { 53{ padl_bits_171[51] } }, padl_bits_171 };
  wire [105-1:0] padl_174;
  wire [52-1:0] padl_bits_175;
  wire [52-1:0] padl_176;
  wire [50-1:0] padl_bits_177;
  wire [50-1:0] param_178;
  assign param_178 = VREG_to_response_time_lh;
  assign padl_bits_177 = param_178;
  assign padl_176 = { { 2{ padl_bits_177[49] } }, padl_bits_177 };
  assign padl_bits_175 = padl_176;
  assign padl_174 = { { 53{ padl_bits_175[51] } }, padl_bits_175 };
  assign truncval_169 = padl_170 * padl_174;
  assign truncR_168 = truncval_169[97:0];
  assign padr_153 = { padr_155 + truncR_168[97:54], padr_bits_154 };
  wire [45-1:0] padl_179;
  wire [44-1:0] padl_bits_180;
  wire [1-1:0] toSInt_181;
  assign toSInt_181 = 0;
  wire [44-1:0] toSInt_imm_182;
  wire [43-1:0] param_183;
  assign param_183 = const_response_time_lh;
  assign toSInt_imm_182 = { toSInt_181, param_183 };
  assign padl_bits_180 = toSInt_imm_182;
  assign padl_179 = { { 1{ padl_bits_180[43] } }, padl_bits_180 };
  assign padl_bits_152 = padr_153 + padl_179;
  assign padl_151 = { { 35{ padl_bits_152[44] } }, padl_bits_152 };
  assign padl_bits_150 = padl_151;
  assign padl_149 = { { 51{ padl_bits_150[79] } }, padl_bits_150 };
  wire [131-1:0] padl_184;
  wire [80-1:0] padl_bits_185;
  wire [80-1:0] padr_186;
  wire [43-1:0] padr_bits_187;
  assign padr_bits_187 = 0;
  wire [1-1:0] toSInt_188;
  assign toSInt_188 = 0;
  wire [37-1:0] toSInt_imm_189;
  wire [36-1:0] const_190;
  assign const_190 = 186;
  assign toSInt_imm_189 = { toSInt_188, const_190 };
  assign padr_186 = { toSInt_imm_189, padr_bits_187 };
  assign padl_bits_185 = padr_186;
  assign padl_184 = { { 51{ padl_bits_185[79] } }, padl_bits_185 };
  assign truncval_148 = padl_149 * padl_184;
  assign truncR_147 = truncval_148[60:0];
  assign wait_time_lh = truncR_147[60:53];
  wire [34-1:0] padl_191;
  wire [30-1:0] padl_bits_192;
  wire [30-1:0] padr_193;
  wire [13-1:0] padr_bits_194;
  assign padr_bits_194 = 0;
  wire [17-1:0] const_195;
  assign const_195 = 131;
  assign padr_193 = { const_195, padr_bits_194 };
  assign padl_bits_192 = padr_193;
  wire [4-1:0] padl_bits_zero_196;
  assign padl_bits_zero_196 = 0;
  assign padl_191 = { padl_bits_zero_196, padl_bits_192 };
  wire [31-1:0] truncR_197;
  wire [31-1:0] padl_198;
  wire [29-1:0] padl_bits_199;
  wire [29-1:0] padr_200;
  wire [6-1:0] padr_bits_201;
  assign padr_bits_201 = 0;
  wire [27-1:0] truncval_202;
  wire [34-1:0] truncR_203;
  assign truncR_203 = o;
  assign truncval_202 = truncR_203[33:7];
  assign padr_200 = { truncval_202[22:0], padr_bits_201 };
  assign padl_bits_199 = padr_200;
  assign padl_198 = { { 2{ padl_bits_199[28] } }, padl_bits_199 };
  assign truncR_197 = padl_198;
  wire [43-1:0] truncR_204;
  wire [44-1:0] truncval_205;
  wire [45-1:0] toUsInt_206;
  wire [45-1:0] padr_207;
  wire [1-1:0] padr_bits_208;
  assign padr_bits_208 = 0;
  wire [96-1:0] truncR_209;
  wire [103-1:0] truncval_210;
  wire [103-1:0] padl_211;
  wire [51-1:0] padl_bits_212;
  wire [51-1:0] padr_213;
  wire [40-1:0] padr_bits_214;
  assign padr_bits_214 = 0;
  assign padr_213 = { VREF, padr_bits_214 };
  assign padl_bits_212 = padr_213;
  assign padl_211 = { { 52{ padl_bits_212[50] } }, padl_bits_212 };
  wire [103-1:0] padl_215;
  wire [51-1:0] padl_bits_216;
  wire [51-1:0] padl_217;
  wire [49-1:0] padl_bits_218;
  wire [49-1:0] param_219;
  assign param_219 = VREF_to_tau_lh;
  assign padl_bits_218 = param_219;
  assign padl_217 = { { 2{ padl_bits_218[48] } }, padl_bits_218 };
  assign padl_bits_216 = padl_217;
  assign padl_215 = { { 52{ padl_bits_216[50] } }, padl_bits_216 };
  assign truncval_210 = padl_211 * padl_215;
  assign truncR_209 = truncval_210[95:0];
  wire [44-1:0] padr_220;
  wire [3-1:0] padr_bits_221;
  assign padr_bits_221 = 0;
  wire [90-1:0] truncR_222;
  wire [97-1:0] truncval_223;
  wire [97-1:0] padl_224;
  wire [48-1:0] padl_bits_225;
  wire [48-1:0] padr_226;
  wire [37-1:0] padr_bits_227;
  assign padr_bits_227 = 0;
  assign padr_226 = { VREG, padr_bits_227 };
  assign padl_bits_225 = padr_226;
  assign padl_224 = { { 49{ padl_bits_225[47] } }, padl_bits_225 };
  wire [97-1:0] padl_228;
  wire [48-1:0] padl_bits_229;
  wire [48-1:0] padl_230;
  wire [45-1:0] padl_bits_231;
  wire [1-1:0] toSInt_232;
  assign toSInt_232 = 0;
  wire [45-1:0] toSInt_imm_233;
  wire [44-1:0] param_234;
  assign param_234 = VREG_to_tau_lh;
  assign toSInt_imm_233 = { toSInt_232, param_234 };
  assign padl_bits_231 = toSInt_imm_233;
  assign padl_230 = { { 3{ padl_bits_231[44] } }, padl_bits_231 };
  assign padl_bits_229 = padl_230;
  assign padl_228 = { { 49{ padl_bits_229[47] } }, padl_bits_229 };
  assign truncval_223 = padl_224 * padl_228;
  assign truncR_222 = truncval_223[89:0];
  assign padr_220 = { truncR_222[89:49], padr_bits_221 };
  assign padr_207 = { truncR_209[95:52] + padr_220, padr_bits_208 };
  wire [45-1:0] padl_235;
  wire [44-1:0] padl_bits_236;
  wire [1-1:0] toSInt_237;
  assign toSInt_237 = 0;
  wire [44-1:0] toSInt_imm_238;
  wire [43-1:0] param_239;
  assign param_239 = const_tau_lh;
  assign toSInt_imm_238 = { toSInt_237, param_239 };
  assign padl_bits_236 = toSInt_imm_238;
  assign padl_235 = { { 1{ padl_bits_236[43] } }, padl_bits_236 };
  assign toUsInt_206 = padr_207 + padl_235;
  assign truncval_205 = toUsInt_206[41:0];
  assign truncR_204 = truncval_205[42:0];
  assign tau_lh = truncR_204[42:4];
  wire [27-1:0] truncval_240;
  wire [27-1:0] padr_241;
  wire [18-1:0] padr_bits_242;
  assign padr_bits_242 = 0;
  wire [34-1:0] truncR_243;
  assign truncR_243 = o;
  assign padr_241 = { truncR_243[33:25], padr_bits_242 };
  assign truncval_240 = padr_241;
  wire [36-1:0] padl_244;
  wire [9-1:0] padl_bits_245;
  wire [36-1:0] truncR_246;
  wire [96-1:0] truncR_247;
  wire [129-1:0] truncval_248;
  wire [129-1:0] padl_249;
  wire [64-1:0] padl_bits_250;
  wire [64-1:0] padl_251;
  wire [34-1:0] padl_bits_252;
  wire [34-1:0] padr_253;
  wire [25-1:0] padr_bits_254;
  assign padr_bits_254 = 0;
  wire [9-1:0] padl_255;
  wire [8-1:0] padl_bits_256;
  wire [1-1:0] toSInt_257;
  assign toSInt_257 = 0;
  wire [8-1:0] toSInt_imm_258;
  wire [7-1:0] const_259;
  assign const_259 = 105;
  assign toSInt_imm_258 = { toSInt_257, const_259 };
  assign padl_bits_256 = toSInt_imm_258;
  assign padl_255 = { { 1{ padl_bits_256[7] } }, padl_bits_256 };
  assign padr_253 = { padl_255, padr_bits_254 };
  assign padl_bits_252 = padr_253 - o;
  assign padl_251 = { { 30{ padl_bits_252[33] } }, padl_bits_252 };
  assign padl_bits_250 = padl_251;
  assign padl_249 = { { 65{ padl_bits_250[63] } }, padl_bits_250 };
  wire [129-1:0] padl_260;
  wire [64-1:0] padl_bits_261;
  wire [64-1:0] padr_262;
  wire [30-1:0] padr_bits_263;
  assign padr_bits_263 = 0;
  wire [1-1:0] toSInt_264;
  assign toSInt_264 = 0;
  wire [34-1:0] toSInt_imm_265;
  wire [39-1:0] truncval_266;
  assign truncval_266 = 40'd549755813888 / tau_lh;
  assign toSInt_imm_265 = { toSInt_264, truncval_266[32:0] };
  assign padr_262 = { toSInt_imm_265, padr_bits_263 };
  assign padl_bits_261 = padr_262;
  assign padl_260 = { { 65{ padl_bits_261[63] } }, padl_bits_261 };
  assign truncval_248 = padl_249 * padl_260;
  assign truncR_247 = truncval_248[95:0];
  assign truncR_246 = truncR_247[95:60];
  assign padl_bits_245 = truncR_246[35:27];
  assign padl_244 = { { 27{ padl_bits_245[8] } }, padl_bits_245 };
  assign dodt = padl_244;
  wire [34-1:0] padr_267;
  wire [21-1:0] padr_bits_268;
  assign padr_bits_268 = 0;
  wire [13-1:0] padl_269;
  wire [11-1:0] padl_bits_270;
  wire [63-1:0] truncR_271;
  wire [134-1:0] truncval_272;
  wire [134-1:0] padl_273;
  wire [80-1:0] padl_bits_274;
  wire [80-1:0] padl_275;
  wire [45-1:0] padl_bits_276;
  wire [1-1:0] toSInt_277;
  assign toSInt_277 = 0;
  wire [45-1:0] toSInt_imm_278;
  wire [44-1:0] const_279;
  assign const_279 = 175;
  assign toSInt_imm_278 = { toSInt_277, const_279 };
  assign padl_bits_276 = toSInt_imm_278;
  assign padl_275 = { { 35{ padl_bits_276[44] } }, padl_bits_276 };
  assign padl_bits_274 = padl_275;
  assign padl_273 = { { 54{ padl_bits_274[79] } }, padl_bits_274 };
  wire [134-1:0] padl_280;
  wire [80-1:0] padl_bits_281;
  wire [80-1:0] padr_282;
  wire [44-1:0] padr_bits_283;
  assign padr_bits_283 = 0;
  assign padr_282 = { dodt, padr_bits_283 };
  assign padl_bits_281 = padr_282;
  assign padl_280 = { { 54{ padl_bits_281[79] } }, padl_bits_281 };
  assign truncval_272 = padl_273 * padl_280;
  assign truncR_271 = truncval_272[62:0];
  assign padl_bits_270 = truncR_271[62:52];
  assign padl_269 = { { 2{ padl_bits_270[10] } }, padl_bits_270 };
  assign padr_267 = { padl_269, padr_bits_268 };

  always @(posedge clk) begin
    prev_sys_clk <= sys_clk;
  end

  localparam fsm_1 = 1;
  localparam fsm_2 = 2;
  localparam fsm_3 = 3;
  localparam fsm_4 = 4;

  always @(posedge clk) begin
    if(reset) begin
      fsm <= fsm_init;
    end else begin
      case(fsm)
        fsm_init: begin
          if(reset) begin
            o <= 3543348019;
          end else begin
            o <= padl_0;
          end
          if(~prev_sys_clk & sys_clk & ((VREF > 11'd204) & (VREF <= 11'd1024))) begin
            fsm <= fsm_1;
          end 
        end
        fsm_1: begin
          if(reset) begin
            o <= 3543348019;
          end else begin
            o <= padl_57;
          end
          if(state_cycle_counter > wait_time) begin
            state_cycle_counter <= 0;
          end else begin
            state_cycle_counter <= state_cycle_counter + 1;
          end
          if(state_cycle_counter > wait_time) begin
            fsm <= fsm_2;
          end 
        end
        fsm_2: begin
          if(reset) begin
            o <= 3543348019;
          end else begin
            o <= o + padr_129;
          end
          if(prev_sys_clk & ~sys_clk) begin
            fsm <= fsm_3;
          end 
        end
        fsm_3: begin
          if(reset) begin
            o <= 3543348019;
          end else begin
            o <= padl_191;
          end
          if(state_cycle_counter > wait_time_lh) begin
            state_cycle_counter <= 0;
          end else begin
            state_cycle_counter <= state_cycle_counter + 1;
          end
          if(state_cycle_counter > wait_time_lh) begin
            fsm <= fsm_4;
          end 
        end
        fsm_4: begin
          if(reset) begin
            o <= 3543348019;
          end else begin
            o <= o + padr_267;
          end
          if((o > 34'd3532610600) & (o <= 34'd8589934592)) begin
            fsm <= fsm_init;
          end 
        end
      endcase
    end
  end


endmodule

