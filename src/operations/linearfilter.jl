"""
    LinearFilter <: Augmentor.ArrayOperation

Description
--------------

Filters a signal using a linear filter


Usage
--------------

    LinearFilter()

Arguments
--------------

- **`p::Number`** : Amplification factor

Examples
--------------

```jldoctest
julia> using Augmentor, DSP

julia> filter = LinearFilter(digitalfilter(Lowpass(0.4), Butterworth(2)))
Augmentor.LinearFilter(ZeroPoleGain{Complex{Float64},Complex{Float64},Float64}(Complex{Float64}[-1.0 + 0.0im, -1.0 + 0.0im], Complex{Float64}[0.18476368867562076 + 0.40209214367208346im, 0.18476368867562076 - 0.40209214367208346im], 0.20657208382614792))

julia> sig = [0,1,0,1,0,1,0,1]
8-element Array{Int64,1}:
 0
 1
 0
 1
 0
 1
 0
 1

julia> sig_new = augment(sig, filter)'
1×8 Adjoint{Float64,Array{Float64,1}}:
 0.0  0.206572  0.489478  0.55357  0.521856  0.497587  0.494828  0.498562
```
"""
struct LinearFilter{T<:DSP.FilterCoefficients} <: ArrayOperation
    filter::T
end

@inline supports_stepview(::Type{LinearFilter}) = false
@inline supports_lazy(::Type{LinearFilter}) = false

applyeager(op::LinearFilter, input::AbstractArray, param) = plain_array(filt(op.filter, input))


function showconstruction(io::IO, op::LinearFilter)
    print(io, typeof(op).name.name, "($(op.filter))")
end

function Base.show(io::IO, op::LinearFilter)
    if get(io, :compact, false)
        print(io, "LinearFilter signal")
    else
        print(io, "Augmentor.")
        showconstruction(io, op)
    end
end
