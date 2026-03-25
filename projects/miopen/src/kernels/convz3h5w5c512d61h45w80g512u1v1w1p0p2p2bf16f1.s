/*******************************************************************************
 * Depthwise 3D conv ASM from pyhip asm_cache (HIP->LLVM, gfx942).
 * Source: conv_depthwise3d_hip bf16, BLOCK 45x80, pad (0,2,2), KD/KH/KW 3/5/5.
 * Renamed to MIOpen kernel symbol; .amdgcn_target stripped (use COMGR -mcpu).
 ******************************************************************************/
	.amdhsa_code_object_version 6
	.text
	.protected	miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1 ; -- Begin function miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
	.globl	miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
	.p2align	8
	.type	miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1,@function
miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1: ; @miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
; %bb.0:
	s_mov_b32 s26, s3                                ;	s26 = s3
	s_load_dword s3, s[0:1], 0x4c                    ;	s3 = load_dword_from(s[0:1] + 0x4c, glc=0);  // 8.2.1.1. Scalar Memory Addressing
	s_add_u32 s24, s0, 64                            ;	s24.u32 = s0 + 64; scc=overflow_or_carry
	s_addc_u32 s25, s1, 0                            ;	s25.u32 = s1 + 0 + scc; scc=overflow_or_carry
	s_movk_i32 s5, 0x303c
	s_waitcnt lgkmcnt(0)
	s_and_b32 s3, s3, 0xffff                         ;	s3 = s3 & 0xffff
	v_cvt_f32_u32_e32 v1, s3
	v_add_u32_e32 v2, s3, v0                         ;	v2 = s3 + v0
	s_cmp_eq_u32 s3, 1                               ;	scc = (s3.u32 == 1.u32)
	v_mov_b32_e32 v4, s3                             ;	v4 = s3;
	v_rcp_iflag_f32_e32 v1, v1
	v_cmp_gt_u32_e32 vcc, s5, v2                     ;	vcc.u64[laneId] = (s5.u32  > v2.u32 )
	s_cselect_b64 s[8:9], -1, 0                      ;	s[8:9] = scc ? -1 : 0
	v_max_u32_e32 v3, 0x303c, v2
	v_mul_f32_e32 v1, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v1, v1
	v_addc_co_u32_e64 v2, s[6:7], v0, v4, vcc        ;	tmp = 64'U(v0) + 64'U(v4) + s[6:7].u64[laneId]; vcc.u64[laneId]=overflow_carry;  v2=tmp
	s_sub_i32 s5, 0, s3                              ;	s5.i32 = (0.i32 - s3.i32); scc=(overflow or carry-out of last arith);
	v_sub_u32_e32 v2, v3, v2
	v_mul_lo_u32 v3, s5, v1
	v_mul_hi_u32 v3, v1, v3
	v_add_u32_e32 v1, v1, v3                         ;	v1 = v1 + v3
	v_mul_hi_u32 v1, v2, v1
	v_mul_lo_u32 v3, v1, s3
	v_sub_u32_e32 v2, v2, v3
	v_add_u32_e32 v3, 1, v1                          ;	v3 = 1 + v1
	v_cmp_le_u32_e64 s[6:7], s3, v2                  ;	s[6:7].u64[laneId] = (s3.u32  <= v2.u32 )
	s_nop 1                                          ;	s_nop  wait 2 cycles
	v_cndmask_b32_e64 v1, v1, v3, s[6:7]             ;	v1.b32 = s[6:7].u64[laneId] ? v3.u32 : v1.u32
	v_subrev_u32_e32 v3, s3, v2
	v_cndmask_b32_e64 v2, v2, v3, s[6:7]             ;	v2.b32 = s[6:7].u64[laneId] ? v3.u32 : v2.u32
	v_add_u32_e32 v3, 1, v1                          ;	v3 = 1 + v1
	v_cmp_le_u32_e64 s[6:7], s3, v2                  ;	s[6:7].u64[laneId] = (s3.u32  <= v2.u32 )
	v_mov_b32_e32 v2, v0                             ;	v2 = v0;
	s_nop 0                                          ;	s_nop  wait 1 cycles
	v_cndmask_b32_e64 v3, v1, v3, s[6:7]             ;	v3.b32 = s[6:7].u64[laneId] ? v3.u32 : v1.u32
	v_addc_co_u32_e64 v1, s[6:7], 1, v3, vcc         ;	tmp = 64'U(1) + 64'U(v3) + s[6:7].u64[laneId]; vcc.u64[laneId]=overflow_carry;  v1=tmp
	v_cmp_lt_u32_e64 s[6:7], 3, v1                   ;	s[6:7].u64[laneId] = (3.u32  < v1.u32 )
	s_and_b64 s[10:11], s[6:7], s[8:9]               ;	s[10:11] = s[6:7] & s[8:9]
	s_mov_b64 s[8:9], -1                             ;	s[8:9] = -1
	s_and_saveexec_b64 s[6:7], s[10:11]              ;	exec=s[10:11]&exec; s[6:7]=old_exec; scc=(exec!=0)
	s_cbranch_execz .LBB0_9                          ;	jump if execz is 1 (exec mask == 0)
; %bb.1:
	v_addc_co_u32_e32 v2, vcc, 0, v3, vcc            ;	tmp = 64'U(0) + 64'U(v3) + vcc.u64[laneId]; vcc.u64[laneId]=overflow_carry;  v2=tmp
	v_add_u32_e32 v2, -3, v2                         ;	v2 = -3 + v2
	v_lshrrev_b32_e32 v3, 2, v2                      ;	v3.b32 = v2 >> 2;
	v_add_u32_e32 v4, 1, v3                          ;	v4 = 1 + v3
	v_cmp_lt_u32_e32 vcc, 27, v2                     ;	vcc.u64[laneId] = (27.u32  < v2.u32 )
	v_mov_b32_e32 v7, 0                              ;	v7 = 0;
	s_and_saveexec_b64 s[8:9], vcc                   ;	exec=vcc&exec; s[8:9]=old_exec; scc=(exec!=0)
	s_cbranch_execz .LBB0_5                          ;	jump if execz is 1 (exec mask == 0)
; %bb.2:
	s_mov_b32 s12, 0                                 ;	s12 = 0
	s_mov_b32 s13, s12                               ;	s13 = s12
	v_and_b32_e32 v5, 0x7ffffff8, v4                 ;	v5.u32 = (0x7ffffff8 & v4.u32)
	v_lshlrev_b32_e32 v6, 1, v0                      ;	v6.b32 = v0 << 1;
	s_lshl_b32 s5, s3, 6                             ;	s5 = s3 << 6[4:0]; scc=(s5!=0);
	s_lshl_b32 s14, s3, 3                            ;	s14 = s3 << 3[4:0]; scc=(s14!=0);
	s_mov_b64 s[10:11], 0                            ;	s[10:11] = 0
	v_mov_b64_e32 v[2:3], s[12:13]                   ;	v[2:3] = s[12:13];
.LBB0_3:                                ; =>This Inner Loop Header: Depth=1
	v_add_u32_e32 v7, s14, v6                        ;	v7 = s14 + v6
	v_add_u32_e32 v8, s14, v7                        ;	v8 = s14 + v7
	ds_write_b64 v6, v[2:3]                          ;	LDS_MEM[v6 + 0].b64 = v[2:3].b64
	ds_write_b64 v7, v[2:3]                          ;	LDS_MEM[v7 + 0].b64 = v[2:3].b64
	ds_write_b64 v8, v[2:3]                          ;	LDS_MEM[v8 + 0].b64 = v[2:3].b64
	v_add_u32_e32 v8, s14, v8                        ;	v8 = s14 + v8
	ds_write_b64 v8, v[2:3]                          ;	LDS_MEM[v8 + 0].b64 = v[2:3].b64
	v_add_u32_e32 v8, s14, v8                        ;	v8 = s14 + v8
	v_add_u32_e32 v5, -8, v5                         ;	v5 = -8 + v5
	ds_write_b64 v8, v[2:3]                          ;	LDS_MEM[v8 + 0].b64 = v[2:3].b64
	v_add_u32_e32 v8, s14, v8                        ;	v8 = s14 + v8
	s_add_i32 s12, s12, 32                           ;	s12.i32 = s12 + 32; scc=overflow_or_carry
	v_cmp_eq_u32_e32 vcc, 0, v5                      ;	vcc.u64[laneId] = (0.u32  == v5.u32 )
	ds_write_b64 v8, v[2:3]                          ;	LDS_MEM[v8 + 0].b64 = v[2:3].b64
	v_add_u32_e32 v8, s14, v8                        ;	v8 = s14 + v8
	v_add_u32_e32 v6, s5, v6                         ;	v6 = s5 + v6
	v_mov_b32_e32 v7, s12                            ;	v7 = s12;
	s_or_b64 s[10:11], vcc, s[10:11]                 ;	s[10:11] = vcc | s[10:11];  scc=(s[10:11]!=0);
	ds_write_b64 v8, v[2:3]                          ;	LDS_MEM[v8 + 0].b64 = v[2:3].b64
	v_add_u32_e32 v8, s14, v8                        ;	v8 = s14 + v8
	ds_write_b64 v8, v[2:3]                          ;	LDS_MEM[v8 + 0].b64 = v[2:3].b64
	s_andn2_b64 exec, exec, s[10:11]                 ;	exec = (exec & ~s[10:11]); scc=(exec!=0);
	s_cbranch_execnz .LBB0_3                         ;	jump if execnz is 1 (exec mask != 0)
