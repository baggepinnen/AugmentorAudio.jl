@testset "LinearFilter" begin
    sig = collect(1.:100)
    df = digitalfilter(Lowpass(0.4), Butterworth(2))
    @test typeof(@inferred(LinearFilter(df))) <: LinearFilter <: Augmentor.ArrayOperation
    @testset "constructor" begin
        @test str_show(LinearFilter(df)) == "Augmentor.LinearFilter(ZeroPoleGain{Complex{Float64},Complex{Float64},Float64}(Complex{Float64}[-1.0 + 0.0im, -1.0 + 0.0im], Complex{Float64}[0.18476368867562076 + 0.40209214367208346im, 0.18476368867562076 - 0.40209214367208346im], 0.20657208382614792))"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(LinearFilter(df), nothing)
        @test Augmentor.supports_eager(LinearFilter) === true
        @testset "single signal" begin
            res = Augmentor.applyeager(LinearFilter(df), sig)
            @test all(res .< sig)
            @test all(>(0), res)
            @test res == filt(df, sig)
            @test typeof(res) == typeof(sig)
        end
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(LinearFilter) === false
    end
    @testset "view" begin
        @test Augmentor.supports_view(LinearFilter) === false
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(LinearFilter) === false
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(LinearFilter) === false
    end
end
