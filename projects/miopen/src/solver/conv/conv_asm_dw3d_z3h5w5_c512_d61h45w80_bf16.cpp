/*******************************************************************************
 *
 * MIT License
 *
 * Copyright (c) 2026 Advanced Micro Devices, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 *******************************************************************************/

#include <sstream>
#include <miopen/conv/solvers.hpp>
#include <miopen/gcn_asm_utils.hpp>
#include <miopen/env.hpp>
#include <miopen/conv/invokers/asm_dw3d_z3h5w5bf16.hpp>
#include <miopen/mlo_internal.hpp>

MIOPEN_DECLARE_ENV_VAR_BOOL(MIOPEN_DEBUG_CONV_DIRECT_ASM_DW3D_Z3H5W5_C512_D61H45W80_BF16)

namespace miopen {
namespace solver {
namespace conv {

using ProblemDescription = miopen::conv::ProblemDescription;

namespace {

constexpr const char* kKernelFile = "convz3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1.s";
constexpr const char* kKernelName = "miopenGcnAsmConvZ3h5w5c512d61h45w80g512u1v1w1p0p2p2bf16f1";

} // namespace

bool ConvAsmDw3dZ3h5w5c512d61h45w80Bf16::IsApplicable(const ExecutionContext& ctx,
                                                      const ProblemDescription& problem) const
{
    if(env::disabled(MIOPEN_DEBUG_CONV_DIRECT_ASM_DW3D_Z3H5W5_C512_D61H45W80_BF16))
        return false;
    if(!ctx.use_asm_kernels)
        return false;
    if(!problem.Is3d())
        return false;
    if(!ctx.rmv.IsV2orV3())
        return false;

    if(problem.HasNonPackedTensors())
        return false;
    if(!problem.AllTensorsDimsFitIntoInt())
        return false;

    if(problem.IsTensorsCasted())
        return false;

    const auto& target = ctx.GetStream().GetTargetProperties();
    if(target.isXnackEnabled())
        return false;

    const std::string name = ctx.GetStream().GetDeviceName();
    if(!(name == "gfx942" || name == "gfx950"))
        return false;

    if(!problem.IsDirectionForward())
        return false;
    if(!problem.IsLayoutDefault())
        return false;
    if(!problem.IsBfp16())
        return false;

    const auto g = problem.GetGroupCount();
    if(g != problem.GetInChannels() || g != problem.GetOutChannels())
        return false;

    // Kernel passes nullptr bias; no bias buffer in DataInvokeParams.
    if(problem.GetBias() != 0)
        return false;

    // clang-format off
    return problem.GetBatchSize() == 1
        && problem.GetInChannels() == 512
        && problem.GetOutChannels() == 512
        && problem.GetGroupCount() == 512
        && problem.GetInDepth() == 61
        && problem.GetInHeight() == 45
        && problem.GetInWidth() == 80
        && problem.GetWeightsDepth() == 3
        && problem.GetWeightsHeight() == 5
        && problem.GetWeightsWidth() == 5
        && problem.GetPadD() == 0
        && problem.GetPadH() == 2
        && problem.GetPadW() == 2
        && problem.GetKernelStrideD() == 1
        && problem.GetKernelStrideH() == 1
        && problem.GetKernelStrideW() == 1
        && problem.GetDilationD() == 1
        && problem.GetDilationH() == 1
        && problem.GetDilationW() == 1
        && problem.GetInLayout() == "NCDHW";
    // clang-format on
}

ConvSolution ConvAsmDw3dZ3h5w5c512d61h45w80Bf16::GetSolution(const ExecutionContext& ctx,
                                                              const ProblemDescription& problem) const
{
    ConvSolution result;
    std::ostringstream options;
    GenerateClangDefsym(options, "ROCM_METADATA_VERSION", ctx.rmv.UseV3() ? 5 : 4);
    KernelInfo constr_params;
    constr_params.comp_options = options.str();

    // conv_depthwise3d_hip: __launch_bounds__(256,1); grid dim = (batch, out_channel, out_D) =
    // (1, 512, 59) for pyhip case3. hipExtModuleLaunchKernel globalWorkSize = gridDim * blockDim.
    constr_params.l_wk.push_back(256);
    constr_params.l_wk.push_back(1);
    constr_params.l_wk.push_back(1);
    constr_params.g_wk.push_back(256u); // gridDim.x(1) * blockDim.x(256)
    constr_params.g_wk.push_back(512u); // gridDim.y(512) * blockDim.y(1)
    constr_params.g_wk.push_back(59u);  // gridDim.z(59) * blockDim.z(1)

    constr_params.kernel_file = kKernelFile;
    constr_params.kernel_name = kKernelName;

    result.construction_params.push_back(constr_params);
    result.invoker_factory = &miopen::conv::MakeAsmDw3dZ3h5w5Bf16Invoker;
    return result;
}

} // namespace conv
} // namespace solver
} // namespace miopen