; %bb.4:
	s_or_b64 exec, exec, s[10:11]                    ;	exec = exec | s[10:11];  scc=(exec!=0);
.LBB0_5:
	s_or_b64 exec, exec, s[8:9]                      ;	exec = exec | s[8:9];  scc=(exec!=0);
	v_and_b32_e32 v4, 7, v4                          ;	v4.u32 = (7 & v4.u32)
	v_cmp_ne_u32_e32 vcc, 0, v4                      ;	vcc.u64[laneId] = (0.u32  <> v4.u32 )
	s_and_saveexec_b64 s[8:9], vcc                   ;	exec=vcc&exec; s[8:9]=old_exec; scc=(exec!=0)
	s_cbranch_execz .LBB0_8                          ;	jump if execz is 1 (exec mask == 0)
; %bb.6:
	v_mul_lo_u32 v2, v7, s3
	v_add_lshl_u32 v5, v0, v2, 1                     ;	v5 = (v0 + v2) << 1[4:0]
	v_mov_b32_e32 v2, 0                              ;	v2 = 0;
	s_lshl_b32 s5, s3, 3                             ;	s5 = s3 << 3[4:0]; scc=(s5!=0);
	s_mov_b64 s[10:11], 0                            ;	s[10:11] = 0
	v_mov_b32_e32 v3, v2                             ;	v3 = v2;
.LBB0_7:                                ; =>This Inner Loop Header: Depth=1
	v_add_u32_e32 v4, -1, v4                         ;	v4 = -1 + v4
	v_cmp_eq_u32_e32 vcc, 0, v4                      ;	vcc.u64[laneId] = (0.u32  == v4.u32 )
	ds_write_b64 v5, v[2:3]                          ;	LDS_MEM[v5 + 0].b64 = v[2:3].b64
	s_or_b64 s[10:11], vcc, s[10:11]                 ;	s[10:11] = vcc | s[10:11];  scc=(s[10:11]!=0);
	v_add_u32_e32 v5, s5, v5                         ;	v5 = s5 + v5
	s_andn2_b64 exec, exec, s[10:11]                 ;	exec = (exec & ~s[10:11]); scc=(exec!=0);
	s_cbranch_execnz .LBB0_7                         ;	jump if execnz is 1 (exec mask != 0)
.LBB0_8:
	s_or_b64 exec, exec, s[8:9]                      ;	exec = exec | s[8:9];  scc=(exec!=0);
	v_and_b32_e32 v4, -4, v1                         ;	v4.u32 = (-4 & v1.u32)
	v_mad_u64_u32 v[2:3], s[8:9], v4, s3, v[0:1]
	v_cmp_ne_u32_e32 vcc, v1, v4                     ;	vcc.u64[laneId] = (v1.u32  <> v4.u32 )
	s_orn2_b64 s[8:9], vcc, exec
.LBB0_9:
	s_or_b64 exec, exec, s[6:7]                      ;	exec = exec | s[6:7];  scc=(exec!=0);
	s_load_dwordx8 s[16:23], s[0:1], 0x0             ;	s[16:23] = load_dwordx8_from(s[0:1] + 0x0, glc=0);  // 8.2.1.1. Scalar Memory Addressing
	s_and_saveexec_b64 s[6:7], s[8:9]                ;	exec=s[8:9]&exec; s[6:7]=old_exec; scc=(exec!=0)
	s_cbranch_execz .LBB0_12                         ;	jump if execz is 1 (exec mask == 0)
; %bb.10:
	v_lshlrev_b32_e32 v1, 1, v2                      ;	v1.b32 = v2 << 1;
	s_lshl_b32 s5, s3, 1                             ;	s5 = s3 << 1[4:0]; scc=(s5!=0);
	s_mov_b64 s[8:9], 0                              ;	s[8:9] = 0
	v_mov_b32_e32 v3, 0                              ;	v3 = 0;
	s_movk_i32 s10, 0x303b
.LBB0_11:                               ; =>This Inner Loop Header: Depth=1
	v_add_u32_e32 v2, s3, v2                         ;	v2 = s3 + v2
	v_cmp_lt_u32_e32 vcc, s10, v2                    ;	vcc.u64[laneId] = (s10.u32  < v2.u32 )
	ds_write_b16 v1, v3                              ;	LDS_MEM[v1 + 0].b16 = v3.b16
	s_or_b64 s[8:9], vcc, s[8:9]                     ;	s[8:9] = vcc | s[8:9];  scc=(s[8:9]!=0);
	v_add_u32_e32 v1, s5, v1                         ;	v1 = s5 + v1
	s_andn2_b64 exec, exec, s[8:9]                   ;	exec = (exec & ~s[8:9]); scc=(exec!=0);
	s_cbranch_execnz .LBB0_11                        ;	jump if execnz is 1 (exec mask != 0)
.LBB0_12:
	s_or_b64 exec, exec, s[6:7]                      ;	exec = exec | s[6:7];  scc=(exec!=0);
	s_load_dwordx8 s[8:15], s[0:1], 0x20             ;	s[8:15] = load_dwordx8_from(s[0:1] + 0x20, glc=0);  // 8.2.1.1. Scalar Memory Addressing
	v_readfirstlane_b32 s3, v0
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_abs_i32 s0, s8
	v_cvt_f32_u32_e32 v1, s0
	s_sub_i32 s5, 0, s0                              ;	s5.i32 = (0.i32 - s0.i32); scc=(overflow or carry-out of last arith);
	s_abs_i32 s1, s12
	v_rcp_iflag_f32_e32 v1, v1
	s_nop 0                                          ;	s_nop  wait 1 cycles
	v_mul_f32_e32 v1, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v1, v1
	s_nop 0                                          ;	s_nop  wait 1 cycles
	v_readfirstlane_b32 s6, v1
	s_mul_i32 s5, s5, s6                             ;	s5 = s5 * s6
	s_mul_hi_u32 s5, s6, s5                          ;	s5 = s6 * s5
	s_add_i32 s6, s6, s5                             ;	s6.i32 = s6 + s5; scc=overflow_or_carry
	s_mul_hi_u32 s5, s1, s6                          ;	s5 = s1 * s6
	s_mul_i32 s6, s5, s0                             ;	s6 = s5 * s0
	s_sub_i32 s1, s1, s6                             ;	s1.i32 = (s1.i32 - s6.i32); scc=(overflow or carry-out of last arith);
	s_add_i32 s7, s5, 1                              ;	s7.i32 = s5 + 1; scc=overflow_or_carry
	s_sub_i32 s6, s1, s0                             ;	s6.i32 = (s1.i32 - s0.i32); scc=(overflow or carry-out of last arith);
	s_cmp_ge_u32 s1, s0                              ;	scc = (s1.u32 >= s0.u32)
	s_cselect_b32 s5, s7, s5                         ;	s5 = scc ? s7 : s5
	s_cselect_b32 s1, s6, s1                         ;	s1 = scc ? s6 : s1
	s_add_i32 s6, s5, 1                              ;	s6.i32 = s5 + 1; scc=overflow_or_carry
	s_cmp_ge_u32 s1, s0                              ;	scc = (s1.u32 >= s0.u32)
	s_cselect_b32 s0, s6, s5                         ;	s0 = scc ? s6 : s5
	s_cmpk_lt_u32 s3, 0xb40                          ;	scc = (s3.u32 < extend_as_u32(0xb40))
	s_cbranch_scc0 .LBB0_25                          ;	jump if scc is 0 (scc == 0)
