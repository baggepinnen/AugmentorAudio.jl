module AugmentorAudio
using Augmentor, DSP, MappedArrays

import Augmentor:
    applylazy,
    applyeager,
    showconstruction,
    supports_stepview,
    supports_lazy

using Augmentor: plain_array

include("types.jl")
# export ArrayOperation

include("operations/simple_audio.jl")
export Amplify
include("operations/linearfilter.jl")
export LinearFilter
end # module
