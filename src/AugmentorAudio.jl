module AugmentorAudio
using Augmentor, DSP, WAV, MappedArrays

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

include("operations/additive_noise.jl")
export GaussianNoise, RandomSinus

include("operations/mixup.jl")
export Mixup
end # module
