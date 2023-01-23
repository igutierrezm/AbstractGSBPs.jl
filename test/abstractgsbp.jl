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

@testset "step_d!()" begin
    m = Foo2(; N = 100, K = 10)
    d0 = deepcopy(get_labels(m))
    @inferred AbstractGSBPs.step_d!(m)
    @test any(m.skl.d .!= d0)
    @test all(m.skl.d .<= m.skl.r)
    @test all(m.skl.d .∈ Ref([1, 3]))
    @test length(m.skl.d) == length(d0)
end

@testset "step_r!()" begin
    m = Foo2(; N = 100, K = 10)
    r0 = deepcopy(m.skl.r)
    @inferred AbstractGSBPs.step_r!(m)
    @test any(m.skl.r .!= r0)
    @test all(m.skl.r .>= m.skl.d)
    @test length(m.skl.r) == length(r0)
end

@testset "step_K!()" begin
    m = Foo2(; N = 100, K = 10)
    m.skl.r .= 1
    @inferred AbstractGSBPs.step_K!(m)
    @test m.skl.K[] == 1
end

@testset "step_p!()" begin
    m = Foo2(; N = 100, K = 10)
    p0 = m.skl.p[]
    @inferred AbstractGSBPs.step_p!(m)
    @test m.skl.p[] > 0.0
    @test m.skl.p[] < 1.0
    @test m.skl.p[] != p0
end

@testset "step_s!()" begin
    m = Foo2(; N = 100, K = 10)
    s0 = m.skl.s[]
    @inferred AbstractGSBPs.step_s!(m)
    @test m.skl.s[] > 0.0
    @test m.skl.s[] != s0
end


# # @testset "step_d!()" begin
# #     m = Skeleton(; y = rand(100), x = ones(100)) |> Foo
# #     p0 = copy(m.skl.p[])
# #     s0 = copy(m.skl.s[])
# #     r0 = copy(m.skl.r)
# #     d0 = copy(m.skl.d)
# #     @testset "step_r()" begin
# #         @inferred GSBP.step_r!(m)
# #         @test any(m.skl.r .!= r0)
# #         @test all(m.skl.r .>= m.skl.d)
# #         @test length(m.skl.r) == length(r0)
# #     end
# #     @testset "step_K()" begin

# #     end
# #     @inferred GSBP.step_K!(m)
# #     @test m.skl.K[] > 0

# #     @inferred GSBP.step_p!(m)
# #     @test 0.0 < m.skl.p[] < 1.0
# #     @test m.skl.p[] != p0

# #     @inferred GSBP.step_s!(m)
# #     @test m.skl.s[] > 0.0

# #     @inferred GSBP.step_d!(m)
# #     @test any(m.skl.d .!= d0)
# #     @test all(m.skl.d .<= m.skl.r)
# #     @test all(m.skl.d .∈ Ref([1, 3]))
# #     @test length(m.skl.d) == length(d0)
# # end

# # @testset "Check get_weights!()" begin
# #     m = Skeleton(; y = rand(100), x = ones(100), p = 0.5, s = 2.0) |> Foo
# #     @inferred get_weights!(m; ncomp = 10)
# #     w = get_weights!(m; ncomp = 10)
# #     @test all(w .> 0)
# #     @test sum(w) ≈ 1.0
# #     @test length(w) == 10
# #     @test w[9] ≈ 0.5 * (1 - 0.5)^8
# #     @test 0 == @allocated get_weights!(m; ncomp = 10, w)

# #     # s = 3
# #     m = Skeleton(; y = rand(100), x = ones(100), p = 0.5, s = 3.0) |> Foo
# #     w = get_weights!(m; ncomp = 10)
# #     @test all(w .> 0)
# #     @test sum(w) ≈ 1.0
# #     @test length(w) == 10
# #     @test w[9] ≈ 0.5 * (1 - 0.5)^8 * (1 + 9 * 0.5) / 2

# #     # s > 3
# #     m = Skeleton(; y = rand(100), x = ones(100), p = 0.5, s = 4.0) |> Foo
# #     w = get_weights!(m; ncomp = 10)
# #     @test all(w .> 0)
# #     @test sum(w) ≈ 1.0
# #     @test length(w) == 10
# #     j = 9
# #     p = 0.5
# #     @test w[j] ≈ 1 / 6 * p * (1 - p)^(j - 1) * (j^2 * p^2 + j * p^2 + 2 * j * p + 2)
# # end

# # # @testset "Check get_fgrid!()" begin
# # #     ygrid = LinRange(0.0, 1.0, 10) |> collect
# # #     xgrid = LinRange(0.0, 1.0, 10) |> collect
# # #     d = [1; 2; 3]
# # #     r = [1; 2; 3]
# # #     m = Skeleton(; y = rand(3), x = rand(3), ygrid, xgrid, r, d) |> Foo
# # #     @inferred get_fgrid!(m)
# # #     fgrid = get_fgrid!(m)
# # #     @test length(fgrid) == length(ygrid)
# # #     @test 0 == @allocated get_fgrid!(m; fgrid)
# # #     @test all(fgrid .== m.skl.w[1] + 2 * m.skl.w[3])
# # #     for i in 1:100
# # #         m = Skeleton(; y = rand(1), x = rand(1), ygrid, xgrid) |> Foo
# # #         get_fgrid!(m; fgrid)
# # #     end
# # # end

# # @testset "Check sim_new_r()" begin
# #     m = Skeleton(; y = rand(100), x = rand(100)) |> Foo
# #     @inferred sim_new_r(m)
# #     rnew = sim_new_r(m)
# #     @test rnew >= 1
# #     @test 0 == @allocated sim_new_r(m)
# #     ntrues = 0
# #     for i in 1:100
# #         rnew = sim_new_r(m)
# #         ntrues += (rnew > 0)
# #     end
# #     @test ntrues == 100
# # end

# # @testset "Check sim_new_d()" begin
# #     m = Skeleton(; y = rand(100), x = rand(100)) |> Foo
# #     rnew = sim_new_r(m)
# #     @inferred sim_new_d(m, rnew)
# #     dnew = sim_new_d(m, rnew)
# #     @test 1 <= dnew <= rnew
# #     @test 0 == @allocated sim_new_d(m, rnew)
# #     ntrues = 0
# #     for i in 1:100
# #         rnew = sim_new_r(m)
# #         dnew = sim_new_d(m, rnew)
# #         ntrues += (1 <= dnew <= rnew)
# #     end
# #     @test ntrues == 100
# # end

# # @testset "Check step!()" begin
# #     m = Skeleton(; y = rand(100), x = rand(100)) |> Foo
# #     @inferred step!(m)
# #     @test 0 == @allocated step!(m)
# #     for i in 1:100
# #         m = Skeleton(; y = rand(100), x = rand(100)) |> Foo
# #         step!(m)
# #     end
# # end
