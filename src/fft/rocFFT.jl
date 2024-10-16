module rocFFT
export ROCFFTError

using CEnum
using LinearAlgebra

# TODO
# @reexport using AbstractFFTs

import AbstractFFTs: complexfloat, realfloat
import AbstractFFTs: plan_fft, plan_fft!, plan_bfft, plan_bfft!
import AbstractFFTs: plan_rfft, plan_brfft, plan_inv, normalization
import AbstractFFTs: fft, bfft, ifft, rfft, Plan, ScaledPlan

import ..AMDGPU
import .AMDGPU: ROCArray, ROCVector, HandleCache, HIP, unsafe_free!, check, @check
import AMDGPU: librocfft
import .HIP: hipStream_t, HIPContext, HIPStream

include("librocfft.jl")
include("error.jl")
include("util.jl")
include("wrappers.jl")
include("fft.jl")

version() = VersionNumber(
    rocfft_version_major, rocfft_version_minor, rocfft_version_patch)

const INITIALIZED = Threads.Atomic{Int64}(0)

function rocfft_setup_once()
    if Threads.atomic_cas!(INITIALIZED, 0, 1) == 0
        rocfft_setup()
        atexit(rocfft_cleanup)
    end
end

end
