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

@testset "get_labels()" begin
    m = Foo2(; N = 100, K = 10)
    @inferred get_labels(m)
    @test get_labels(m) === m.skl.d
    @test 0 == @allocated get_labels(m)
end
