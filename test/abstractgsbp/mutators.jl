@testset "Check push_observation!()" begin
    m = Foo2(; N = 100, K = 10)
    @testset "Valid arguments" begin
        y0, x0, r0, d0 = 0.1, 0.2, 2, 2
        @inferred push_observation!(m; y0, x0, r0, d0)
        @test length(m.skl.y) == 101
        @test length(m.skl.x) == 101
        @test length(m.skl.r) == 101
        @test length(m.skl.d) == 101
        @test m.skl.y[end] ≈ y0
        @test m.skl.x[end] ≈ x0
        @test m.skl.r[end] == r0
        @test m.skl.d[end] == d0
    end
    @testset "Invalid arguments" begin
        y0, x0, r0, d0 = 0.1, 0.2, 2, 3
        @test_throws AssertionError push_observation!(m; y0, x0, d0, r0)
    end
end

@testset "Check pop_observation!()" begin
    m = Foo2(; N = 100, K = 10)
    @inferred pop_observation!(m)
    @test length(m.skl.y) == 99
    @test length(m.skl.x) == 99
    @test length(m.skl.r) == 99
    @test length(m.skl.d) == 99
    @test 0 == @allocated pop_observation!(m)
end
