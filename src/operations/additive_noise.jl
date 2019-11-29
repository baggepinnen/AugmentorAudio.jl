"""
    GaussianNoise <: Augmentor.ArrayOperation

Description
--------------

Adds noise to a signal


Usage
--------------

    GaussianNoise(p)

Arguments
--------------

- **`p::Number`** : Amplification factor

Examples
--------------

```jldoctest

```
"""
struct GaussianNoise{T<:Number} <: ArrayOperation
    p::T
end

@inline supports_stepview(::Type{GaussianNoise}) = false
@inline supports_lazy(::Type{GaussianNoise}) = true

applyeager(op::GaussianNoise, input::AbstractArray, param) = plain_array(op.p randn.() .* input)

applylazy(op::GaussianNoise, input::AbstractArray, param) = mappedarray(x->op.p*randn()*x, input)

function showconstruction(io::IO, op::GaussianNoise)
    print(io, typeof(op).name.name, "($(op.p))")
end

function Base.show(io::IO, op::GaussianNoise)
    if get(io, :compact, false)
        print(io, "GaussianNoise signal")
    else
        print(io, "AugmentorAudio.")
        showconstruction(io, op)
    end
end


# ---------------------------------------------------------------------

"""
    RandomSinus <: Augmentor.ArrayOperation

Description
--------------

Adds noise to a signal


Usage
--------------

    RandomSinus(p)

Arguments
--------------

- **`p::Number`** : Amplification factor

Examples
--------------

```jldoctest

```
"""
Base.@kwdef struct RandomSinus{T<:Tuple{<:Real, <:Real}} <: ArrayOperation
    frange::T = (0.0, 0.5)
    logspace::Bool = true
end

@inline supports_stepview(::Type{RandomSinus}) = false
@inline supports_lazy(::Type{RandomSinus}) = false

function draw_freq(x::RandomSinus)
    if x.logspace
        return exp10(rand(LinRange(log10(x.frange[1]), log10(x.frange[2]), 1000)))
    else
        return rand(LinRange(x.frange[1], x.frange[2], 1000))
    end
end

applyeager(op::RandomSinus, input::AbstractArray, param) = plain_array(sin.((1:length(input)).*draw_freq(op)) .* input)


function showconstruction(io::IO, op::RandomSinus)
    print(io, typeof(op).name.name, "($(op.p))")
end

function Base.show(io::IO, op::RandomSinus)
    if get(io, :compact, false)
        print(io, "RandomSinus signal")
    else
        print(io, "AugmentorAudio.")
        showconstruction(io, op)
    end
end


# ---------------------------------------------------------------------
