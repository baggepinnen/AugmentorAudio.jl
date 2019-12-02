@testset "Mixup" begin
    @testset "Vector of signals" begin
        @info "Testing Vector of signals"
        for _ in 1:10
            T = 10
            inp = zeros(T)
            sigs = [randn(T) for i in 1:10]
            m = Mixup(sigs)
            res = Augmentor.applyeager(m, inp, nothing)
            @test res ∈ sigs

            T = 10
            inp = zeros(T)
            sigs = [randn(2) for i in 1:10]
            m = Mixup(sigs, wrap=false)
            res = Augmentor.applyeager(m, inp, nothing)
            @test sum(res) ∈ sum.(sigs)
            m = Mixup(sigs, wrap=true)
            res = Augmentor.applyeager(m, inp, nothing)
            @test any(<(1e-10) ∘ abs, sum(res) .- 5sum.(sigs))
        end
    end


    @testset "Path" begin
        @info "Testing Path"
        path = mktempdir()
        sigs = []
        for i = 1:3
            tmpfile, io = mktemp(path)
            tmpfile = tmpfile*".wav"
            sig = randn(10)
            push!(sigs, sig)
            wavwrite(sig, tmpfile)
            close(io)
        end
        T = 10
        inp = zeros(T)
        m = Mixup(path)
        res = Augmentor.applyeager(m, inp, nothing)
        @test res ∈ sigs
    end

end
