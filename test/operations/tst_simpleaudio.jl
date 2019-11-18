@testset "Amplify" begin
    @test typeof(@inferred(Amplify(2))) <: Amplify <: Augmentor.ArrayOperation
    @testset "constructor" begin
        @test str_show(Amplify(2)) == "Augmentor.Amplify(2)"
        @test str_showconst(Amplify(2)) == "Amplify(2)"
        @test str_showcompact(Amplify(2)) == "Amplify signal 2"
    end
    @testset "eager" begin
        @test_throws MethodError Augmentor.applyeager(Amplify(2), nothing)
        @test Augmentor.supports_eager(Amplify) === true
        res1 = testsig .* 2
        sigs = [
            (testsig, res1),
        ]
        @testset "single signal" begin
            for (sig_in, sig_out) in sigs
                res = @inferred(Augmentor.applyeager(Amplify(2), sig_in))
                @test res == sig_out
                @test typeof(res) == typeof(sig_out)
            end
        end
        @testset "multiple signals" begin
            for (sig_in1, sig_out1) in sigs, (sig_in2, sig_out2) in sigs
                sig_in = (sig_in1, sig_in2)
                sig_out = (sig_out1, sig_out2)
                res = @inferred(Augmentor.applyeager(Amplify(2), sig_in))
                @test res == sig_out
                @test typeof(res) == typeof(sig_out)
            end
        end
    end
    @testset "lazy" begin
        @test Augmentor.supports_lazy(Amplify) === true
        @testset "single signal" begin
            v = @inferred Augmentor.applylazy(Amplify(2), testsig)
            @test v == 2 .* testsig
            @test typeof(v) <: MappedArrays.ReadonlyMappedArray
        end
        @testset "multiple signals" begin
            sig_in = (testsig2, testsig2)
            res1, res2 = @inferred(Augmentor.applylazy(Amplify(2), sig_in))
            @test res1 == 2 .* testsig2
            @test res2 == 2 .* testsig2
            @test typeof(res1) <: ReadonlyMappedArray
            @test typeof(res2) <: ReadonlyMappedArray
        end
    end
    @testset "view" begin
        @test Augmentor.supports_view(Amplify) === false
    end
    @testset "stepview" begin
        @test Augmentor.supports_stepview(Amplify) === false
    end
    @testset "permute" begin
        @test Augmentor.supports_permute(Amplify) === false
    end
end
