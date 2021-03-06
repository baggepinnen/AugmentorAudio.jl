[![Build Status](https://travis-ci.org/baggepinnen/AugmentorAudio.jl.svg?branch=master)](https://travis-ci.org/baggepinnen/AugmentorAudio.jl)
[![codecov](https://codecov.io/gh/baggepinnen/AugmentorAudio.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/baggepinnen/AugmentorAudio.jl)

An audio extension of [Augmentor.jl](https://github.com/baggepinnen/Augmentor.jl)

# Installation

```julia
using Pkg
pkg"add https://github.com/baggepinnen/Augmentor.jl"
pkg"add https://github.com/baggepinnen/AugmentorAudio.jl"

# or
using Pkg
pkg"dev https://github.com/baggepinnen/Augmentor.jl"
pkg"dev https://github.com/baggepinnen/AugmentorAudio.jl"
```

# Operations
- `Amplify(factor)` yep, it does what it sounds like.
- `GaussianNoise(power)` add gaussian noise to signal
- `RandomSinus(arange=(0,1), frange=(0,0.5), logspace=true)` add a random sinusoid to the signal. Specify frequency and amplitude range and whether to sample frequency log-spaced.
- `Mixup(path_to_files, wrap=false),Mixup(vector_of_signals, wrap=false)` provide a path to a folder with signals or a vector of signals. A random signal is drawn and added to the input. If `wrap`, a short signal is repeated several times to cover the input.
- `LinearFilter(::DSP.FilterCoefficients)` Filter the input through a specified linear filter.
- `AlphaSubGaussianNoise(n, α=1.5)` Adds [alpha sub-gaussian noise with memory](https://arl.nus.edu.sg/twiki6/pub/ARL/BibEntries/SigProc2016RandomVariate.pdf) to the signal. This noise is a good approximation to the noise created by [snapping shrimps](https://en.wikipedia.org/wiki/Alpheidae). Generated using [AlphaStableDistributions.jl](https://github.com/org-arl/AlphaStableDistributions.jl).
