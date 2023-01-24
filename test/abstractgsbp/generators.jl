@testset "gen_mixture_weight()" begin
    @testset "s = 2" begin
        p, s = 0.5, 2.0
        m = Foo2(; p, s)
        @inferred gen_mixture_weight(m, 9)
        @test (0 == @allocated gen_mixture_weight(m, 9))
        nsuccess = 0
        for j in 1:10
            nsuccess += (
                gen_mixture_weight(m, j) ≈ p * (1 - p)^(j - 1)
            )
        end
        @test nsuccess == 10
    end
    @testset "s = 3" begin
        p, s = 0.5, 3.0
        m = Foo2(; p, s)
        @inferred gen_mixture_weight(m, 9)
        @test 0 == @allocated gen_mixture_weight(m, 9)
        nsuccess = 0
        for j in 1:10
            nsuccess += (
                gen_mixture_weight(m, j) ≈ p * (1 - p)^(j - 1) * (1 + j * p) / 2
            )
        end
        @test nsuccess == 10
    end
    @testset "s = 4" begin
        p, s = 0.5, 4.0
        m = Foo2(; p, s)
        @inferred gen_mixture_weight(m, 9)
        nsuccess = 0
        for j in 1:10
            nsuccess += gen_mixture_weight(m, j) ≈ (
                1 / 6 * p * (1 - p)^(j - 1) *
                (j^2 * p^2 + j * p^2 + 2 * j * p + 2)
            )
        end
        @test nsuccess == 10
    end
end