; %bb.13:
	s_xor_b32 s1, s12, s8                            ;	s1 = s12 ^ s8;  scc=(s1!=0);
	s_ashr_i32 s1, s1, 31
	s_xor_b32 s0, s0, s1                             ;	s0 = s0 ^ s1;  scc=(s0!=0);
	s_sub_i32 s0, s0, s1                             ;	s0.i32 = (s0.i32 - s1.i32); scc=(overflow or carry-out of last arith);
	s_abs_i32 s1, s0
	v_cvt_f32_u32_e32 v1, s1
	s_ashr_i32 s5, s26, 31
	s_ashr_i32 s0, s0, 31
	s_xor_b32 s0, s5, s0                             ;	s0 = s5 ^ s0;  scc=(s0!=0);
	v_rcp_iflag_f32_e32 v1, v1
	s_sub_i32 s5, 0, s1                              ;	s5.i32 = (0.i32 - s1.i32); scc=(overflow or carry-out of last arith);
	s_abs_i32 s6, s26
	s_mul_i32 s7, s8, s2                             ;	s7 = s8 * s2
	v_mul_f32_e32 v1, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v1, v1
	s_mul_i32 s8, s11, s10                           ;	s8 = s11 * s10
	v_readfirstlane_b32 s27, v1
	s_mul_i32 s5, s5, s27                            ;	s5 = s5 * s27
	s_mul_hi_u32 s5, s27, s5                         ;	s5 = s27 * s5
	s_add_i32 s27, s27, s5                           ;	s27.i32 = s27 + s5; scc=overflow_or_carry
	s_mul_hi_u32 s5, s6, s27                         ;	s5 = s6 * s27
	s_mul_i32 s27, s5, s1                            ;	s27 = s5 * s1
	s_sub_i32 s6, s6, s27                            ;	s6.i32 = (s6.i32 - s27.i32); scc=(overflow or carry-out of last arith);
	s_add_i32 s28, s5, 1                             ;	s28.i32 = s5 + 1; scc=overflow_or_carry
	s_sub_i32 s27, s6, s1                            ;	s27.i32 = (s6.i32 - s1.i32); scc=(overflow or carry-out of last arith);
	s_cmp_ge_u32 s6, s1                              ;	scc = (s6.u32 >= s1.u32)
	s_cselect_b32 s5, s28, s5                        ;	s5 = scc ? s28 : s5
	s_cselect_b32 s6, s27, s6                        ;	s6 = scc ? s27 : s6
	s_add_i32 s27, s5, 1                             ;	s27.i32 = s5 + 1; scc=overflow_or_carry
	s_cmp_ge_u32 s6, s1                              ;	scc = (s6.u32 >= s1.u32)
	s_cselect_b32 s1, s27, s5                        ;	s1 = scc ? s27 : s5
	s_xor_b32 s1, s1, s0                             ;	s1 = s1 ^ s0;  scc=(s1!=0);
	s_sub_i32 s0, s1, s0                             ;	s0.i32 = (s1.i32 - s0.i32); scc=(overflow or carry-out of last arith);
	s_add_i32 s0, s0, s7                             ;	s0.i32 = s0 + s7; scc=overflow_or_carry
	s_mul_i32 s0, s0, s9                             ;	s0 = s0 * s9
	s_add_i32 s0, s0, s4                             ;	s0.i32 = s0 + s4; scc=overflow_or_carry
	s_mul_i32 s0, s8, s0                             ;	s0 = s8 * s0
	s_ashr_i32 s1, s0, 31
	s_lshl_b64 s[0:1], s[0:1], 1                     ;	s[0:1] = s[0:1] << 1[5:0]; scc=(s[0:1]!=0);
	s_add_u32 s0, s16, s0                            ;	s0.u32 = s16 + s0; scc=overflow_or_carry
	s_addc_u32 s1, s17, s1                           ;	s1.u32 = s17 + s1 + scc; scc=overflow_or_carry
	s_lshr_b32 s8, s3, 6
	v_and_b32_e32 v1, 63, v0                         ;	v1.u32 = (63 & v0.u32)
	v_lshlrev_b32_e32 v2, 2, v1                      ;	v2.b32 = v1 << 2;
	s_mul_i32 s3, s11, s8                            ;	s3 = s11 * s8
	s_add_i32 s5, s8, -4                             ;	s5.i32 = s8 + -4; scc=overflow_or_carry
	s_mul_i32 s9, s8, 0xa8                           ;	s9 = s8 * 0xa8
	v_cmp_gt_u32_e32 vcc, 40, v1                     ;	vcc.u64[laneId] = (40.u32  > v1.u32 )
	v_lshl_add_u32 v3, s3, 1, v2                     ;	v3.u32 = (s3.u32 << 1.u32[2 : 0].u32) + v2.u32
	s_lshl_b32 s3, s11, 3                            ;	s3 = s11 << 3[4:0]; scc=(s3!=0);
	s_add_i32 s16, s9, 0x154                         ;	s16.i32 = s9 + 0x154; scc=overflow_or_carry
	s_mov_b32 s17, s5                                ;	s17 = s5
	s_branch .LBB0_15
.LBB0_14:                               ;   in Loop: Header=BB0_15 Depth=1
	s_or_b64 exec, exec, s[6:7]                      ;	exec = exec | s[6:7];  scc=(exec!=0);
	s_add_i32 s17, s17, 4                            ;	s17.i32 = s17 + 4; scc=overflow_or_carry
	s_addk_i32 s16, 0x2a0
	s_cmp_gt_u32 s17, 40                             ;	scc = (s17.u32 > 40.u32)
	v_add_u32_e32 v3, s3, v3                         ;	v3 = s3 + v3
	s_cbranch_scc1 .LBB0_17                          ;	jump if scc is 1 (scc == 1)
.LBB0_15:                               ; =>This Inner Loop Header: Depth=1
	s_and_saveexec_b64 s[6:7], vcc                   ;	exec=vcc&exec; s[6:7]=old_exec; scc=(exec!=0)
	s_cbranch_execz .LBB0_14                         ;	jump if execz is 1 (exec mask == 0)
; %bb.16:                               ;   in Loop: Header=BB0_15 Depth=1
	v_readfirstlane_b32 s27, v1
	s_lshl_b32 s27, s27, 2                           ;	s27 = s27 << 2[4:0]; scc=(s27!=0);
	s_add_i32 s27, s16, s27                          ;	s27.i32 = s16 + s27; scc=overflow_or_carry
	;;#ASMSTART
	s_mov_b32 m0, s27                                ;	m0 = s27
	s_nop 1                                          ;	s_nop  wait 2 cycles

	;;#ASMEND
	;;#ASMSTART
	global_load_lds_dword v3, s[0:1] offset:0
	;;#ASMEND
	s_branch .LBB0_14
.LBB0_17:
	s_add_i32 s6, s10, s8                            ;	s6.i32 = s10 + s8; scc=overflow_or_carry
	s_mul_i32 s6, s11, s6                            ;	s6 = s11 * s6
	s_add_i32 s16, s9, 0x217c                        ;	s16.i32 = s9 + 0x217c; scc=overflow_or_carry
	v_lshl_add_u32 v3, s6, 1, v2                     ;	v3.u32 = (s6.u32 << 1.u32[2 : 0].u32) + v2.u32
	s_mov_b32 s17, s5                                ;	s17 = s5
	s_branch .LBB0_19
.LBB0_18:                               ;   in Loop: Header=BB0_19 Depth=1
	s_or_b64 exec, exec, s[6:7]                      ;	exec = exec | s[6:7];  scc=(exec!=0);
	s_add_i32 s17, s17, 4                            ;	s17.i32 = s17 + 4; scc=overflow_or_carry
	s_addk_i32 s16, 0x2a0
	s_cmp_lt_u32 s17, 41                             ;	scc = (s17.u32 < 41.u32)
	v_add_u32_e32 v3, s3, v3                         ;	v3 = s3 + v3
	s_cbranch_scc0 .LBB0_21                          ;	jump if scc is 0 (scc == 0)
.LBB0_19:                               ; =>This Inner Loop Header: Depth=1
	s_and_saveexec_b64 s[6:7], vcc                   ;	exec=vcc&exec; s[6:7]=old_exec; scc=(exec!=0)
	s_cbranch_execz .LBB0_18                         ;	jump if execz is 1 (exec mask == 0)
