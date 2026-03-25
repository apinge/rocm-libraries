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

#include <miopen/conv/invokers/asm_dw3d_z3h5w5bf16.hpp>

#include <miopen/conv/data_invoke_params.hpp>
#include <miopen/errors.hpp>
#include <miopen/handle.hpp>
#include <miopen/kernel.hpp>

#include <cstring>

namespace miopen {
namespace conv {

namespace {

constexpr std::size_t kKernargBytes = 320;

} // namespace

Invoker MakeAsmDw3dZ3h5w5Bf16Invoker(const std::vector<Kernel>& kernels)
{
    if(kernels.size() != 1)
        MIOPEN_THROW("Expected a single kernel.");

    const auto kernel = kernels[0];

    return [kernel](const Handle& handle, const AnyInvokeParams& primitive_parameters) {
        const auto& params  = primitive_parameters.CastTo<DataInvokeParams>();
        const auto& tensors = params.tensors;

        alignas(8) unsigned char kernarg[kKernargBytes]{};

        void* p_in    = const_cast<void*>(static_cast<const void*>(tensors.in));
        void* p_out   = tensors.out;
        void* p_w     = const_cast<void*>(static_cast<const void*>(tensors.w));
        void* p_bias  = nullptr;

        // conv_depthwise3d_hip: input, output, kernel, bias (see pyhip conv_depthwise3d_hip.cpp).
        std::memcpy(kernarg + 0, &p_in, sizeof(void*));
        std::memcpy(kernarg + 8, &p_out, sizeof(void*));
        std::memcpy(kernarg + 16, &p_w, sizeof(void*));
        std::memcpy(kernarg + 24, &p_bias, sizeof(void*));

        // Same order as kernel formal parameters: iC, iD, iH, iW, oC, oD, oH, oW (case3 / fixed solver).
        const uint32_t user_ints[8] = {
            512u, // iC
            61u,  // iD
            45u,  // iH
            80u,  // iW
            512u, // oC
            59u,  // oD  (case3: D=61, padD=0, KD=3, stride 1 -> 59)
            45u,  // oH
            80u,  // oW
        };
        std::memcpy(kernarg + 32, user_ints, sizeof(user_ints));

        handle.Run(kernel).RunRaw(kernarg, kKernargBytes);
    };
}

} // namespace conv
} // namespace miopen
