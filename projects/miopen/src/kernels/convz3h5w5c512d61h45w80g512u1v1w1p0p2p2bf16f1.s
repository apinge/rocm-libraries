/*******************************************************************************
 *
 * MIT License
 *
 * Copyright (c) 2026 Advanced Micro Devices, Inc.
 *
 * Placeholder GCN kernel for ConvAsmDw3dZ3h5w5c512d61h45w80Bf16 (3D depthwise bf16).
 * Replace the body after the prolog with real logic. Targets gfx942 / gfx950 (gfx9).
 *
 *******************************************************************************/
.include "rocm_version.inc"
.include "inst_wrappers.inc"

.if ROCM_METADATA_VERSION == 4
.hsa_code_object_version 2,1
.hsa_code_object_isa
.endif

.if (.option.machine_version_major != 8) && (.option.machine_version_major != 9)
.error "ERROR: specified target machine not supported"
.endif

.set LDS_SIZE, 0
.if ROCM_METADATA_VERSION == 4
    .set SGPR_COUNT, 48
.else
    .set SGPR_COUNT, 48
.endif
.set VGPR_COUNT, 8

.text
.p2align 8
.global miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
.type miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1, @function

.if ROCM_METADATA_VERSION == 4
.amdgpu_hsa_kernel miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
.endif

miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1:

.if ROCM_METADATA_VERSION == 4
   .amd_kernel_code_t
      amd_machine_version_major = .option.machine_version_major
      amd_machine_version_minor = .option.machine_version_minor
      amd_machine_version_stepping = .option.machine_version_stepping
      is_ptr64 = 1
      float_mode = 0
      user_sgpr_count = 2
      is_xnack_enabled = 0
      enable_sgpr_workgroup_id_x = 1
      enable_sgpr_workgroup_id_y = 1
      enable_sgpr_workgroup_id_z = 1
      enable_vgpr_workitem_id = 1
      enable_sgpr_kernarg_segment_ptr = 1
      workitem_vgpr_count = VGPR_COUNT
      wavefront_sgpr_count = SGPR_COUNT
      workgroup_group_segment_byte_size = LDS_SIZE
      kernarg_segment_byte_size = 32
      granulated_workitem_vgpr_count = (VGPR_COUNT-1)/4
      granulated_wavefront_sgpr_count = (SGPR_COUNT-1)/8
  .end_amd_kernel_code_t
.endif

  s_mov_b32 m0, LDS_SIZE
  s_endpgm

.if ROCM_METADATA_VERSION == 5
.rodata
.p2align 6
; gfx942/gfx950: architected flat scratch — omit .amdhsa_reserve_flat_scratch / reserve_vcc / reserve_xnack
; (same style as dynamic_igemm/.../gfx950/*.s in this repo).
.amdhsa_kernel miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
    .amdhsa_group_segment_fixed_size LDS_SIZE
    .amdhsa_user_sgpr_kernarg_segment_ptr 1
    .amdhsa_system_sgpr_workgroup_id_x 1
    .amdhsa_system_sgpr_workgroup_id_y 1
    .amdhsa_system_sgpr_workgroup_id_z 1
    .amdhsa_system_vgpr_workitem_id 1
    .amdhsa_next_free_vgpr VGPR_COUNT
    .amdhsa_next_free_sgpr SGPR_COUNT
    .amdhsa_ieee_mode 0
    .amdhsa_dx10_clamp 0
    .amdhsa_float_round_mode_32 0
    .amdhsa_float_round_mode_16_64 0
    .amdhsa_tg_split 0
    ; (VGPR_COUNT+3)/4*4 with VGPR_COUNT=8 -> 8
    .amdhsa_accum_offset 8
.end_amdhsa_kernel

.altmacro
.macro METADATA sc, vc, lds_size
.amdgpu_metadata
---
amdhsa.version: [ 1, 0 ]
amdhsa.kernels:
  - .name: miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1
    .symbol: miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.kd
    .sgpr_count: \sc
    .vgpr_count: \vc
    .language: "OpenCL C"
    .language_version: [ 1, 2 ]
    .kernarg_segment_size: 32
    .group_segment_fixed_size: \lds_size
    .private_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .wavefront_size: 64
    .reqd_workgroup_size: [ 64, 1, 1 ]
    .max_flat_workgroup_size: 64
    .args:
    - { .size: 8, .offset:  0, .value_kind: global_buffer, .value_type: f32, .name: in,      .address_space: global, .is_const: true }
    - { .size: 8, .offset:  8, .value_kind: global_buffer, .value_type: f32, .name: weights, .address_space: global, .is_const: true }
    - { .size: 8, .offset: 16, .value_kind: global_buffer, .value_type: f32, .name: out,     .address_space: global, .is_const: false }
    - { .size: 4, .offset: 24, .value_kind: by_value,      .value_type: f32, .name: padding_val }
...
.end_amdgpu_metadata
.endm // METADATA

METADATA %SGPR_COUNT, %VGPR_COUNT, %LDS_SIZE

.elseif ROCM_METADATA_VERSION == 4
.amd_amdgpu_hsa_metadata
{ Version: [ 1, 0 ],
    Kernels:
    - {
        Name: miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1, SymbolName: 'miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1@kd', Language: OpenCL C, LanguageVersion: [ 1, 2 ],
        Attrs: { ReqdWorkGroupSize: [ 64, 1, 1 ] }
        CodeProps:
          { KernargSegmentSize: 32, GroupSegmentFixedSize: 0, PrivateSegmentFixedSize: 0, KernargSegmentAlign: 8, WavefrontSize: 64, MaxFlatWorkGroupSize: 64 }
        Args:
        - { Size: 8, Align: 8, ValueKind: GlobalBuffer, ValueType: F32, TypeName: 'float*', Name: in,          AddrSpaceQual: Global, AccQual: Default, IsConst: true }
        - { Size: 8, Align: 8, ValueKind: GlobalBuffer, ValueType: F32, TypeName: 'float*', Name: weights,     AddrSpaceQual: Global, AccQual: Default, IsConst: true }
        - { Size: 8, Align: 8, ValueKind: GlobalBuffer, ValueType: F32, TypeName: 'float*', Name: out,         AddrSpaceQual: Global, AccQual: Default }
        - { Size: 4, Align: 4, ValueKind: ByValue,      ValueType: F32, TypeName:  float,   Name: padding_val,                        AccQual: Default }
      }
}
.end_amd_amdgpu_hsa_metadata
.endif