; %bb.20:                               ;   in Loop: Header=BB0_19 Depth=1
	v_readfirstlane_b32 s27, v1
	s_lshl_b32 s27, s27, 2                           ;	s27 = s27 << 2[4:0]; scc=(s27!=0);
	s_add_i32 s27, s16, s27                          ;	s27.i32 = s16 + s27; scc=overflow_or_carry
	;;#ASMSTART
	s_mov_b32 m0, s27                                ;	m0 = s27
	s_nop 1                                          ;	s_nop  wait 2 cycles

	;;#ASMEND
	;;#ASMSTART
	global_load_lds_dword v3, s[0:1] offset:0
	;;#ASMEND
	s_branch .LBB0_18
.LBB0_21:
	s_lshl_b32 s6, s10, 1                            ;	s6 = s10 << 1[4:0]; scc=(s6!=0);
	s_add_i32 s8, s8, s6                             ;	s8.i32 = s8 + s6; scc=overflow_or_carry
	s_mul_i32 s6, s11, s8                            ;	s6 = s11 * s8
	s_addk_i32 s9, 0x41a4
	v_lshl_add_u32 v2, s6, 1, v2                     ;	v2.u32 = (s6.u32 << 1.u32[2 : 0].u32) + v2.u32
	s_branch .LBB0_23
.LBB0_22:                               ;   in Loop: Header=BB0_23 Depth=1
	s_or_b64 exec, exec, s[6:7]                      ;	exec = exec | s[6:7];  scc=(exec!=0);
	s_add_i32 s5, s5, 4                              ;	s5.i32 = s5 + 4; scc=overflow_or_carry
	s_addk_i32 s9, 0x2a0
	s_cmp_lt_u32 s5, 41                              ;	scc = (s5.u32 < 41.u32)
	v_add_u32_e32 v2, s3, v2                         ;	v2 = s3 + v2
	s_cbranch_scc0 .LBB0_25                          ;	jump if scc is 0 (scc == 0)
.LBB0_23:                               ; =>This Inner Loop Header: Depth=1
	s_and_saveexec_b64 s[6:7], vcc                   ;	exec=vcc&exec; s[6:7]=old_exec; scc=(exec!=0)
	s_cbranch_execz .LBB0_22                         ;	jump if execz is 1 (exec mask == 0)
; %bb.24:                               ;   in Loop: Header=BB0_23 Depth=1
	v_readfirstlane_b32 s8, v1
	s_lshl_b32 s8, s8, 2                             ;	s8 = s8 << 2[4:0]; scc=(s8!=0);
	s_add_i32 s8, s9, s8                             ;	s8.i32 = s9 + s8; scc=overflow_or_carry
	;;#ASMSTART
	s_mov_b32 m0, s8                                 ;	m0 = s8
	s_nop 1                                          ;	s_nop  wait 2 cycles

	;;#ASMEND
	;;#ASMSTART
	global_load_lds_dword v2, s[0:1] offset:0
	;;#ASMEND
	s_branch .LBB0_22
.LBB0_25:
	s_mul_i32 s0, s26, 0x4b                          ;	s0 = s26 * 0x4b
	s_ashr_i32 s1, s0, 31
	s_lshl_b64 s[0:1], s[0:1], 1                     ;	s[0:1] = s[0:1] << 1[5:0]; scc=(s[0:1]!=0);
	s_add_u32 s0, s20, s0                            ;	s0.u32 = s20 + s0; scc=overflow_or_carry
	s_addc_u32 s1, s21, s1                           ;	s1.u32 = s21 + s1 + scc; scc=overflow_or_carry
	v_mov_b32_e32 v1, 0                              ;	v1 = 0;
	global_load_dwordx4 v[34:37], v1, s[0:1]         ;	v[34:37] = load_dwordx4_from_addr(v1 + s[0:1])
	global_load_dwordx4 v[30:33], v1, s[0:1] offset:16;	v[30:33] = load_dwordx4_from_addr(v1 + s[0:1] + 16)
	global_load_dwordx4 v[26:29], v1, s[0:1] offset:32;	v[26:29] = load_dwordx4_from_addr(v1 + s[0:1] + 32)
	global_load_dwordx4 v[22:25], v1, s[0:1] offset:48;	v[22:25] = load_dwordx4_from_addr(v1 + s[0:1] + 48)
	global_load_dwordx4 v[18:21], v1, s[0:1] offset:64;	v[18:21] = load_dwordx4_from_addr(v1 + s[0:1] + 64)
	global_load_dwordx4 v[14:17], v1, s[0:1] offset:80;	v[14:17] = load_dwordx4_from_addr(v1 + s[0:1] + 80)
	global_load_dwordx4 v[10:13], v1, s[0:1] offset:96;	v[10:13] = load_dwordx4_from_addr(v1 + s[0:1] + 96)
	global_load_dwordx4 v[6:9], v1, s[0:1] offset:112;	v[6:9] = load_dwordx4_from_addr(v1 + s[0:1] + 112)
	global_load_dwordx4 v[2:5], v1, s[0:1] offset:128;	v[2:5] = load_dwordx4_from_addr(v1 + s[0:1] + 128)
	global_load_dword v75, v1, s[0:1] offset:144     ;	v75 = load_dword_from_addr(v1 + s[0:1] + 144)
	global_load_ushort v76, v1, s[0:1] offset:148    ;	v76 = load_ushort_from_addr(v1 + s[0:1] + 148)
	s_cmp_lg_u64 s[22:23], 0                         ;	scc = (s[22:23].u64 <> 0.u64)
	s_mov_b64 s[0:1], 0                              ;	s[0:1] = 0
	s_cbranch_scc0 .LBB0_27                          ;	jump if scc is 0 (scc == 0)
; %bb.26:
	s_ashr_i32 s27, s26, 31
	s_lshl_b64 s[6:7], s[26:27], 1                   ;	s[6:7] = s[26:27] << 1[5:0]; scc=(s[6:7]!=0);
	s_add_u32 s6, s22, s6                            ;	s6.u32 = s22 + s6; scc=overflow_or_carry
	s_addc_u32 s7, s23, s7                           ;	s7.u32 = s23 + s7 + scc; scc=overflow_or_carry
	v_mov_b32_e32 v1, 0                              ;	v1 = 0;
	global_load_ushort v1, v1, s[6:7]                ;	v1 = load_ushort_from_addr(v1 + s[6:7])
	s_waitcnt vmcnt(0)
	v_lshlrev_b32_e32 v1, 16, v1                     ;	v1.b32 = v1 << 16;
