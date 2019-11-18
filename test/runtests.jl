using   DSP,
        MappedArrays,
        Random,
        Statistics

# extras
using ReferenceTests, Test

using AugmentorAudio, Augmentor

str_show(obj) = @io2str show(::IO, obj)
str_showcompact(obj) = @io2str show(IOContext(::IO, :compact=>true), obj)
str_showconst(obj) = @io2str Augmentor.showconstruction(::IO, obj)


testsig = randn(100)
testsig2 = sin.(1:100)
testsig3 = sin.(1:100) .+ sin.(0.1 .* (1:100))

tests = [
    "operations/tst_simpleaudio.jl",
    "operations/tst_linearfilter.jl",
]


@testset "AugmentorAudio" begin
    @info "Testing AugmentorAudio"

    for t in tests
        @testset "$t" begin
            include(t)
        end
    end
end
