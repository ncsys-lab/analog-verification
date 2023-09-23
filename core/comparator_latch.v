

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
  input [9-1:0] VREF,
  input [9-1:0] VREG,
  output [7-1:0] out
);

  reg [32-1:0] o;
  wire [41-1:0] wait_time;
  wire [38-1:0] tau;
  wire [35-1:0] dvdt;
  wire [41-1:0] wait_time_lh;
  wire [39-1:0] tau_lh;
  wire [36-1:0] dodt;
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  wire [7-1:0] const_0;
  assign const_0 = 105;
  wire [13-1:0] padr_1;
  wire [6-1:0] padr_bits_2;
  assign padr_bits_2 = 0;
  assign padr_1 = { o, padr_bits_2 };
  wire [43-1:0] truncR_3;
  wire [44-1:0] truncval_4;
  wire [45-1:0] toUsInt_5;
  wire [45-1:0] padr_6;
  wire [2-1:0] padr_bits_7;
  assign padr_bits_7 = 0;
  wire [94-1:0] truncR_8;
  wire [99-1:0] truncval_9;
  wire [99-1:0] padl_10;
  wire [49-1:0] padl_bits_11;
  wire [49-1:0] padr_12;
  wire [39-1:0] padr_bits_13;
  assign padr_bits_13 = 0;
  wire [1-1:0] toSInt_14;
  assign toSInt_14 = 0;
  wire [10-1:0] toSInt_imm_15;
  assign toSInt_imm_15 = { toSInt_14, VREF };
  assign padr_12 = { toSInt_imm_15, padr_bits_13 };
  assign padl_bits_11 = padr_12;
  assign padl_10 = { { 50{ padl_bits_11[48] } }, padl_bits_11 };
  wire [99-1:0] padl_16;
  wire [49-1:0] padl_bits_17;
  wire [49-1:0] padl_18;
  wire [48-1:0] padl_bits_19;
  wire [48-1:0] param_20;
  assign param_20 = VREF_to_response_time;
  assign padl_bits_19 = param_20;
  assign padl_18 = { { 1{ padl_bits_19[47] } }, padl_bits_19 };
  assign padl_bits_17 = padl_18;
  assign padl_16 = { { 50{ padl_bits_17[48] } }, padl_bits_17 };
  assign truncval_9 = padl_10 * padl_16;
  assign truncR_8 = truncval_9[93:0];
  assign padr_6 = { truncR_8[93:51], padr_bits_7 };
  wire [98-1:0] truncR_21;
  wire [103-1:0] truncval_22;
  wire [103-1:0] padl_23;
  wire [51-1:0] padl_bits_24;
  wire [51-1:0] padr_25;
  wire [41-1:0] padr_bits_26;
  assign padr_bits_26 = 0;
  wire [1-1:0] toSInt_27;
  assign toSInt_27 = 0;
  wire [10-1:0] toSInt_imm_28;
  assign toSInt_imm_28 = { toSInt_27, VREG };
  assign padr_25 = { toSInt_imm_28, padr_bits_26 };
  assign padl_bits_24 = padr_25;
  assign padl_23 = { { 52{ padl_bits_24[50] } }, padl_bits_24 };
  wire [103-1:0] padl_29;
  wire [51-1:0] padl_bits_30;
  wire [51-1:0] padl_31;
  wire [50-1:0] padl_bits_32;
  wire [50-1:0] param_33;
  assign param_33 = VREG_to_response_time;
  assign padl_bits_32 = param_33;
  assign padl_31 = { { 1{ padl_bits_32[49] } }, padl_bits_32 };
  assign padl_bits_30 = padl_31;
  assign padl_29 = { { 52{ padl_bits_30[50] } }, padl_bits_30 };
  assign truncval_22 = padl_23 * padl_29;
  assign truncR_21 = truncval_22[97:0];
  wire [45-1:0] padr_34;
  wire [1-1:0] padr_bits_35;
  assign padr_bits_35 = 0;
  wire [44-1:0] padl_36;
  wire [43-1:0] padl_bits_37;
  wire [1-1:0] toSInt_38;
  assign toSInt_38 = 0;
  wire [43-1:0] toSInt_imm_39;
  wire [42-1:0] param_40;
  assign param_40 = const_response_time;
  assign toSInt_imm_39 = { toSInt_38, param_40 };
  assign padl_bits_37 = toSInt_imm_39;
  assign padl_36 = { { 1{ padl_bits_37[42] } }, padl_bits_37 };
  assign padr_34 = { padl_36, padr_bits_35 };
  assign toUsInt_5 = padr_6 + truncR_21[97:53] + padr_34;
  assign truncval_4 = toUsInt_5[41:0];
  assign truncR_3 = truncval_4[42:0];
  wire [7-1:0] const_41;
  assign const_41 = 105;
  wire [13-1:0] padr_42;
  wire [6-1:0] padr_bits_43;
  assign padr_bits_43 = 0;
  assign padr_42 = { o, padr_bits_43 };
  wire [41-1:0] truncR_44;
  wire [42-1:0] truncval_45;
  wire [43-1:0] toUsInt_46;
  wire [43-1:0] padr_47;
  wire [3-1:0] padr_bits_48;
  assign padr_bits_48 = 0;
  wire [40-1:0] padl_49;
  wire [39-1:0] padl_bits_50;
  wire [1-1:0] toSInt_51;
  assign toSInt_51 = 0;
  wire [39-1:0] toSInt_imm_52;
  wire [86-1:0] truncR_53;
  wire [90-1:0] truncval_54;
  wire [90-1:0] padl_55;
  wire [45-1:0] padl_bits_56;
  wire [45-1:0] padr_57;
  wire [36-1:0] padr_bits_58;
  assign padr_bits_58 = 0;
  assign padr_57 = { VREF, padr_bits_58 };
  assign padl_bits_56 = padr_57;
  wire [45-1:0] padl_bits_zero_59;
  assign padl_bits_zero_59 = 0;
  assign padl_55 = { padl_bits_zero_59, padl_bits_56 };
  wire [90-1:0] padl_60;
  wire [45-1:0] padl_bits_61;
  wire [45-1:0] padl_62;
  wire [43-1:0] padl_bits_63;
  wire [43-1:0] param_64;
  assign param_64 = VREF_to_tau;
  assign padl_bits_63 = param_64;
  wire [2-1:0] padl_bits_zero_65;
  assign padl_bits_zero_65 = 0;
  assign padl_62 = { padl_bits_zero_65, padl_bits_63 };
  assign padl_bits_61 = padl_62;
  wire [45-1:0] padl_bits_zero_66;
  assign padl_bits_zero_66 = 0;
  assign padl_60 = { padl_bits_zero_66, padl_bits_61 };
  assign truncval_54 = padl_55 * padl_60;
  assign truncR_53 = truncval_54[85:0];
  assign toSInt_imm_52 = { toSInt_51, truncR_53[85:48] };
  assign padl_bits_50 = toSInt_imm_52;
  assign padl_49 = { { 1{ padl_bits_50[38] } }, padl_bits_50 };
  wire [88-1:0] truncR_67;
  wire [93-1:0] truncval_68;
  wire [93-1:0] padl_69;
  wire [46-1:0] padl_bits_70;
  wire [46-1:0] padr_71;
  wire [36-1:0] padr_bits_72;
  assign padr_bits_72 = 0;
  wire [1-1:0] toSInt_73;
  assign toSInt_73 = 0;
  wire [10-1:0] toSInt_imm_74;
  assign toSInt_imm_74 = { toSInt_73, VREG };
  assign padr_71 = { toSInt_imm_74, padr_bits_72 };
  assign padl_bits_70 = padr_71;
  assign padl_69 = { { 47{ padl_bits_70[45] } }, padl_bits_70 };
  wire [93-1:0] padl_75;
  wire [46-1:0] padl_bits_76;
  wire [46-1:0] padl_77;
  wire [45-1:0] padl_bits_78;
  wire [45-1:0] param_79;
  assign param_79 = VREG_to_tau;
  assign padl_bits_78 = param_79;
  assign padl_77 = { { 1{ padl_bits_78[44] } }, padl_bits_78 };
  assign padl_bits_76 = padl_77;
  assign padl_75 = { { 47{ padl_bits_76[45] } }, padl_bits_76 };
  assign truncval_68 = padl_69 * padl_75;
  assign truncR_67 = truncval_68[87:0];
  assign padr_47 = { padl_49 + truncR_67[87:48], padr_bits_48 };
  wire [43-1:0] padl_80;
  wire [42-1:0] padl_bits_81;
  wire [1-1:0] toSInt_82;
  assign toSInt_82 = 0;
  wire [42-1:0] toSInt_imm_83;
  wire [41-1:0] param_84;
  assign param_84 = const_tau;
  assign toSInt_imm_83 = { toSInt_82, param_84 };
  assign padl_bits_81 = toSInt_imm_83;
  assign padl_80 = { { 1{ padl_bits_81[41] } }, padl_bits_81 };
  assign toUsInt_46 = padr_47 + padl_80;
  assign truncval_45 = toUsInt_46[39:0];
  assign truncR_44 = truncval_45[40:0];
  wire [7-1:0] padr_85;
  wire [1-1:0] padr_bits_86;
  assign padr_bits_86 = 0;
  assign padr_85 = { o, padr_bits_86 };
  wire [35-1:0] padl_87;
  wire [9-1:0] padl_bits_88;
  wire [35-1:0] truncR_89;
  wire [45-1:0] truncR_90;
  wire [75-1:0] truncval_91;
  wire [75-1:0] padl_92;
  wire [37-1:0] padl_bits_93;
  wire [37-1:0] padl_94;
  wire [9-1:0] padl_bits_95;
  wire [9-1:0] neg_imm_96;
  wire [1-1:0] toSInt_97;
  assign toSInt_97 = 0;
  wire [7-1:0] toSInt_imm_98;
  assign toSInt_imm_98 = { toSInt_97, o };
  assign neg_imm_96 = -toSInt_imm_98;
  assign padl_bits_95 = neg_imm_96;
  assign padl_94 = { { 28{ padl_bits_95[8] } }, padl_bits_95 };
  assign padl_bits_93 = padl_94;
  assign padl_92 = { { 38{ padl_bits_93[36] } }, padl_bits_93 };
  wire [75-1:0] padl_99;
  wire [37-1:0] padl_bits_100;
  wire [37-1:0] padr_101;
  wire [5-1:0] padr_bits_102;
  assign padr_bits_102 = 0;
  wire [1-1:0] toSInt_103;
  assign toSInt_103 = 0;
  wire [32-1:0] toSInt_imm_104;
  wire [38-1:0] truncval_105;
  assign truncval_105 = 39'd274877906944 / tau;
  assign toSInt_imm_104 = { toSInt_103, truncval_105[30:0] };
  assign padr_101 = { toSInt_imm_104, padr_bits_102 };
  assign padl_bits_100 = padr_101;
  assign padl_99 = { { 38{ padl_bits_100[36] } }, padl_bits_100 };
  assign truncval_91 = padl_92 * padl_99;
  assign truncR_90 = truncval_91[44:0];
  assign truncR_89 = truncR_90[44:10];
  assign padl_bits_88 = truncR_89[34:26];
  assign padl_87 = { { 26{ padl_bits_88[8] } }, padl_bits_88 };
  wire [14-1:0] truncR_106;
  wire [14-1:0] padl_107;
  wire [13-1:0] padl_bits_108;
  wire [14-1:0] toUsInt_109;
  wire [66-1:0] truncR_110;
  wire [135-1:0] truncval_111;
  wire [135-1:0] padl_112;
  wire [80-1:0] padl_bits_113;
  wire [80-1:0] padl_114;
  wire [46-1:0] padl_bits_115;
  wire [1-1:0] toSInt_116;
  assign toSInt_116 = 0;
  wire [46-1:0] toSInt_imm_117;
  wire [45-1:0] const_118;
  assign const_118 = 175;
  assign toSInt_imm_117 = { toSInt_116, const_118 };
  assign padl_bits_115 = toSInt_imm_117;
  assign padl_114 = { { 34{ padl_bits_115[45] } }, padl_bits_115 };
  assign padl_bits_113 = padl_114;
  assign padl_112 = { { 55{ padl_bits_113[79] } }, padl_bits_113 };
  wire [135-1:0] padl_119;
  wire [80-1:0] padl_bits_120;
  wire [80-1:0] padr_121;
  wire [45-1:0] padr_bits_122;
  assign padr_bits_122 = 0;
  assign padr_121 = { dvdt, padr_bits_122 };
  assign padl_bits_120 = padr_121;
  assign padl_119 = { { 55{ padl_bits_120[79] } }, padl_bits_120 };
  assign truncval_111 = padl_112 * padl_119;
  assign truncR_110 = truncval_111[65:0];
  assign toUsInt_109 = truncR_110[65:52];
  assign padl_bits_108 = toUsInt_109[10:0];
  wire [1-1:0] padl_bits_zero_123;
  assign padl_bits_zero_123 = 0;
  assign padl_107 = { padl_bits_zero_123, padl_bits_108 };
  assign truncR_106 = padl_107;
  wire [43-1:0] truncR_124;
  wire [44-1:0] truncval_125;
  wire [45-1:0] toUsInt_126;
  wire [45-1:0] padr_127;
  wire [2-1:0] padr_bits_128;
  assign padr_bits_128 = 0;
  wire [94-1:0] truncR_129;
  wire [99-1:0] truncval_130;
  wire [99-1:0] padl_131;
  wire [49-1:0] padl_bits_132;
  wire [49-1:0] padr_133;
  wire [39-1:0] padr_bits_134;
  assign padr_bits_134 = 0;
  wire [1-1:0] toSInt_135;
  assign toSInt_135 = 0;
  wire [10-1:0] toSInt_imm_136;
  assign toSInt_imm_136 = { toSInt_135, VREF };
  assign padr_133 = { toSInt_imm_136, padr_bits_134 };
  assign padl_bits_132 = padr_133;
  assign padl_131 = { { 50{ padl_bits_132[48] } }, padl_bits_132 };
  wire [99-1:0] padl_137;
  wire [49-1:0] padl_bits_138;
  wire [49-1:0] padl_139;
  wire [48-1:0] padl_bits_140;
  wire [48-1:0] param_141;
  assign param_141 = VREF_to_response_time_lh;
  assign padl_bits_140 = param_141;
  assign padl_139 = { { 1{ padl_bits_140[47] } }, padl_bits_140 };
  assign padl_bits_138 = padl_139;
  assign padl_137 = { { 50{ padl_bits_138[48] } }, padl_bits_138 };
  assign truncval_130 = padl_131 * padl_137;
  assign truncR_129 = truncval_130[93:0];
  assign padr_127 = { truncR_129[93:51], padr_bits_128 };
  wire [98-1:0] truncR_142;
  wire [103-1:0] truncval_143;
  wire [103-1:0] padl_144;
  wire [51-1:0] padl_bits_145;
  wire [51-1:0] padr_146;
  wire [41-1:0] padr_bits_147;
  assign padr_bits_147 = 0;
  wire [1-1:0] toSInt_148;
  assign toSInt_148 = 0;
  wire [10-1:0] toSInt_imm_149;
  assign toSInt_imm_149 = { toSInt_148, VREG };
  assign padr_146 = { toSInt_imm_149, padr_bits_147 };
  assign padl_bits_145 = padr_146;
  assign padl_144 = { { 52{ padl_bits_145[50] } }, padl_bits_145 };
  wire [103-1:0] padl_150;
  wire [51-1:0] padl_bits_151;
  wire [51-1:0] padl_152;
  wire [50-1:0] padl_bits_153;
  wire [50-1:0] param_154;
  assign param_154 = VREG_to_response_time_lh;
  assign padl_bits_153 = param_154;
  assign padl_152 = { { 1{ padl_bits_153[49] } }, padl_bits_153 };
  assign padl_bits_151 = padl_152;
  assign padl_150 = { { 52{ padl_bits_151[50] } }, padl_bits_151 };
  assign truncval_143 = padl_144 * padl_150;
  assign truncR_142 = truncval_143[97:0];
  wire [45-1:0] padl_155;
  wire [44-1:0] padl_bits_156;
  wire [1-1:0] toSInt_157;
  assign toSInt_157 = 0;
  wire [44-1:0] toSInt_imm_158;
  wire [43-1:0] param_159;
  assign param_159 = const_response_time_lh;
  assign toSInt_imm_158 = { toSInt_157, param_159 };
  assign padl_bits_156 = toSInt_imm_158;
  assign padl_155 = { { 1{ padl_bits_156[43] } }, padl_bits_156 };
  assign toUsInt_126 = padr_127 + truncR_142[97:53] + padl_155;
  assign truncval_125 = toUsInt_126[41:0];
  assign truncR_124 = truncval_125[42:0];
  wire [7-1:0] const_160;
  assign const_160 = 105;
  wire [13-1:0] padr_161;
  wire [6-1:0] padr_bits_162;
  assign padr_bits_162 = 0;
  assign padr_161 = { o, padr_bits_162 };
  wire [43-1:0] truncR_163;
  wire [44-1:0] truncval_164;
  wire [45-1:0] toUsInt_165;
  wire [45-1:0] padr_166;
  wire [1-1:0] padr_bits_167;
  assign padr_bits_167 = 0;
  wire [96-1:0] truncR_168;
  wire [101-1:0] truncval_169;
  wire [101-1:0] padl_170;
  wire [50-1:0] padl_bits_171;
  wire [50-1:0] padr_172;
  wire [40-1:0] padr_bits_173;
  assign padr_bits_173 = 0;
  wire [1-1:0] toSInt_174;
  assign toSInt_174 = 0;
  wire [10-1:0] toSInt_imm_175;
  assign toSInt_imm_175 = { toSInt_174, VREF };
  assign padr_172 = { toSInt_imm_175, padr_bits_173 };
  assign padl_bits_171 = padr_172;
  assign padl_170 = { { 51{ padl_bits_171[49] } }, padl_bits_171 };
  wire [101-1:0] padl_176;
  wire [50-1:0] padl_bits_177;
  wire [50-1:0] padl_178;
  wire [49-1:0] padl_bits_179;
  wire [49-1:0] param_180;
  assign param_180 = VREF_to_tau_lh;
  assign padl_bits_179 = param_180;
  assign padl_178 = { { 1{ padl_bits_179[48] } }, padl_bits_179 };
  assign padl_bits_177 = padl_178;
  assign padl_176 = { { 51{ padl_bits_177[49] } }, padl_bits_177 };
  assign truncval_169 = padl_170 * padl_176;
  assign truncR_168 = truncval_169[95:0];
  wire [44-1:0] padr_181;
  wire [3-1:0] padr_bits_182;
  assign padr_bits_182 = 0;
  wire [41-1:0] padl_183;
  wire [40-1:0] padl_bits_184;
  wire [1-1:0] toSInt_185;
  assign toSInt_185 = 0;
  wire [40-1:0] toSInt_imm_186;
  wire [88-1:0] truncR_187;
  wire [92-1:0] truncval_188;
  wire [92-1:0] padl_189;
  wire [46-1:0] padl_bits_190;
  wire [46-1:0] padr_191;
  wire [37-1:0] padr_bits_192;
  assign padr_bits_192 = 0;
  assign padr_191 = { VREG, padr_bits_192 };
  assign padl_bits_190 = padr_191;
  wire [46-1:0] padl_bits_zero_193;
  assign padl_bits_zero_193 = 0;
  assign padl_189 = { padl_bits_zero_193, padl_bits_190 };
  wire [92-1:0] padl_194;
  wire [46-1:0] padl_bits_195;
  wire [46-1:0] padl_196;
  wire [44-1:0] padl_bits_197;
  wire [44-1:0] param_198;
  assign param_198 = VREG_to_tau_lh;
  assign padl_bits_197 = param_198;
  wire [2-1:0] padl_bits_zero_199;
  assign padl_bits_zero_199 = 0;
  assign padl_196 = { padl_bits_zero_199, padl_bits_197 };
  assign padl_bits_195 = padl_196;
  wire [46-1:0] padl_bits_zero_200;
  assign padl_bits_zero_200 = 0;
  assign padl_194 = { padl_bits_zero_200, padl_bits_195 };
  assign truncval_188 = padl_189 * padl_194;
  assign truncR_187 = truncval_188[87:0];
  assign toSInt_imm_186 = { toSInt_185, truncR_187[87:49] };
  assign padl_bits_184 = toSInt_imm_186;
  assign padl_183 = { { 1{ padl_bits_184[39] } }, padl_bits_184 };
  assign padr_181 = { padl_183, padr_bits_182 };
  assign padr_166 = { truncR_168[95:52] + padr_181, padr_bits_167 };
  wire [45-1:0] padl_201;
  wire [44-1:0] padl_bits_202;
  wire [1-1:0] toSInt_203;
  assign toSInt_203 = 0;
  wire [44-1:0] toSInt_imm_204;
  wire [43-1:0] param_205;
  assign param_205 = const_tau_lh;
  assign toSInt_imm_204 = { toSInt_203, param_205 };
  assign padl_bits_202 = toSInt_imm_204;
  assign padl_201 = { { 1{ padl_bits_202[43] } }, padl_bits_202 };
  assign toUsInt_165 = padr_166 + padl_201;
  assign truncval_164 = toUsInt_165[41:0];
  assign truncR_163 = truncval_164[42:0];
  wire [32-1:0] truncR_206;
  assign truncR_206 = o;
  wire [36-1:0] padl_207;
  wire [9-1:0] padl_bits_208;
  wire [36-1:0] truncR_209;
  wire [96-1:0] truncR_210;
  wire [125-1:0] truncval_211;
  wire [125-1:0] padl_212;
  wire [62-1:0] padl_bits_213;
  wire [62-1:0] padl_214;
  wire [32-1:0] padl_bits_215;
  wire [32-1:0] padr_216;
  wire [25-1:0] padr_bits_217;
  assign padr_bits_217 = 0;
  wire [7-1:0] const_218;
  assign const_218 = 105;
  assign padr_216 = { const_218, padr_bits_217 };
  assign padl_bits_215 = padr_216 - o;
  wire [30-1:0] padl_bits_zero_219;
  assign padl_bits_zero_219 = 0;
  assign padl_214 = { padl_bits_zero_219, padl_bits_215 };
  assign padl_bits_213 = padl_214;
  wire [63-1:0] padl_bits_zero_220;
  assign padl_bits_zero_220 = 0;
  assign padl_212 = { padl_bits_zero_220, padl_bits_213 };
  wire [125-1:0] padl_221;
  wire [62-1:0] padl_bits_222;
  wire [62-1:0] padr_223;
  wire [30-1:0] padr_bits_224;
  assign padr_bits_224 = 0;
  wire [39-1:0] truncval_225;
  assign truncval_225 = 40'd549755813888 / tau_lh;
  assign padr_223 = { truncval_225[31:0], padr_bits_224 };
  assign padl_bits_222 = padr_223;
  wire [63-1:0] padl_bits_zero_226;
  assign padl_bits_zero_226 = 0;
  assign padl_221 = { padl_bits_zero_226, padl_bits_222 };
  assign truncval_211 = padl_212 * padl_221;
  assign truncR_210 = truncval_211[95:0];
  assign truncR_209 = truncR_210[95:60];
  assign padl_bits_208 = truncR_209[35:27];
  assign padl_207 = { { 27{ padl_bits_208[8] } }, padl_bits_208 };
  wire [32-1:0] padr_227;
  wire [19-1:0] padr_bits_228;
  assign padr_bits_228 = 0;
  wire [13-1:0] padl_229;
  wire [12-1:0] padl_bits_230;
  wire [13-1:0] toUsInt_231;
  wire [65-1:0] truncR_232;
  wire [136-1:0] truncval_233;
  wire [136-1:0] padl_234;
  wire [81-1:0] padl_bits_235;
  wire [81-1:0] padl_236;
  wire [46-1:0] padl_bits_237;
  wire [1-1:0] toSInt_238;
  assign toSInt_238 = 0;
  wire [46-1:0] toSInt_imm_239;
  wire [45-1:0] const_240;
  assign const_240 = 175;
  assign toSInt_imm_239 = { toSInt_238, const_240 };
  assign padl_bits_237 = toSInt_imm_239;
  assign padl_236 = { { 35{ padl_bits_237[45] } }, padl_bits_237 };
  assign padl_bits_235 = padl_236;
  assign padl_234 = { { 55{ padl_bits_235[80] } }, padl_bits_235 };
  wire [136-1:0] padl_241;
  wire [81-1:0] padl_bits_242;
  wire [81-1:0] padr_243;
  wire [45-1:0] padr_bits_244;
  assign padr_bits_244 = 0;
  assign padr_243 = { dodt, padr_bits_244 };
  assign padl_bits_242 = padr_243;
  assign padl_241 = { { 55{ padl_bits_242[80] } }, padl_bits_242 };
  assign truncval_233 = padl_234 * padl_241;
  assign truncR_232 = truncval_233[64:0];
  assign toUsInt_231 = truncR_232[64:52];
  assign padl_bits_230 = toUsInt_231[9:0];
  wire [1-1:0] padl_bits_zero_245;
  assign padl_bits_zero_245 = 0;
  assign padl_229 = { padl_bits_zero_245, padl_bits_230 };
  assign padr_227 = { padl_229, padr_bits_228 };
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
            o <= 0;
          end else begin
            o <= const_0;
          end
          out <= padr_1;
          fsm <= fsm_1;
        end
        fsm_1: begin
          wait_time <= truncR_3[42:2];
          if(reset) begin
            o <= 0;
          end else begin
            o <= const_41;
          end
          out <= padr_42;
          fsm <= fsm_2;
        end
        fsm_2: begin
          tau <= truncR_44[40:3];
          out <= padr_85;
          dvdt <= padl_87;
          if(reset) begin
            o <= 0;
          end else begin
            o <= o + truncR_106[13:8];
          end
          fsm <= fsm_3;
        end
        fsm_3: begin
          wait_time_lh <= truncR_124[42:2];
          if(reset) begin
            o <= 0;
          end else begin
            o <= const_160;
          end
          out <= padr_161;
          fsm <= fsm_4;
        end
        fsm_4: begin
          tau_lh <= truncR_163[42:4];
          out <= truncR_206[31:25];
          dodt <= padl_207;
          if(reset) begin
            o <= 0;
          end else begin
            o <= o + padr_227;
          end
          fsm <= fsm_init;
        end
      endcase
    end
  end


endmodule

