using   DSP,
        WAV,
        MappedArrays,
        Random,
        Statistics

# extras
using ReferenceTests, Test

using AugmentorAudio, Augmentor

str_show(obj) = @io2str show(::IO, obj)
str_showcompact(obj) = @io2str show(IOContext(::IO, :compact=>true), obj)
str_showconst(obj) = @io2str Augmentor.showconstruction(::IO, obj)


testsig = randn(1000)
testsig2 = sin.(1:1000)
testsig3 = sin.(1:1000) .+ sin.(0.1 .* (1:1000))

tests = [
    "operations/tst_simpleaudio.jl",
    "operations/tst_linearfilter.jl",
    "operations/tst_noise.jl",
    "operations/tst_mixup.jl",
]


@testset "AugmentorAudio" begin
    @info "Testing AugmentorAudio"

    for t in tests
        @testset "$t" begin
            include(t)
        end
    end
end