.LBB0_27:
	s_mul_i32 s2, s12, s2                            ;	s2 = s12 * s2
	s_add_i32 s2, s2, s26                            ;	s2.i32 = s2 + s26; scc=overflow_or_carry
	s_mul_i32 s2, s2, s13                            ;	s2 = s2 * s13
	s_add_i32 s2, s2, s4                             ;	s2.i32 = s2 + s4; scc=overflow_or_carry
	s_mul_i32 s3, s15, s14                           ;	s3 = s15 * s14
	s_mul_i32 s2, s3, s2                             ;	s2 = s3 * s2
	s_ashr_i32 s3, s2, 31
	s_lshl_b64 s[2:3], s[2:3], 1                     ;	s[2:3] = s[2:3] << 1[5:0]; scc=(s[2:3]!=0);
	;;#ASMSTART
	s_waitcnt vmcnt(0)

	;;#ASMEND
	s_add_u32 s2, s18, s2                            ;	s2.u32 = s18 + s2; scc=overflow_or_carry
	s_waitcnt vmcnt(10)
	v_lshlrev_b32_e32 v38, 16, v34                   ;	v38.b32 = v34 << 16;
	v_and_b32_e32 v34, 0xffff0000, v34               ;	v34.u32 = (0xffff0000 & v34.u32)
	v_lshlrev_b32_e32 v39, 16, v35                   ;	v39.b32 = v35 << 16;
	v_and_b32_e32 v35, 0xffff0000, v35               ;	v35.u32 = (0xffff0000 & v35.u32)
	v_lshlrev_b32_e32 v40, 16, v36                   ;	v40.b32 = v36 << 16;
	v_and_b32_e32 v36, 0xffff0000, v36               ;	v36.u32 = (0xffff0000 & v36.u32)
	v_lshlrev_b32_e32 v41, 16, v37                   ;	v41.b32 = v37 << 16;
	v_and_b32_e32 v37, 0xffff0000, v37               ;	v37.u32 = (0xffff0000 & v37.u32)
	s_waitcnt vmcnt(9)
	v_lshlrev_b32_e32 v42, 16, v30                   ;	v42.b32 = v30 << 16;
	v_and_b32_e32 v30, 0xffff0000, v30               ;	v30.u32 = (0xffff0000 & v30.u32)
	v_lshlrev_b32_e32 v43, 16, v31                   ;	v43.b32 = v31 << 16;
	v_and_b32_e32 v31, 0xffff0000, v31               ;	v31.u32 = (0xffff0000 & v31.u32)
	v_lshlrev_b32_e32 v44, 16, v32                   ;	v44.b32 = v32 << 16;
	v_and_b32_e32 v32, 0xffff0000, v32               ;	v32.u32 = (0xffff0000 & v32.u32)
	v_lshlrev_b32_e32 v45, 16, v33                   ;	v45.b32 = v33 << 16;
	v_and_b32_e32 v33, 0xffff0000, v33               ;	v33.u32 = (0xffff0000 & v33.u32)
	s_waitcnt vmcnt(8)
	v_lshlrev_b32_e32 v46, 16, v26                   ;	v46.b32 = v26 << 16;
	v_and_b32_e32 v26, 0xffff0000, v26               ;	v26.u32 = (0xffff0000 & v26.u32)
	v_lshlrev_b32_e32 v47, 16, v27                   ;	v47.b32 = v27 << 16;
	v_and_b32_e32 v27, 0xffff0000, v27               ;	v27.u32 = (0xffff0000 & v27.u32)
	v_lshlrev_b32_e32 v48, 16, v28                   ;	v48.b32 = v28 << 16;
	v_and_b32_e32 v28, 0xffff0000, v28               ;	v28.u32 = (0xffff0000 & v28.u32)
	v_lshlrev_b32_e32 v49, 16, v29                   ;	v49.b32 = v29 << 16;
	v_and_b32_e32 v29, 0xffff0000, v29               ;	v29.u32 = (0xffff0000 & v29.u32)
	s_waitcnt vmcnt(7)
	v_lshlrev_b32_e32 v50, 16, v22                   ;	v50.b32 = v22 << 16;
	v_and_b32_e32 v22, 0xffff0000, v22               ;	v22.u32 = (0xffff0000 & v22.u32)
	v_lshlrev_b32_e32 v51, 16, v23                   ;	v51.b32 = v23 << 16;
	v_and_b32_e32 v23, 0xffff0000, v23               ;	v23.u32 = (0xffff0000 & v23.u32)
	v_lshlrev_b32_e32 v52, 16, v24                   ;	v52.b32 = v24 << 16;
	v_and_b32_e32 v24, 0xffff0000, v24               ;	v24.u32 = (0xffff0000 & v24.u32)
	v_lshlrev_b32_e32 v53, 16, v25                   ;	v53.b32 = v25 << 16;
	v_and_b32_e32 v25, 0xffff0000, v25               ;	v25.u32 = (0xffff0000 & v25.u32)
	s_waitcnt vmcnt(6)
	v_lshlrev_b32_e32 v54, 16, v18                   ;	v54.b32 = v18 << 16;
	v_and_b32_e32 v18, 0xffff0000, v18               ;	v18.u32 = (0xffff0000 & v18.u32)
	v_lshlrev_b32_e32 v55, 16, v19                   ;	v55.b32 = v19 << 16;
	v_and_b32_e32 v19, 0xffff0000, v19               ;	v19.u32 = (0xffff0000 & v19.u32)
	v_lshlrev_b32_e32 v56, 16, v20                   ;	v56.b32 = v20 << 16;
	v_and_b32_e32 v20, 0xffff0000, v20               ;	v20.u32 = (0xffff0000 & v20.u32)
	v_lshlrev_b32_e32 v57, 16, v21                   ;	v57.b32 = v21 << 16;
	v_and_b32_e32 v21, 0xffff0000, v21               ;	v21.u32 = (0xffff0000 & v21.u32)
	s_waitcnt vmcnt(5)
	v_lshlrev_b32_e32 v58, 16, v14                   ;	v58.b32 = v14 << 16;
	v_and_b32_e32 v14, 0xffff0000, v14               ;	v14.u32 = (0xffff0000 & v14.u32)
	v_lshlrev_b32_e32 v59, 16, v15                   ;	v59.b32 = v15 << 16;
	v_and_b32_e32 v15, 0xffff0000, v15               ;	v15.u32 = (0xffff0000 & v15.u32)
	v_lshlrev_b32_e32 v60, 16, v16                   ;	v60.b32 = v16 << 16;
	v_and_b32_e32 v16, 0xffff0000, v16               ;	v16.u32 = (0xffff0000 & v16.u32)
	v_lshlrev_b32_e32 v61, 16, v17                   ;	v61.b32 = v17 << 16;
	v_and_b32_e32 v17, 0xffff0000, v17               ;	v17.u32 = (0xffff0000 & v17.u32)
	s_waitcnt vmcnt(4)
	v_lshlrev_b32_e32 v62, 16, v10                   ;	v62.b32 = v10 << 16;
	v_and_b32_e32 v10, 0xffff0000, v10               ;	v10.u32 = (0xffff0000 & v10.u32)
	v_lshlrev_b32_e32 v63, 16, v11                   ;	v63.b32 = v11 << 16;
	v_and_b32_e32 v11, 0xffff0000, v11               ;	v11.u32 = (0xffff0000 & v11.u32)
	v_lshlrev_b32_e32 v64, 16, v12                   ;	v64.b32 = v12 << 16;
	v_and_b32_e32 v12, 0xffff0000, v12               ;	v12.u32 = (0xffff0000 & v12.u32)
	v_lshlrev_b32_e32 v65, 16, v13                   ;	v65.b32 = v13 << 16;
	v_and_b32_e32 v13, 0xffff0000, v13               ;	v13.u32 = (0xffff0000 & v13.u32)
	s_waitcnt vmcnt(3)
	v_lshlrev_b32_e32 v66, 16, v6                    ;	v66.b32 = v6 << 16;
	v_and_b32_e32 v6, 0xffff0000, v6                 ;	v6.u32 = (0xffff0000 & v6.u32)
	v_lshlrev_b32_e32 v67, 16, v7                    ;	v67.b32 = v7 << 16;
	v_and_b32_e32 v7, 0xffff0000, v7                 ;	v7.u32 = (0xffff0000 & v7.u32)
	v_lshlrev_b32_e32 v68, 16, v8                    ;	v68.b32 = v8 << 16;
	v_and_b32_e32 v8, 0xffff0000, v8                 ;	v8.u32 = (0xffff0000 & v8.u32)
	v_lshlrev_b32_e32 v69, 16, v9                    ;	v69.b32 = v9 << 16;
	v_and_b32_e32 v9, 0xffff0000, v9                 ;	v9.u32 = (0xffff0000 & v9.u32)
	s_waitcnt vmcnt(2)
	v_lshlrev_b32_e32 v70, 16, v2                    ;	v70.b32 = v2 << 16;
	v_and_b32_e32 v2, 0xffff0000, v2                 ;	v2.u32 = (0xffff0000 & v2.u32)
	v_lshlrev_b32_e32 v71, 16, v3                    ;	v71.b32 = v3 << 16;
	v_and_b32_e32 v3, 0xffff0000, v3                 ;	v3.u32 = (0xffff0000 & v3.u32)
	v_lshlrev_b32_e32 v72, 16, v4                    ;	v72.b32 = v4 << 16;
	v_and_b32_e32 v4, 0xffff0000, v4                 ;	v4.u32 = (0xffff0000 & v4.u32)
	v_lshlrev_b32_e32 v73, 16, v5                    ;	v73.b32 = v5 << 16;
	v_and_b32_e32 v5, 0xffff0000, v5                 ;	v5.u32 = (0xffff0000 & v5.u32)
	s_waitcnt vmcnt(1)
	v_lshlrev_b32_e32 v74, 16, v75                   ;	v74.b32 = v75 << 16;
	v_and_b32_e32 v75, 0xffff0000, v75               ;	v75.u32 = (0xffff0000 & v75.u32)
	s_waitcnt vmcnt(0)
	v_lshlrev_b32_e32 v76, 16, v76                   ;	v76.b32 = v76 << 16;
	s_addc_u32 s3, s19, s3                           ;	s3.u32 = s19 + s3 + scc; scc=overflow_or_carry
	v_lshlrev_b32_e32 v0, 1, v0                      ;	v0.b32 = v0 << 1;
	s_mov_b32 s4, 0xcccd                             ;	s4 = 0xcccd
	s_movk_i32 s5, 0xa8
	s_movk_i32 s6, 0x7fff
	s_mov_b32 s7, 0x7060302                          ;	s7 = 0x7060302
	s_movk_i32 s8, 0xe0f
	s_barrier
