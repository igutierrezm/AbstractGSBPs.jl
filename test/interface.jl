@testset "Foo1" begin
    m = Foo1()
    @test_throws ErrorException get_skeleton(m)
    @test_throws ErrorException step_atom!(m, 1)
    @test_throws ErrorException step_atoms!(m, 1)
    @test_throws ErrorException rand_ynew!(m, 0.0, 0.0, 1)
    @test_throws ErrorException loglikcontrib(m, 0.0, 0.0, 1)
end

@testset "Foo2" begin
    m = Foo2()
    @test typeof(get_skeleton(m)) == GSBPSkeleton{Float64, Float64}
    @inferred step_atom!(m, 1)
    @inferred step_atoms!(m, 1)
    @inferred rand_ynew!(m, 0.0, 0.0, 1)
    @inferred loglikcontrib(m, 0.0, 0.0, 1)
    @test_throws MethodError step_atom!(m, 1.0)
    @test_throws MethodError step_atoms!(m, 1.0)
    @test_throws MethodError rand_ynew!(m, 0.0, 0.0, 1.0)
    @test_throws MethodError loglikcontrib(m, 0.0, 0.0, 1.0)
end