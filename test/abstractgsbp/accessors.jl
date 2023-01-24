@testset "get_y()" begin
    m = Foo2(; N = 100, K = 10)
    @inferred get_y(m)
    @test get_y(m) === m.skl.y
    @test 0 == @allocated get_y(m)
end

@testset "get_x()" begin
    m = Foo2(; N = 100, K = 10)
    @inferred get_x(m)
    @test get_x(m) === m.skl.x
    @test 0 == @allocated get_x(m)
end

@testset "get_cluster_labels()" begin
    m = Foo2(; N = 100, K = 10)
    @inferred get_cluster_labels(m)
    @test get_cluster_labels(m) === m.skl.d
    @test 0 == @allocated get_cluster_labels(m)
end

@testset "get_K()" begin
    for K in [1, 5, 10]
        m = Foo2(; N = 100, K)
        @inferred AbstractGSBPs.get_K(m)
        @test AbstractGSBPs.get_K(m) == maximum(m.skl.r)
    end
end