.LBB0_28:                               ; =>This Inner Loop Header: Depth=1
	v_mul_u32_u24_sdwa v77, v0, s4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
	v_lshrrev_b32_e32 v77, 22, v77                   ;	v77.b32 = v77 >> 22;
	v_mul_lo_u16_e32 v78, 0x50, v77
	v_sub_u16_e32 v78, v0, v78
	v_lshlrev_b32_e32 v79, 1, v78                    ;	v79.b32 = v78 << 1;
	v_mad_u32_u24 v79, v77, s5, v79
	;;#ASMSTART
	ds_read_b32 v80, v79 offset:0                    ;	v80 = LDS_MEM[v79 + 0].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v81, v79 offset:4                    ;	v81 = LDS_MEM[v79 + 4].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v82, v79 offset:8                    ;	v82 = LDS_MEM[v79 + 8].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v83, v79 offset:0xa8                 ;	v83 = LDS_MEM[v79 + 168].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v84, v79 offset:0xac                 ;	v84 = LDS_MEM[v79 + 172].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v85, v79 offset:0xb0                 ;	v85 = LDS_MEM[v79 + 176].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v86, v79 offset:0x150                ;	v86 = LDS_MEM[v79 + 336].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v87, v79 offset:0x154                ;	v87 = LDS_MEM[v79 + 340].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v88, v79 offset:0x158                ;	v88 = LDS_MEM[v79 + 344].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v89, v79 offset:0x1f8                ;	v89 = LDS_MEM[v79 + 504].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v90, v79 offset:0x1fc                ;	v90 = LDS_MEM[v79 + 508].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v91, v79 offset:0x200                ;	v91 = LDS_MEM[v79 + 512].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v92, v79 offset:0x2a0                ;	v92 = LDS_MEM[v79 + 672].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v93, v79 offset:0x2a4                ;	v93 = LDS_MEM[v79 + 676].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v94, v79 offset:0x2a8                ;	v94 = LDS_MEM[v79 + 680].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v95, v79 offset:0x2028               ;	v95 = LDS_MEM[v79 + 8232].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v96, v79 offset:0x202c               ;	v96 = LDS_MEM[v79 + 8236].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v97, v79 offset:0x2030               ;	v97 = LDS_MEM[v79 + 8240].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v98, v79 offset:0x20d0               ;	v98 = LDS_MEM[v79 + 8400].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v99, v79 offset:0x20d4               ;	v99 = LDS_MEM[v79 + 8404].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v100, v79 offset:0x20d8              ;	v100 = LDS_MEM[v79 + 8408].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v101, v79 offset:0x2178              ;	v101 = LDS_MEM[v79 + 8568].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v102, v79 offset:0x217c              ;	v102 = LDS_MEM[v79 + 8572].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v103, v79 offset:0x2180              ;	v103 = LDS_MEM[v79 + 8576].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v104, v79 offset:0x2220              ;	v104 = LDS_MEM[v79 + 8736].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v105, v79 offset:0x2224              ;	v105 = LDS_MEM[v79 + 8740].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v106, v79 offset:0x2228              ;	v106 = LDS_MEM[v79 + 8744].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v107, v79 offset:0x22c8              ;	v107 = LDS_MEM[v79 + 8904].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v108, v79 offset:0x22cc              ;	v108 = LDS_MEM[v79 + 8908].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v109, v79 offset:0x22d0              ;	v109 = LDS_MEM[v79 + 8912].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v110, v79 offset:0x4050              ;	v110 = LDS_MEM[v79 + 16464].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v111, v79 offset:0x4054              ;	v111 = LDS_MEM[v79 + 16468].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v112, v79 offset:0x4058              ;	v112 = LDS_MEM[v79 + 16472].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v113, v79 offset:0x40f8              ;	v113 = LDS_MEM[v79 + 16632].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v114, v79 offset:0x40fc              ;	v114 = LDS_MEM[v79 + 16636].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v115, v79 offset:0x4100              ;	v115 = LDS_MEM[v79 + 16640].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v116, v79 offset:0x41a0              ;	v116 = LDS_MEM[v79 + 16800].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v117, v79 offset:0x41a4              ;	v117 = LDS_MEM[v79 + 16804].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v118, v79 offset:0x41a8              ;	v118 = LDS_MEM[v79 + 16808].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v119, v79 offset:0x4248              ;	v119 = LDS_MEM[v79 + 16968].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v120, v79 offset:0x424c              ;	v120 = LDS_MEM[v79 + 16972].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v121, v79 offset:0x4250              ;	v121 = LDS_MEM[v79 + 16976].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v122, v79 offset:0x42f0              ;	v122 = LDS_MEM[v79 + 17136].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v123, v79 offset:0x42f4              ;	v123 = LDS_MEM[v79 + 17140].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	ds_read_b32 v124, v79 offset:0x42f8              ;	v124 = LDS_MEM[v79 + 17144].b32; // read w/o any type convertion
	;;#ASMEND
	;;#ASMSTART
	s_waitcnt lgkmcnt(0)

	;;#ASMEND
	; sched_barrier mask(0x00000000)
	v_mov_b32_e32 v125, v1                           ;	v125 = v1;
	v_mad_u64_u32 v[78:79], s[10:11], s15, v77, v[78:79]
	v_lshlrev_b32_e32 v77, 16, v80                   ;	v77.b32 = v80 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v38, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v80               ;	v77.u32 = (0xffff0000 & v80.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v34, v77
	;;#ASMEND
	v_lshlrev_b32_e32 v80, 16, v81                   ;	v80.b32 = v81 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v39, v80
	;;#ASMEND
	v_and_b32_e32 v81, 0xffff0000, v81               ;	v81.u32 = (0xffff0000 & v81.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v35, v81
	;;#ASMEND
	v_lshlrev_b32_e32 v126, 16, v82                  ;	v126.b32 = v82 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v40, v126
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v83                   ;	v79.b32 = v83 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v36, v79
	;;#ASMEND
	v_and_b32_e32 v83, 0xffff0000, v83               ;	v83.u32 = (0xffff0000 & v83.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v41, v83
	;;#ASMEND
	v_lshlrev_b32_e32 v127, 16, v84                  ;	v127.b32 = v84 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v37, v127
	;;#ASMEND
	v_and_b32_e32 v84, 0xffff0000, v84               ;	v84.u32 = (0xffff0000 & v84.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v42, v84
	;;#ASMEND
	v_lshlrev_b32_e32 v128, 16, v85                  ;	v128.b32 = v85 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v30, v128
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v86                   ;	v79.b32 = v86 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v43, v79
	;;#ASMEND
	v_and_b32_e32 v86, 0xffff0000, v86               ;	v86.u32 = (0xffff0000 & v86.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v31, v86
	;;#ASMEND
	v_lshlrev_b32_e32 v129, 16, v87                  ;	v129.b32 = v87 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v44, v129
	;;#ASMEND
	v_and_b32_e32 v87, 0xffff0000, v87               ;	v87.u32 = (0xffff0000 & v87.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v32, v87
	;;#ASMEND
	v_lshlrev_b32_e32 v130, 16, v88                  ;	v130.b32 = v88 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v45, v130
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v89                   ;	v79.b32 = v89 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v33, v79
	;;#ASMEND
	v_and_b32_e32 v89, 0xffff0000, v89               ;	v89.u32 = (0xffff0000 & v89.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v46, v89
	;;#ASMEND
	v_lshlrev_b32_e32 v131, 16, v90                  ;	v131.b32 = v90 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v26, v131
	;;#ASMEND
	v_and_b32_e32 v90, 0xffff0000, v90               ;	v90.u32 = (0xffff0000 & v90.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v47, v90
	;;#ASMEND
	v_lshlrev_b32_e32 v132, 16, v91                  ;	v132.b32 = v91 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v27, v132
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v92                   ;	v79.b32 = v92 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v48, v79
	;;#ASMEND
	v_and_b32_e32 v92, 0xffff0000, v92               ;	v92.u32 = (0xffff0000 & v92.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v28, v92
	;;#ASMEND
	v_lshlrev_b32_e32 v133, 16, v93                  ;	v133.b32 = v93 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v49, v133
	;;#ASMEND
	v_and_b32_e32 v93, 0xffff0000, v93               ;	v93.u32 = (0xffff0000 & v93.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v29, v93
	;;#ASMEND
	v_lshlrev_b32_e32 v134, 16, v94                  ;	v134.b32 = v94 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v50, v134
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v95                   ;	v79.b32 = v95 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v22, v79
	;;#ASMEND
	v_and_b32_e32 v95, 0xffff0000, v95               ;	v95.u32 = (0xffff0000 & v95.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v51, v95
	;;#ASMEND
	v_lshlrev_b32_e32 v135, 16, v96                  ;	v135.b32 = v96 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v23, v135
	;;#ASMEND
	v_and_b32_e32 v96, 0xffff0000, v96               ;	v96.u32 = (0xffff0000 & v96.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v52, v96
	;;#ASMEND
	v_lshlrev_b32_e32 v136, 16, v97                  ;	v136.b32 = v97 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v24, v136
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v98                   ;	v79.b32 = v98 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v53, v79
	;;#ASMEND
	v_and_b32_e32 v98, 0xffff0000, v98               ;	v98.u32 = (0xffff0000 & v98.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v25, v98
	;;#ASMEND
	v_lshlrev_b32_e32 v137, 16, v99                  ;	v137.b32 = v99 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v54, v137
	;;#ASMEND
	v_and_b32_e32 v99, 0xffff0000, v99               ;	v99.u32 = (0xffff0000 & v99.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v18, v99
	;;#ASMEND
	v_lshlrev_b32_e32 v138, 16, v100                 ;	v138.b32 = v100 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v55, v138
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v101                  ;	v79.b32 = v101 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v19, v79
	;;#ASMEND
	v_and_b32_e32 v101, 0xffff0000, v101             ;	v101.u32 = (0xffff0000 & v101.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v56, v101
	;;#ASMEND
	v_lshlrev_b32_e32 v139, 16, v102                 ;	v139.b32 = v102 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v20, v139
	;;#ASMEND
	v_and_b32_e32 v102, 0xffff0000, v102             ;	v102.u32 = (0xffff0000 & v102.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v57, v102
	;;#ASMEND
	v_lshlrev_b32_e32 v140, 16, v103                 ;	v140.b32 = v103 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v21, v140
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v104                  ;	v79.b32 = v104 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v58, v79
	;;#ASMEND
	v_and_b32_e32 v104, 0xffff0000, v104             ;	v104.u32 = (0xffff0000 & v104.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v14, v104
	;;#ASMEND
	v_lshlrev_b32_e32 v141, 16, v105                 ;	v141.b32 = v105 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v59, v141
	;;#ASMEND
	v_and_b32_e32 v105, 0xffff0000, v105             ;	v105.u32 = (0xffff0000 & v105.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v15, v105
	;;#ASMEND
	v_lshlrev_b32_e32 v142, 16, v106                 ;	v142.b32 = v106 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v60, v142
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v107                  ;	v79.b32 = v107 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v16, v79
	;;#ASMEND
	v_and_b32_e32 v107, 0xffff0000, v107             ;	v107.u32 = (0xffff0000 & v107.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v61, v107
	;;#ASMEND
	v_lshlrev_b32_e32 v143, 16, v108                 ;	v143.b32 = v108 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v17, v143
	;;#ASMEND
	v_and_b32_e32 v108, 0xffff0000, v108             ;	v108.u32 = (0xffff0000 & v108.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v62, v108
	;;#ASMEND
	v_lshlrev_b32_e32 v144, 16, v109                 ;	v144.b32 = v109 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v10, v144
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v110                  ;	v79.b32 = v110 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v63, v79
	;;#ASMEND
	v_and_b32_e32 v110, 0xffff0000, v110             ;	v110.u32 = (0xffff0000 & v110.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v11, v110
	;;#ASMEND
	v_lshlrev_b32_e32 v145, 16, v111                 ;	v145.b32 = v111 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v64, v145
	;;#ASMEND
	v_and_b32_e32 v111, 0xffff0000, v111             ;	v111.u32 = (0xffff0000 & v111.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v12, v111
	;;#ASMEND
	v_lshlrev_b32_e32 v146, 16, v112                 ;	v146.b32 = v112 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v65, v146
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v113                  ;	v79.b32 = v113 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v13, v79
	;;#ASMEND
	v_and_b32_e32 v113, 0xffff0000, v113             ;	v113.u32 = (0xffff0000 & v113.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v66, v113
	;;#ASMEND
	v_lshlrev_b32_e32 v147, 16, v114                 ;	v147.b32 = v114 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v6, v147
	;;#ASMEND
	v_and_b32_e32 v114, 0xffff0000, v114             ;	v114.u32 = (0xffff0000 & v114.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v67, v114
	;;#ASMEND
	v_lshlrev_b32_e32 v148, 16, v115                 ;	v148.b32 = v115 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v7, v148
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v116                  ;	v79.b32 = v116 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v68, v79
	;;#ASMEND
	v_and_b32_e32 v116, 0xffff0000, v116             ;	v116.u32 = (0xffff0000 & v116.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v8, v116
	;;#ASMEND
	v_lshlrev_b32_e32 v149, 16, v117                 ;	v149.b32 = v117 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v69, v149
	;;#ASMEND
	v_and_b32_e32 v117, 0xffff0000, v117             ;	v117.u32 = (0xffff0000 & v117.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v9, v117
	;;#ASMEND
	v_lshlrev_b32_e32 v150, 16, v118                 ;	v150.b32 = v118 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v70, v150
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v119                  ;	v79.b32 = v119 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v2, v79
	;;#ASMEND
	v_and_b32_e32 v119, 0xffff0000, v119             ;	v119.u32 = (0xffff0000 & v119.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v71, v119
	;;#ASMEND
	v_lshlrev_b32_e32 v151, 16, v120                 ;	v151.b32 = v120 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v3, v151
	;;#ASMEND
	v_and_b32_e32 v120, 0xffff0000, v120             ;	v120.u32 = (0xffff0000 & v120.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v72, v120
	;;#ASMEND
	v_lshlrev_b32_e32 v152, 16, v121                 ;	v152.b32 = v121 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v4, v152
	;;#ASMEND
	v_lshlrev_b32_e32 v79, 16, v122                  ;	v79.b32 = v122 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v73, v79
	;;#ASMEND
	v_and_b32_e32 v122, 0xffff0000, v122             ;	v122.u32 = (0xffff0000 & v122.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v5, v122
	;;#ASMEND
	v_lshlrev_b32_e32 v153, 16, v123                 ;	v153.b32 = v123 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v74, v153
	;;#ASMEND
	v_and_b32_e32 v123, 0xffff0000, v123             ;	v123.u32 = (0xffff0000 & v123.u32)
	;;#ASMSTART
	v_fmac_f32 v125, v75, v123
	;;#ASMEND
	v_mov_b32_e32 v155, v1                           ;	v155 = v1;
	v_lshlrev_b32_e32 v154, 16, v124                 ;	v154.b32 = v124 << 16;
	;;#ASMSTART
	v_fmac_f32 v125, v76, v154
	;;#ASMEND
	;;#ASMSTART
	v_fmac_f32 v155, v38, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v82               ;	v77.u32 = (0xffff0000 & v82.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v34, v80
	;;#ASMEND
	v_or_b32_e32 v80, 0x400000, v125
	;;#ASMSTART
	v_fmac_f32 v155, v39, v81
	;;#ASMEND
	v_cmp_u_f32_e32 vcc, v125, v125                  ;	vcc.u64[laneId] = (v125.f32  not-orderable v125.f32 )
	;;#ASMSTART
	v_fmac_f32 v155, v35, v126
	;;#ASMEND
	v_ashrrev_i32_e32 v79, 31, v78
	;;#ASMSTART
	v_fmac_f32 v155, v40, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v85               ;	v77.u32 = (0xffff0000 & v85.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v36, v83
	;;#ASMEND
	v_lshl_add_u64 v[78:79], v[78:79], 1, s[2:3]     ;	v[78:79].u64 = (v[78:79].u64 << 1.u32[2 : 0].u32) + s[2:3].u64
	;;#ASMSTART
	v_fmac_f32 v155, v41, v127
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v37, v84
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v42, v128
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v30, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v88               ;	v77.u32 = (0xffff0000 & v88.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v43, v86
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v31, v129
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v44, v87
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v32, v130
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v45, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v91               ;	v77.u32 = (0xffff0000 & v91.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v33, v89
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v46, v131
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v26, v90
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v47, v132
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v27, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v94               ;	v77.u32 = (0xffff0000 & v94.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v48, v92
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v28, v133
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v49, v93
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v29, v134
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v50, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v97               ;	v77.u32 = (0xffff0000 & v97.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v22, v95
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v51, v135
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v23, v96
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v52, v136
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v24, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v100              ;	v77.u32 = (0xffff0000 & v100.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v53, v98
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v25, v137
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v54, v99
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v18, v138
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v55, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v103              ;	v77.u32 = (0xffff0000 & v103.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v19, v101
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v56, v139
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v20, v102
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v57, v140
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v21, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v106              ;	v77.u32 = (0xffff0000 & v106.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v58, v104
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v14, v141
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v59, v105
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v15, v142
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v60, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v109              ;	v77.u32 = (0xffff0000 & v109.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v16, v107
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v61, v143
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v17, v108
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v62, v144
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v10, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v112              ;	v77.u32 = (0xffff0000 & v112.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v63, v110
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v11, v145
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v64, v111
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v12, v146
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v65, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v115              ;	v77.u32 = (0xffff0000 & v115.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v13, v113
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v66, v147
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v6, v114
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v67, v148
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v7, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v118              ;	v77.u32 = (0xffff0000 & v118.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v68, v116
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v8, v149
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v69, v117
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v9, v150
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v70, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v121              ;	v77.u32 = (0xffff0000 & v121.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v2, v119
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v71, v151
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v3, v120
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v72, v152
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v4, v77
	;;#ASMEND
	v_and_b32_e32 v77, 0xffff0000, v124              ;	v77.u32 = (0xffff0000 & v124.u32)
	;;#ASMSTART
	v_fmac_f32 v155, v73, v122
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v5, v153
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v74, v123
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v75, v154
	;;#ASMEND
	s_nop 0                                          ;	s_nop  wait 1 cycles
	;;#ASMSTART
	v_fmac_f32 v155, v76, v77
	;;#ASMEND
	s_load_dword s9, s[24:25], 0xc                   ;	s9 = load_dword_from(s[24:25] + 0xc, glc=0);  // 8.2.1.1. Scalar Memory Addressing
	v_bfe_u32 v77, v125, 16, 1                       ;	v77 = ((v125.u32 >> 16[4:0].u32) & ((1U << 1[4:0].u32) - 1U))
	v_add3_u32 v77, v77, v125, s6
	v_cndmask_b32_e32 v77, v77, v80, vcc             ;	v77.b32 = vcc.u64[laneId] ? v80.u32 : v77.u32
	v_bfe_u32 v80, v155, 16, 1                       ;	v80 = ((v155.u32 >> 16[4:0].u32) & ((1U << 1[4:0].u32) - 1U))
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff                         ;	s9 = s9 & 0xffff
	v_add3_u32 v80, v80, v155, s6
	v_or_b32_e32 v81, 0x400000, v155
	v_cmp_u_f32_e32 vcc, v155, v155                  ;	vcc.u64[laneId] = (v155.f32  not-orderable v155.f32 )
	v_lshl_add_u32 v0, s9, 1, v0                     ;	v0.u32 = (s9.u32 << 1.u32[2 : 0].u32) + v0.u32
	s_nop 0                                          ;	s_nop  wait 1 cycles
	v_cndmask_b32_e32 v80, v80, v81, vcc             ;	v80.b32 = vcc.u64[laneId] ? v81.u32 : v80.u32
	v_cmp_lt_u32_e32 vcc, s8, v0                     ;	vcc.u64[laneId] = (s8.u32  < v0.u32 )
	v_perm_b32 v77, v80, v77, s7
	s_or_b64 s[0:1], vcc, s[0:1]                     ;	s[0:1] = vcc | s[0:1];  scc=(s[0:1]!=0);
	global_store_dword v[78:79], v77, off            ;	save_dword_to_addr(v77, addr=v[78:79])
	s_andn2_b64 exec, exec, s[0:1]                   ;	exec = (exec & ~s[0:1]); scc=(exec!=0);
	s_cbranch_execnz .LBB0_28                        ;	jump if execnz is 1 (exec mask != 0)
; %bb.29:
	s_endpgm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
		.amdhsa_group_segment_fixed_size 32576
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 320
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_kernarg_preload_length 0
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 1
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 169
		.amdhsa_next_free_sgpr 96
		.amdhsa_accum_offset 156
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_tg_split 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
.Lfunc_end0:
	.size	miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1, .Lfunc_end0-miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
                                        ; -- End function
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.num_vgpr, 156
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.num_agpr, 0
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.numbered_sgpr, 29
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.private_seg_size, 0
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.uses_vcc, 1
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.uses_flat_scratch, 0
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.has_dyn_sized_stack, 0
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.has_recursion, 0
	.set miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 4512
; TotalNumSgprs: 35
; NumVgprs: 156
; NumAgprs: 0
; TotalNumVgprs: 156
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 32576 bytes/workgroup (compile time only)
; SGPRBlocks: 12
; VGPRBlocks: 21
; NumSGPRsForWavesPerEU: 102
; NumVGPRsForWavesPerEU: 169
; AccumOffset: 156
; Occupancy: 2
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 1
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 38
; COMPUTE_PGM_RSRC3_GFX90A:TG_SPLIT: 0
	.text
	.p2alignl 6, 3212836864
	.fill 256, 4, 3212836864
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.text
	.type	__hip_cuid_e444e13eaca7eba4,@object ; @__hip_cuid_e444e13eaca7eba4
	.section	.bss,"aw",@nobits
	.globl	__hip_cuid_e444e13eaca7eba4
__hip_cuid_e444e13eaca7eba4:
	.byte	0                               ; 0x0
	.size	__hip_cuid_e444e13eaca7eba4, 1

	.ident	"AMD clang version 20.0.0git (https://github.com/RadeonOpenCompute/llvm-project roc-7.1.1 25444 27682a16360e33e37c4f3cc6adf9a620733f8fe1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __hip_cuid_e444e13eaca7eba4
	.amdgpu_metadata
---
amdhsa.kernels:
  - .agpr_count:     0
    .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .actual_access:  write_only
        .address_space:  global
        .offset:         8
        .size:           8
        .value_kind:     global_buffer
      - .actual_access:  read_only
        .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .actual_access:  read_only
        .address_space:  global
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .offset:         32
        .size:           4
        .value_kind:     by_value
      - .offset:         36
        .size:           4
        .value_kind:     by_value
      - .offset:         40
        .size:           4
        .value_kind:     by_value
      - .offset:         44
        .size:           4
        .value_kind:     by_value
      - .offset:         48
        .size:           4
        .value_kind:     by_value
      - .offset:         52
        .size:           4
        .value_kind:     by_value
      - .offset:         56
        .size:           4
        .value_kind:     by_value
      - .offset:         60
        .size:           4
        .value_kind:     by_value
      - .offset:         64
        .size:           4
        .value_kind:     hidden_block_count_x
      - .offset:         68
        .size:           4
        .value_kind:     hidden_block_count_y
      - .offset:         72
        .size:           4
        .value_kind:     hidden_block_count_z
      - .offset:         76
        .size:           2
        .value_kind:     hidden_group_size_x
      - .offset:         78
        .size:           2
        .value_kind:     hidden_group_size_y
      - .offset:         80
        .size:           2
        .value_kind:     hidden_group_size_z
      - .offset:         82
        .size:           2
        .value_kind:     hidden_remainder_x
      - .offset:         84
        .size:           2
        .value_kind:     hidden_remainder_y
      - .offset:         86
        .size:           2
        .value_kind:     hidden_remainder_z
      - .offset:         104
        .size:           8
        .value_kind:     hidden_global_offset_x
      - .offset:         112
        .size:           8
        .value_kind:     hidden_global_offset_y
      - .offset:         120
        .size:           8
        .value_kind:     hidden_global_offset_z
      - .offset:         128
        .size:           2
        .value_kind:     hidden_grid_dims
    .group_segment_fixed_size: 32576
    .kernarg_segment_align: 8
    .kernarg_segment_size: 320
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 256
    .name:           miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
    .private_segment_fixed_size: 0
    .sgpr_count:     35
    .sgpr_spill_count: 0
    .symbol:         miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     156
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx942
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
