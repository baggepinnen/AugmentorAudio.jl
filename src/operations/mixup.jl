"""
    Mixup <: Augmentor.ArrayOperation

Description
--------------

Adds one signal to another signal


Usage
--------------

    Mixup(path; [wrap=false])
    Mixup(vector_of_signals; [wrap=false])

Arguments
--------------

- **`path::String`** : Path to a folder with files that contains signals.
- **`vector_of_signals`** : A vector of signals
- **`wrap`** : If true, then the signal is repeated so as to cover the entire length of the input. If false, the signal will be added at a random point of the input so that the entire signal fits. If the signal is longer than the input, a random window of the signal will be applied to the entire input.

Examples
--------------

```jldoctest

```
"""
struct Mixup{T} <: Augmentor.ArrayOperation
    signals::T
    wrap::Bool
    function Mixup(path::AbstractString; wrap=false)
        signals = filter(readdir(path)) do filename
            splitext(filename)[end] == ".wav"
        end
        signals = joinpath.(Ref(path), signals)
        new{typeof(signals)}(signals, wrap)
    end
    function Mixup(signals; wrap=false)
        new{typeof(signals)}(signals, wrap)
    end
end

@inline supports_stepview(::Type{Mixup}) = false
@inline supports_lazy(::Type{Mixup}) = false

applyeager(op::Mixup, input::AbstractArray, param) = plain_array(applysig(op, randsig(op), input))

function showconstruction(io::IO, op::Mixup)
    print(io, typeof(op).name.name, "($(op.signals), wrap=$(op.wrap))")
end

function Base.show(io::IO, op::Mixup)
    if get(io, :compact, false)
        print(io, "Mixup($(op.signals), wrap=$(op.wrap)) signal")
    else
        print(io, "AugmentorAudio.")
        showconstruction(io, op)
    end
end

Base.length(m::Mixup) = length(m.signals)
function randsig(m::Mixup)
    i = rand(1:length(m))
    m[i]
end

function Base.getindex(m::Mixup{<:AbstractVector{<:AbstractString}}, i)
    wavread(m.signals[i])[1]
end

function Base.getindex(m::Mixup{<:AbstractVector{<:AbstractArray}}, i)
    m.signals[i]
end

function applysig(m::Mixup, sig, input)
    input = copy(input)
    ni = length(input)
    ns = length(sig)
    startind = max(1, rand(1:ni-ns+1))
    endind = min(startind+ns-1, max(ns,ni))
    if ns < ni
        if m.wrap
            si = 1
            for i in eachindex(input)
                input[i] += sig[si]
                si += 1
                si > ns && (si = 1)
            end
        else
            input[startind:endind] .+= sig
        end
    else
        input .+= @view sig[startind:endind]
    end
    input
end
