

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
  input [15-1:0] VREF,
  input [15-1:0] VREG,
  output [39-1:0] out
);

  reg [17-1:0] state_cycle_counter;
  reg [1-1:0] prev_sys_clk;
  reg [39-1:0] o;
  wire [32-1:0] wait_time;
  wire [44-1:0] tau;
  wire [36-1:0] dvdt;
  wire [16-1:0] wait_time_lh;
  wire [46-1:0] tau_lh;
  wire [38-1:0] dodt;
  reg [32-1:0] fsm;
  localparam fsm_init = 0;
  wire [39-1:0] padr_0;
  wire [12-1:0] padr_bits_1;
  assign padr_bits_1 = 0;
  wire [27-1:0] const_2;
  assign const_2 = 55364812;
  assign padr_0 = { const_2, padr_bits_1 };
  assign out = o;
  wire [32-1:0] padl_3;
  wire [3-1:0] padl_bits_4;
  wire [17-1:0] truncR_5;
  wire [96-1:0] truncR_6;
  wire [163-1:0] truncval_7;
  wire [163-1:0] padl_8;
  wire [85-1:0] padl_bits_9;
  wire [85-1:0] padl_10;
  wire [52-1:0] padl_bits_11;
  wire [52-1:0] padr_12;
  wire [2-1:0] padr_bits_13;
  assign padr_bits_13 = 0;
  wire [94-1:0] truncR_14;
  wire [103-1:0] truncval_15;
  wire [103-1:0] padl_16;
  wire [51-1:0] padl_bits_17;
  wire [51-1:0] padr_18;
  wire [36-1:0] padr_bits_19;
  assign padr_bits_19 = 0;
  assign padr_18 = { VREF, padr_bits_19 };
  assign padl_bits_17 = padr_18;
  assign padl_16 = { { 52{ padl_bits_17[50] } }, padl_bits_17 };
  wire [103-1:0] padl_20;
  wire [51-1:0] padl_bits_21;
  wire [51-1:0] padl_22;
  wire [48-1:0] padl_bits_23;
  wire [48-1:0] param_24;
  assign param_24 = VREF_to_response_time;
  assign padl_bits_23 = param_24;
  assign padl_22 = { { 3{ padl_bits_23[47] } }, padl_bits_23 };
  assign padl_bits_21 = padl_22;
  assign padl_20 = { { 52{ padl_bits_21[50] } }, padl_bits_21 };
  assign truncval_15 = padl_16 * padl_20;
  assign truncR_14 = truncval_15[93:0];
  wire [50-1:0] truncR_shift_25;
  assign truncR_shift_25 = truncR_14 >>> 44;
  wire [50-1:0] truncR_imm_26;
  assign truncR_imm_26 = (truncR_14[93])? truncR_shift_25[49:0] : truncR_14[93:44];
  assign padr_12 = { truncR_imm_26, padr_bits_13 };
  wire [98-1:0] truncR_27;
  wire [107-1:0] truncval_28;
  wire [107-1:0] padl_29;
  wire [53-1:0] padl_bits_30;
  wire [53-1:0] padr_31;
  wire [38-1:0] padr_bits_32;
  assign padr_bits_32 = 0;
  assign padr_31 = { VREG, padr_bits_32 };
  assign padl_bits_30 = padr_31;
  assign padl_29 = { { 54{ padl_bits_30[52] } }, padl_bits_30 };
  wire [107-1:0] padl_33;
  wire [53-1:0] padl_bits_34;
  wire [53-1:0] padl_35;
  wire [50-1:0] padl_bits_36;
  wire [50-1:0] param_37;
  assign param_37 = VREG_to_response_time;
  assign padl_bits_36 = param_37;
  assign padl_35 = { { 3{ padl_bits_36[49] } }, padl_bits_36 };
  assign padl_bits_34 = padl_35;
  assign padl_33 = { { 54{ padl_bits_34[52] } }, padl_bits_34 };
  assign truncval_28 = padl_29 * padl_33;
  assign truncR_27 = truncval_28[97:0];
  wire [52-1:0] truncR_shift_38;
  assign truncR_shift_38 = truncR_27 >>> 46;
  wire [52-1:0] truncR_imm_39;
  assign truncR_imm_39 = (truncR_27[97])? truncR_shift_38[51:0] : truncR_27[97:46];
  wire [52-1:0] padr_40;
  wire [8-1:0] padr_bits_41;
  assign padr_bits_41 = 0;
  wire [44-1:0] padl_42;
  wire [43-1:0] padl_bits_43;
  wire [1-1:0] toSInt_44;
  assign toSInt_44 = 0;
  wire [43-1:0] toSInt_imm_45;
  wire [42-1:0] param_46;
  assign param_46 = const_response_time;
  assign toSInt_imm_45 = { toSInt_44, param_46 };
  assign padl_bits_43 = toSInt_imm_45;
  assign padl_42 = { { 1{ padl_bits_43[42] } }, padl_bits_43 };
  assign padr_40 = { padl_42, padr_bits_41 };
  assign padl_bits_11 = padr_12 + truncR_imm_39 + padr_40;
  assign padl_10 = { { 33{ padl_bits_11[51] } }, padl_bits_11 };
  assign padl_bits_9 = padl_10;
  assign padl_8 = { { 78{ padl_bits_9[84] } }, padl_bits_9 };
  wire [163-1:0] padl_47;
  wire [85-1:0] padl_bits_48;
  wire [85-1:0] padr_49;
  wire [50-1:0] padr_bits_50;
  assign padr_bits_50 = 0;
  wire [1-1:0] toSInt_51;
  assign toSInt_51 = 0;
  wire [35-1:0] toSInt_imm_52;
  wire [34-1:0] const_53;
  assign const_53 = 78125000;
  assign toSInt_imm_52 = { toSInt_51, const_53 };
  assign padr_49 = { toSInt_imm_52, padr_bits_50 };
  assign padl_bits_48 = padr_49;
  assign padl_47 = { { 78{ padl_bits_48[84] } }, padl_bits_48 };
  assign truncval_7 = padl_8 * padl_47;
  assign truncR_6 = truncval_7[95:0];
  assign truncR_5 = truncR_6[95:79];
  assign padl_bits_4 = truncR_5[16:14];
  wire [29-1:0] padl_bits_zero_54;
  assign padl_bits_zero_54 = 0;
  assign padl_3 = { padl_bits_zero_54, padl_bits_4 };
  assign wait_time = padl_3;
  wire [39-1:0] padr_55;
  wire [12-1:0] padr_bits_56;
  assign padr_bits_56 = 0;
  wire [27-1:0] const_57;
  assign const_57 = 55364812;
  assign padr_55 = { const_57, padr_bits_56 };
  wire [45-1:0] truncR_58;
  wire [46-1:0] truncval_59;
  wire [47-1:0] toUsInt_60;
  wire [88-1:0] truncR_61;
  wire [97-1:0] truncval_62;
  wire [97-1:0] padl_63;
  wire [48-1:0] padl_bits_64;
  wire [48-1:0] padr_65;
  wire [33-1:0] padr_bits_66;
  assign padr_bits_66 = 0;
  assign padr_65 = { VREF, padr_bits_66 };
  assign padl_bits_64 = padr_65;
  assign padl_63 = { { 49{ padl_bits_64[47] } }, padl_bits_64 };
  wire [97-1:0] padl_67;
  wire [48-1:0] padl_bits_68;
  wire [48-1:0] padl_69;
  wire [44-1:0] padl_bits_70;
  wire [1-1:0] toSInt_71;
  assign toSInt_71 = 0;
  wire [44-1:0] toSInt_imm_72;
  wire [43-1:0] param_73;
  assign param_73 = VREF_to_tau;
  assign toSInt_imm_72 = { toSInt_71, param_73 };
  assign padl_bits_70 = toSInt_imm_72;
  assign padl_69 = { { 4{ padl_bits_70[43] } }, padl_bits_70 };
  assign padl_bits_68 = padl_69;
  assign padl_67 = { { 49{ padl_bits_68[47] } }, padl_bits_68 };
  assign truncval_62 = padl_63 * padl_67;
  assign truncR_61 = truncval_62[87:0];
  wire [47-1:0] truncR_shift_74;
  assign truncR_shift_74 = truncR_61 >>> 41;
  wire [47-1:0] truncR_imm_75;
  assign truncR_imm_75 = (truncR_61[87])? truncR_shift_74[46:0] : truncR_61[87:41];
  wire [47-1:0] padr_76;
  wire [1-1:0] padr_bits_77;
  assign padr_bits_77 = 0;
  wire [88-1:0] truncR_78;
  wire [97-1:0] truncval_79;
  wire [97-1:0] padl_80;
  wire [48-1:0] padl_bits_81;
  wire [48-1:0] padr_82;
  wire [33-1:0] padr_bits_83;
  assign padr_bits_83 = 0;
  assign padr_82 = { VREG, padr_bits_83 };
  assign padl_bits_81 = padr_82;
  assign padl_80 = { { 49{ padl_bits_81[47] } }, padl_bits_81 };
  wire [97-1:0] padl_84;
  wire [48-1:0] padl_bits_85;
  wire [48-1:0] padl_86;
  wire [45-1:0] padl_bits_87;
  wire [45-1:0] param_88;
  assign param_88 = VREG_to_tau;
  assign padl_bits_87 = param_88;
  assign padl_86 = { { 3{ padl_bits_87[44] } }, padl_bits_87 };
  assign padl_bits_85 = padl_86;
  assign padl_84 = { { 49{ padl_bits_85[47] } }, padl_bits_85 };
  assign truncval_79 = padl_80 * padl_84;
  assign truncR_78 = truncval_79[87:0];
  wire [46-1:0] truncR_shift_89;
  assign truncR_shift_89 = truncR_78 >>> 42;
  wire [46-1:0] truncR_imm_90;
  assign truncR_imm_90 = (truncR_78[87])? truncR_shift_89[45:0] : truncR_78[87:42];
  assign padr_76 = { truncR_imm_90, padr_bits_77 };
  wire [47-1:0] padr_91;
  wire [4-1:0] padr_bits_92;
  assign padr_bits_92 = 0;
  wire [43-1:0] padl_93;
  wire [42-1:0] padl_bits_94;
  wire [1-1:0] toSInt_95;
  assign toSInt_95 = 0;
  wire [42-1:0] toSInt_imm_96;
  wire [41-1:0] param_97;
  assign param_97 = const_tau;
  assign toSInt_imm_96 = { toSInt_95, param_97 };
  assign padl_bits_94 = toSInt_imm_96;
  assign padl_93 = { { 1{ padl_bits_94[41] } }, padl_bits_94 };
  assign padr_91 = { padl_93, padr_bits_92 };
  assign toUsInt_60 = truncR_imm_75 + padr_76 + padr_91;
  assign truncval_59 = toUsInt_60[43:0];
  assign truncR_58 = truncval_59[44:0];
  assign tau = truncR_58[44:1];
  wire [39-1:0] padl_98;
  wire [38-1:0] padl_bits_99;
  wire [38-1:0] padr_100;
  wire [24-1:0] padr_bits_101;
  assign padr_bits_101 = 0;
  wire [15-1:0] toUsInt_102;
  wire [15-1:0] padr_103;
  wire [5-1:0] padr_bits_104;
  assign padr_bits_104 = 0;
  wire [11-1:0] truncval_105;
  wire [40-1:0] truncR_106;
  wire [1-1:0] toSInt_107;
  assign toSInt_107 = 0;
  wire [40-1:0] toSInt_imm_108;
  assign toSInt_imm_108 = { toSInt_107, o };
  assign truncR_106 = toSInt_imm_108;
  wire [11-1:0] truncR_shift_109;
  assign truncR_shift_109 = truncR_106 >>> 29;
  wire [11-1:0] truncR_imm_110;
  assign truncR_imm_110 = (truncR_106[39])? truncR_shift_109[10:0] : truncR_106[39:29];
  assign truncval_105 = truncR_imm_110;
  assign padr_103 = { truncval_105[9:0], padr_bits_104 };
  assign toUsInt_102 = padr_103;
  assign padr_100 = { toUsInt_102[11:0], padr_bits_101 };
  assign padl_bits_99 = padr_100;
  wire [1-1:0] padl_bits_zero_111;
  assign padl_bits_zero_111 = 0;
  assign padl_98 = { padl_bits_zero_111, padl_bits_99 };
  wire [36-1:0] padl_112;
  wire [16-1:0] padl_bits_113;
  wire [36-1:0] truncR_114;
  wire [60-1:0] truncR_115;
  wire [93-1:0] truncval_116;
  wire [93-1:0] padl_117;
  wire [46-1:0] padl_bits_118;
  wire [46-1:0] padl_119;
  wire [16-1:0] padl_bits_120;
  wire [16-1:0] neg_imm_121;
  wire [15-1:0] padr_122;
  wire [5-1:0] padr_bits_123;
  assign padr_bits_123 = 0;
  wire [11-1:0] truncval_124;
  wire [40-1:0] truncR_125;
  wire [1-1:0] toSInt_126;
  assign toSInt_126 = 0;
  wire [40-1:0] toSInt_imm_127;
  assign toSInt_imm_127 = { toSInt_126, o };
  assign truncR_125 = toSInt_imm_127;
  wire [11-1:0] truncR_shift_128;
  assign truncR_shift_128 = truncR_125 >>> 29;
  wire [11-1:0] truncR_imm_129;
  assign truncR_imm_129 = (truncR_125[39])? truncR_shift_128[10:0] : truncR_125[39:29];
  assign truncval_124 = truncR_imm_129;
  assign padr_122 = { truncval_124[9:0], padr_bits_123 };
  assign neg_imm_121 = -padr_122;
  assign padl_bits_120 = neg_imm_121;
  assign padl_119 = { { 30{ padl_bits_120[15] } }, padl_bits_120 };
  assign padl_bits_118 = padl_119;
  assign padl_117 = { { 47{ padl_bits_118[45] } }, padl_bits_118 };
  wire [93-1:0] padl_130;
  wire [46-1:0] padl_bits_131;
  wire [46-1:0] padr_132;
  wire [12-1:0] padr_bits_133;
  assign padr_bits_133 = 0;
  wire [1-1:0] toSInt_134;
  assign toSInt_134 = 0;
  wire [34-1:0] toSInt_imm_135;
  wire [44-1:0] truncval_136;
  assign truncval_136 = 45'd17592186044416 / tau;
  assign toSInt_imm_135 = { toSInt_134, truncval_136[32:0] };
  assign padr_132 = { toSInt_imm_135, padr_bits_133 };
  assign padl_bits_131 = padr_132;
  assign padl_130 = { { 47{ padl_bits_131[45] } }, padl_bits_131 };
  assign truncval_116 = padl_117 * padl_130;
  assign truncR_115 = truncval_116[59:0];
  wire [36-1:0] truncR_shift_137;
  assign truncR_shift_137 = truncR_115 >>> 24;
  wire [36-1:0] truncR_imm_138;
  assign truncR_imm_138 = (truncR_115[59])? truncR_shift_137[35:0] : truncR_115[59:24];
  assign truncR_114 = truncR_imm_138;
  wire [16-1:0] truncR_shift_139;
  assign truncR_shift_139 = truncR_114 >>> 20;
  wire [16-1:0] truncR_imm_140;
  assign truncR_imm_140 = (truncR_114[35])? truncR_shift_139[15:0] : truncR_114[35:20];
  assign padl_bits_113 = truncR_imm_140;
  assign padl_112 = { { 20{ padl_bits_113[15] } }, padl_bits_113 };
  assign dvdt = padl_112;
  wire [41-1:0] truncval_141;
  wire [41-1:0] padr_142;
  wire [29-1:0] padr_bits_143;
  assign padr_bits_143 = 0;
  wire [19-1:0] truncR_144;
  wire [19-1:0] padl_145;
  wire [16-1:0] padl_bits_146;
  wire [100-1:0] truncR_147;
  wire [171-1:0] truncval_148;
  wire [171-1:0] padl_149;
  wire [95-1:0] padl_bits_150;
  wire [95-1:0] padl_151;
  wire [60-1:0] padl_bits_152;
  wire [1-1:0] toSInt_153;
  assign toSInt_153 = 0;
  wire [60-1:0] toSInt_imm_154;
  wire [59-1:0] const_155;
  assign const_155 = 57646075;
  assign toSInt_imm_154 = { toSInt_153, const_155 };
  assign padl_bits_152 = toSInt_imm_154;
  assign padl_151 = { { 35{ padl_bits_152[59] } }, padl_bits_152 };
  assign padl_bits_150 = padl_151;
  assign padl_149 = { { 76{ padl_bits_150[94] } }, padl_bits_150 };
  wire [171-1:0] padl_156;
  wire [95-1:0] padl_bits_157;
  wire [95-1:0] padr_158;
  wire [59-1:0] padr_bits_159;
  assign padr_bits_159 = 0;
  assign padr_158 = { dvdt, padr_bits_159 };
  assign padl_bits_157 = padr_158;
  assign padl_156 = { { 76{ padl_bits_157[94] } }, padl_bits_157 };
  assign truncval_148 = padl_149 * padl_156;
  assign truncR_147 = truncval_148[99:0];
  wire [16-1:0] truncR_shift_160;
  assign truncR_shift_160 = truncR_147 >>> 84;
  wire [16-1:0] truncR_imm_161;
  assign truncR_imm_161 = (truncR_147[99])? truncR_shift_160[15:0] : truncR_147[99:84];
  assign padl_bits_146 = truncR_imm_161;
  assign padl_145 = { { 3{ padl_bits_146[15] } }, padl_bits_146 };
  assign truncR_144 = padl_145;
  wire [12-1:0] truncR_shift_162;
  assign truncR_shift_162 = truncR_144 >>> 7;
  wire [12-1:0] truncR_imm_163;
  assign truncR_imm_163 = (truncR_144[18])? truncR_shift_162[11:0] : truncR_144[18:7];
  assign padr_142 = { truncR_imm_163, padr_bits_143 };
  assign truncval_141 = padr_142;
  wire [93-1:0] truncR_164;
  wire [161-1:0] truncval_165;
  wire [161-1:0] padl_166;
  wire [84-1:0] padl_bits_167;
  wire [84-1:0] padl_168;
  wire [51-1:0] padl_bits_169;
  wire [51-1:0] padr_170;
  wire [1-1:0] padr_bits_171;
  assign padr_bits_171 = 0;
  wire [94-1:0] truncR_172;
  wire [103-1:0] truncval_173;
  wire [142-1:0] padl_174;
  wire [90-1:0] padl_bits_175;
  wire [90-1:0] padr_176;
  wire [39-1:0] padr_bits_177;
  assign padr_bits_177 = 0;
  wire [51-1:0] padr_178;
  wire [36-1:0] padr_bits_179;
  assign padr_bits_179 = 0;
  assign padr_178 = { VREF, padr_bits_179 };
  assign padr_176 = { padr_178, padr_bits_177 };
  assign padl_bits_175 = padr_176;
  assign padl_174 = { { 52{ padl_bits_175[89] } }, padl_bits_175 };
  wire [103-1:0] padl_180;
  wire [51-1:0] padl_bits_181;
  wire [51-1:0] padl_182;
  wire [48-1:0] padl_bits_183;
  wire [48-1:0] param_184;
  assign param_184 = VREF_to_response_time_lh;
  assign padl_bits_183 = param_184;
  assign padl_182 = { { 3{ padl_bits_183[47] } }, padl_bits_183 };
  assign padl_bits_181 = padl_182;
  assign padl_180 = { { 52{ padl_bits_181[50] } }, padl_bits_181 };
  assign truncval_173 = padl_174 * padl_180;
  assign truncR_172 = truncval_173[93:0];
  wire [50-1:0] truncR_shift_185;
  assign truncR_shift_185 = truncR_172 >>> 44;
  wire [50-1:0] truncR_imm_186;
  assign truncR_imm_186 = (truncR_172[93])? truncR_shift_185[49:0] : truncR_172[93:44];
  assign padr_170 = { truncR_imm_186, padr_bits_171 };
  wire [98-1:0] truncR_187;
  wire [107-1:0] truncval_188;
  wire [107-1:0] padl_189;
  wire [53-1:0] padl_bits_190;
  wire [53-1:0] padr_191;
  wire [41-1:0] padr_bits_192;
  assign padr_bits_192 = 0;
  assign padr_191 = { VREG, padr_bits_192 };
  assign padl_bits_190 = padr_191;
  assign padl_189 = { { 54{ padl_bits_190[52] } }, padl_bits_190 };
  wire [107-1:0] padl_193;
  wire [53-1:0] padl_bits_194;
  wire [53-1:0] padl_195;
  wire [50-1:0] padl_bits_196;
  wire [50-1:0] param_197;
  assign param_197 = VREG_to_response_time_lh;
  assign padl_bits_196 = param_197;
  assign padl_195 = { { 3{ padl_bits_196[49] } }, padl_bits_196 };
  assign padl_bits_194 = padl_195;
  assign padl_193 = { { 54{ padl_bits_194[52] } }, padl_bits_194 };
  assign truncval_188 = padl_189 * padl_193;
  assign truncR_187 = truncval_188[97:0];
  wire [51-1:0] truncR_shift_198;
  assign truncR_shift_198 = truncR_187 >>> 47;
  wire [51-1:0] truncR_imm_199;
  assign truncR_imm_199 = (truncR_187[97])? truncR_shift_198[50:0] : truncR_187[97:47];
  wire [51-1:0] padr_200;
  wire [6-1:0] padr_bits_201;
  assign padr_bits_201 = 0;
  wire [45-1:0] padl_202;
  wire [44-1:0] padl_bits_203;
  wire [1-1:0] toSInt_204;
  assign toSInt_204 = 0;
  wire [44-1:0] toSInt_imm_205;
  wire [43-1:0] param_206;
  assign param_206 = const_response_time_lh;
  assign toSInt_imm_205 = { toSInt_204, param_206 };
  assign padl_bits_203 = toSInt_imm_205;
  assign padl_202 = { { 1{ padl_bits_203[43] } }, padl_bits_203 };
  assign padr_200 = { padl_202, padr_bits_201 };
  assign padl_bits_169 = padr_170 + truncR_imm_199 + padr_200;
  assign padl_168 = { { 33{ padl_bits_169[50] } }, padl_bits_169 };
  assign padl_bits_167 = padl_168;
  assign padl_166 = { { 77{ padl_bits_167[83] } }, padl_bits_167 };
  wire [161-1:0] padl_207;
  wire [84-1:0] padl_bits_208;
  wire [84-1:0] padr_209;
  wire [49-1:0] padr_bits_210;
  assign padr_bits_210 = 0;
  wire [1-1:0] toSInt_211;
  assign toSInt_211 = 0;
  wire [35-1:0] toSInt_imm_212;
  wire [34-1:0] const_213;
  assign const_213 = 78125000;
  assign toSInt_imm_212 = { toSInt_211, const_213 };
  assign padr_209 = { toSInt_imm_212, padr_bits_210 };
  assign padl_bits_208 = padr_209;
  assign padl_207 = { { 77{ padl_bits_208[83] } }, padl_bits_208 };
  assign truncval_165 = padl_166 * padl_207;
  assign truncR_164 = truncval_165[92:0];
  assign wait_time_lh = truncR_164[92:77];
  wire [39-1:0] padl_214;
  wire [36-1:0] padl_bits_215;
  wire [36-1:0] const_216;
  assign const_216 = 68719476;
  assign padl_bits_215 = const_216;
  wire [3-1:0] padl_bits_zero_217;
  assign padl_bits_zero_217 = 0;
  assign padl_214 = { padl_bits_zero_217, padl_bits_215 };
  wire [49-1:0] truncR_218;
  wire [50-1:0] truncval_219;
  wire [51-1:0] toUsInt_220;
  wire [96-1:0] truncR_221;
  wire [105-1:0] truncval_222;
  wire [145-1:0] padl_223;
  wire [92-1:0] padl_bits_224;
  wire [92-1:0] padr_225;
  wire [40-1:0] padr_bits_226;
  assign padr_bits_226 = 0;
  wire [52-1:0] padr_227;
  wire [37-1:0] padr_bits_228;
  assign padr_bits_228 = 0;
  assign padr_227 = { VREF, padr_bits_228 };
  assign padr_225 = { padr_227, padr_bits_226 };
  assign padl_bits_224 = padr_225;
  assign padl_223 = { { 53{ padl_bits_224[91] } }, padl_bits_224 };
  wire [105-1:0] padl_229;
  wire [52-1:0] padl_bits_230;
  wire [52-1:0] padl_231;
  wire [49-1:0] padl_bits_232;
  wire [49-1:0] param_233;
  assign param_233 = VREF_to_tau_lh;
  assign padl_bits_232 = param_233;
  assign padl_231 = { { 3{ padl_bits_232[48] } }, padl_bits_232 };
  assign padl_bits_230 = padl_231;
  assign padl_229 = { { 53{ padl_bits_230[51] } }, padl_bits_230 };
  assign truncval_222 = padl_223 * padl_229;
  assign truncR_221 = truncval_222[95:0];
  wire [51-1:0] truncR_shift_234;
  assign truncR_shift_234 = truncR_221 >>> 45;
  wire [51-1:0] truncR_imm_235;
  assign truncR_imm_235 = (truncR_221[95])? truncR_shift_234[50:0] : truncR_221[95:45];
  wire [51-1:0] padr_236;
  wire [3-1:0] padr_bits_237;
  assign padr_bits_237 = 0;
  wire [90-1:0] truncR_238;
  wire [99-1:0] truncval_239;
  wire [99-1:0] padl_240;
  wire [49-1:0] padl_bits_241;
  wire [49-1:0] padr_242;
  wire [37-1:0] padr_bits_243;
  assign padr_bits_243 = 0;
  assign padr_242 = { VREG, padr_bits_243 };
  assign padl_bits_241 = padr_242;
  assign padl_240 = { { 50{ padl_bits_241[48] } }, padl_bits_241 };
  wire [99-1:0] padl_244;
  wire [49-1:0] padl_bits_245;
  wire [49-1:0] padl_246;
  wire [45-1:0] padl_bits_247;
  wire [1-1:0] toSInt_248;
  assign toSInt_248 = 0;
  wire [45-1:0] toSInt_imm_249;
  wire [44-1:0] param_250;
  assign param_250 = VREG_to_tau_lh;
  assign toSInt_imm_249 = { toSInt_248, param_250 };
  assign padl_bits_247 = toSInt_imm_249;
  assign padl_246 = { { 4{ padl_bits_247[44] } }, padl_bits_247 };
  assign padl_bits_245 = padl_246;
  assign padl_244 = { { 50{ padl_bits_245[48] } }, padl_bits_245 };
  assign truncval_239 = padl_240 * padl_244;
  assign truncR_238 = truncval_239[89:0];
  wire [48-1:0] truncR_shift_251;
  assign truncR_shift_251 = truncR_238 >>> 42;
  wire [48-1:0] truncR_imm_252;
  assign truncR_imm_252 = (truncR_238[89])? truncR_shift_251[47:0] : truncR_238[89:42];
  assign padr_236 = { truncR_imm_252, padr_bits_237 };
  wire [51-1:0] padr_253;
  wire [6-1:0] padr_bits_254;
  assign padr_bits_254 = 0;
  wire [45-1:0] padl_255;
  wire [44-1:0] padl_bits_256;
  wire [1-1:0] toSInt_257;
  assign toSInt_257 = 0;
  wire [44-1:0] toSInt_imm_258;
  wire [43-1:0] param_259;
  assign param_259 = const_tau_lh;
  assign toSInt_imm_258 = { toSInt_257, param_259 };
  assign padl_bits_256 = toSInt_imm_258;
  assign padl_255 = { { 1{ padl_bits_256[43] } }, padl_bits_256 };
  assign padr_253 = { padl_255, padr_bits_254 };
  assign toUsInt_220 = truncR_imm_235 + padr_236 + padr_253;
  assign truncval_219 = toUsInt_220[47:0];
  assign truncR_218 = truncval_219[48:0];
  assign tau_lh = truncR_218[48:3];
  wire [39-1:0] padl_260;
  wire [38-1:0] padl_bits_261;
  wire [38-1:0] padr_262;
  wire [24-1:0] padr_bits_263;
  assign padr_bits_263 = 0;
  wire [15-1:0] toUsInt_264;
  wire [33-1:0] truncR_265;
  wire [34-1:0] truncval_266;
  wire [40-1:0] truncR_267;
  wire [1-1:0] toSInt_268;
  assign toSInt_268 = 0;
  wire [40-1:0] toSInt_imm_269;
  assign toSInt_imm_269 = { toSInt_268, o };
  assign truncR_267 = toSInt_imm_269;
  wire [34-1:0] truncR_shift_270;
  assign truncR_shift_270 = truncR_267 >>> 6;
  wire [34-1:0] truncR_imm_271;
  assign truncR_imm_271 = (truncR_267[39])? truncR_shift_270[33:0] : truncR_267[39:6];
  assign truncval_266 = truncR_imm_271;
  assign truncR_265 = truncval_266[32:0];
  wire [15-1:0] truncR_shift_272;
  assign truncR_shift_272 = truncR_265 >>> 18;
  wire [15-1:0] truncR_imm_273;
  assign truncR_imm_273 = (truncR_265[32])? truncR_shift_272[14:0] : truncR_265[32:18];
  assign toUsInt_264 = truncR_imm_273;
  assign padr_262 = { toUsInt_264[11:0], padr_bits_263 };
  assign padl_bits_261 = padr_262;
  wire [1-1:0] padl_bits_zero_274;
  assign padl_bits_zero_274 = 0;
  assign padl_260 = { padl_bits_zero_274, padl_bits_261 };
  wire [38-1:0] padl_275;
  wire [17-1:0] padl_bits_276;
  wire [38-1:0] truncR_277;
  wire [98-1:0] truncR_278;
  wire [129-1:0] truncval_279;
  wire [129-1:0] padl_280;
  wire [64-1:0] padl_bits_281;
  wire [64-1:0] padl_282;
  wire [35-1:0] padl_bits_283;
  wire [35-1:0] padr_284;
  wire [6-1:0] padr_bits_285;
  assign padr_bits_285 = 0;
  wire [29-1:0] padl_286;
  wire [28-1:0] padl_bits_287;
  wire [1-1:0] toSInt_288;
  assign toSInt_288 = 0;
  wire [28-1:0] toSInt_imm_289;
  wire [27-1:0] const_290;
  assign const_290 = 55364812;
  assign toSInt_imm_289 = { toSInt_288, const_290 };
  assign padl_bits_287 = toSInt_imm_289;
  assign padl_286 = { { 1{ padl_bits_287[27] } }, padl_bits_287 };
  assign padr_284 = { padl_286, padr_bits_285 };
  wire [35-1:0] padl_291;
  wire [34-1:0] padl_bits_292;
  wire [40-1:0] truncR_293;
  wire [1-1:0] toSInt_294;
  assign toSInt_294 = 0;
  wire [40-1:0] toSInt_imm_295;
  assign toSInt_imm_295 = { toSInt_294, o };
  assign truncR_293 = toSInt_imm_295;
  wire [34-1:0] truncR_shift_296;
  assign truncR_shift_296 = truncR_293 >>> 6;
  wire [34-1:0] truncR_imm_297;
  assign truncR_imm_297 = (truncR_293[39])? truncR_shift_296[33:0] : truncR_293[39:6];
  assign padl_bits_292 = truncR_imm_297;
  assign padl_291 = { { 1{ padl_bits_292[33] } }, padl_bits_292 };
  assign padl_bits_283 = padr_284 - padl_291;
  assign padl_282 = { { 29{ padl_bits_283[34] } }, padl_bits_283 };
  assign padl_bits_281 = padl_282;
  assign padl_280 = { { 65{ padl_bits_281[63] } }, padl_bits_281 };
  wire [129-1:0] padl_298;
  wire [64-1:0] padl_bits_299;
  wire [64-1:0] padr_300;
  wire [30-1:0] padr_bits_301;
  assign padr_bits_301 = 0;
  wire [1-1:0] toSInt_302;
  assign toSInt_302 = 0;
  wire [34-1:0] toSInt_imm_303;
  wire [46-1:0] truncval_304;
  assign truncval_304 = 47'd70368744177664 / tau_lh;
  assign toSInt_imm_303 = { toSInt_302, truncval_304[32:0] };
  assign padr_300 = { toSInt_imm_303, padr_bits_301 };
  assign padl_bits_299 = padr_300;
  assign padl_298 = { { 65{ padl_bits_299[63] } }, padl_bits_299 };
  assign truncval_279 = padl_280 * padl_298;
  assign truncR_278 = truncval_279[97:0];
  wire [38-1:0] truncR_shift_305;
  assign truncR_shift_305 = truncR_278 >>> 60;
  wire [38-1:0] truncR_imm_306;
  assign truncR_imm_306 = (truncR_278[97])? truncR_shift_305[37:0] : truncR_278[97:60];
  assign truncR_277 = truncR_imm_306;
  wire [17-1:0] truncR_shift_307;
  assign truncR_shift_307 = truncR_277 >>> 21;
  wire [17-1:0] truncR_imm_308;
  assign truncR_imm_308 = (truncR_277[37])? truncR_shift_307[16:0] : truncR_277[37:21];
  assign padl_bits_276 = truncR_imm_308;
  assign padl_275 = { { 21{ padl_bits_276[16] } }, padl_bits_276 };
  assign dodt = padl_275;
  wire [41-1:0] truncval_309;
  wire [41-1:0] padr_310;
  wire [6-1:0] padr_bits_311;
  assign padr_bits_311 = 0;
  wire [35-1:0] padr_312;
  wire [17-1:0] padr_bits_313;
  assign padr_bits_313 = 0;
  wire [18-1:0] padl_314;
  wire [17-1:0] padl_bits_315;
  wire [101-1:0] truncR_316;
  wire [174-1:0] truncval_317;
  wire [174-1:0] padl_318;
  wire [97-1:0] padl_bits_319;
  wire [97-1:0] padl_320;
  wire [60-1:0] padl_bits_321;
  wire [1-1:0] toSInt_322;
  assign toSInt_322 = 0;
  wire [60-1:0] toSInt_imm_323;
  wire [59-1:0] const_324;
  assign const_324 = 57646075;
  assign toSInt_imm_323 = { toSInt_322, const_324 };
  assign padl_bits_321 = toSInt_imm_323;
  assign padl_320 = { { 37{ padl_bits_321[59] } }, padl_bits_321 };
  assign padl_bits_319 = padl_320;
  assign padl_318 = { { 77{ padl_bits_319[96] } }, padl_bits_319 };
  wire [174-1:0] padl_325;
  wire [97-1:0] padl_bits_326;
  wire [97-1:0] padr_327;
  wire [59-1:0] padr_bits_328;
  assign padr_bits_328 = 0;
  assign padr_327 = { dodt, padr_bits_328 };
  assign padl_bits_326 = padr_327;
  assign padl_325 = { { 77{ padl_bits_326[96] } }, padl_bits_326 };
  assign truncval_317 = padl_318 * padl_325;
  assign truncR_316 = truncval_317[100:0];
  wire [17-1:0] truncR_shift_329;
  assign truncR_shift_329 = truncR_316 >>> 84;
  wire [17-1:0] truncR_imm_330;
  assign truncR_imm_330 = (truncR_316[100])? truncR_shift_329[16:0] : truncR_316[100:84];
  assign padl_bits_315 = truncR_imm_330;
  assign padl_314 = { { 1{ padl_bits_315[16] } }, padl_bits_315 };
  assign padr_312 = { padl_314, padr_bits_313 };
  assign padr_310 = { padr_312, padr_bits_311 };
  assign truncval_309 = padr_310;

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
            o <= 39'd226774273228;
          end else begin
            o <= padr_0;
          end
          if(~prev_sys_clk & sys_clk & ((VREF > 15'd1638) & (VREF <= 15'd16384))) begin
            fsm <= fsm_1;
          end 
        end
        fsm_1: begin
          if(reset) begin
            o <= 39'd226774273228;
          end else begin
            o <= padr_55;
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
            o <= 39'd226774273228;
          end else begin
            o <= o + truncval_141[38:0];
          end
          if(prev_sys_clk & ~sys_clk) begin
            fsm <= fsm_3;
          end 
        end
        fsm_3: begin
          if(reset) begin
            o <= 39'd226774273228;
          end else begin
            o <= padl_214;
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
            o <= 39'd226774273228;
          end else begin
            o <= o + truncval_309[38:0];
          end
          if((o > 39'd226087078461) & (o <= 39'd274877906944)) begin
            fsm <= fsm_init;
          end 
        end
      endcase
    end
  end


endmodule

