@testset "GaussianNoise" begin
    @test typeof(@inferred(GaussianNoise(2))) <: GaussianNoise <: Augmentor.ArrayOperation
    @testset "constructor" begin
        @test str_show(GaussianNoise(2)) == "AugmentorAudio.GaussianNoise(2)"
        @test str_showconst(GaussianNoise(2)) == "GaussianNoise(2)"
        @test str_showcompact(GaussianNoise(2)) == "GaussianNoise(2) signal"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(GaussianNoise(2), nothing)
        @test Augmentor.supports_eager(GaussianNoise) === true
        @testset "single signal" begin
            res = @inferred(Augmentor.applyeager(GaussianNoise(2), testsig))
            @test std(res-testsig) ≈ 2 atol = 0.5
            @test typeof(res) == typeof(testsig)
        end
        @testset "multiple signals" begin
            sig_in = (testsig, testsig2)
            res = @inferred(Augmentor.applyeager(GaussianNoise(2), sig_in))
            @test std(res[1]-sig_in[1]) ≈ 2 atol=0.5
            @test std(res[2]-sig_in[2]) ≈ 2 atol=0.5
            @test typeof(res) == typeof(sig_in)

        end
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(GaussianNoise) === true
        @testset "single signal" begin
            v = @inferred Augmentor.applylazy(GaussianNoise(2), testsig)
            @test std(v-testsig) ≈ 2 atol = 0.5
            @test typeof(v) <: MappedArrays.ReadonlyMappedArray
        end
        @testset "multiple signals" begin
            sig_in = (testsig2, testsig2)
            res1, res2 = @inferred(Augmentor.applylazy(GaussianNoise(2), sig_in))
            @test std(res1-sig_in[1]) ≈ 2 atol = 0.5
            @test std(res2-sig_in[2]) ≈ 2 atol = 0.5
            @test typeof(res1) <: ReadonlyMappedArray
            @test typeof(res2) <: ReadonlyMappedArray
        end
    end
    @testset "view" begin
        @test Augmentor.supports_view(GaussianNoise) === false
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(GaussianNoise) === false
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(GaussianNoise) === false
    end
end
