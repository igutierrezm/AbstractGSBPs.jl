@testset "Valid arguments" begin
    y = randn(100)
    x = randn(100)
    @testset "Default arguments" begin
        for sim in 1:100
            @inferred GSBPSkeleton(; y, x)
        end
    end
    @testset "Custom arguments" begin
        for sim in 1:100
            a0p = 2 * rand()
            b0p = 2 * rand()
            a0s = 2 * rand()
            b0s = 2 * rand()
            p = rand()
            s = 2 * rand()
            d = rand(1:3, 100)
            r = d .+ rand(0:2, 100)
            @inferred GSBPSkeleton(; y, x, a0p, b0p, a0s, b0s, p, s, r, d)
        end
    end
end

@testset "Invalid data" begin
    @testset "y" begin
        @test_throws AssertionError GSBPSkeleton(; y = [], x = [])
        @test_throws AssertionError GSBPSkeleton(; y = [[], []], x = [[], []])
        @test_throws AssertionError GSBPSkeleton(; y = [[1], [1, 2]], x = [1, 1])
    end
    # @testset "x" begin
    #     y = [1, 1]
    #     @test_throws AssertionError GSBPSkeleton(; y, x = [[1]])
    #     @test_throws AssertionError GSBPSkeleton(; y, x = [[1], [1. 2]])
    # end
    # @testset "ygrid" begin
    #     y, x, xgrid, ygrid = [[1]], [1], [1], [[1, 2]]
    #     @test_throws AssertionError GSBPSkeleton(; y, x, ygrid, xgrid)
    # end
    # @testset "xgrid" begin
    #     y, x, ygrid = [1], [[1]], [1]
    #     @test_throws AssertionError GSBPSkeleton(; y, x, ygrid, xgrid = [[1, 2]])
    #     @test_throws AssertionError GSBPSkeleton(; y, x, ygrid, xgrid = [[1], [1]])
    # end
end

# @testset "Invalid hyperparameters" begin
#     @testset "Domain" begin
#         y, x = [1], [1]
#         @test_throws AssertionError GSBPSkeleton(; y, x, a0p = 0.0)
#         @test_throws AssertionError GSBPSkeleton(; y, x, a0s = 0.0)
#         @test_throws AssertionError GSBPSkeleton(; y, x, b0s = 0.0)
#         @test_throws AssertionError GSBPSkeleton(; y, x, b0p = 0.0)
#     end
# end

# @testset "Invalid parameters" begin
#     @testset "Domain" begin
#         y, x = [1], [1]
#         @test_throws AssertionError GSBPSkeleton(; y, x, s = 0.0)
#         @test_throws AssertionError GSBPSkeleton(; y, x, p = 0.0)
#         @test_throws AssertionError GSBPSkeleton(; y, x, p = 1.0)
#         @test_throws AssertionError GSBPSkeleton(; y, x, d = [0])
#         @test_throws AssertionError GSBPSkeleton(; y, x, r = [0])
#         @test_throws AssertionError GSBPSkeleton(; y, x, d = [2], r = [1])
#     end
#     @testset "Dimension" begin
#         y, x = [1], [1]
#         @test_throws AssertionError GSBPSkeleton(; y, x, d = [1, 1])
#         @test_throws AssertionError GSBPSkeleton(; y, x, r = [1, 1])
#     end
# end

# @testset "Transformed parameters" begin
#     @testset "K" begin
#         skl = GSBPSkeleton(; y = randn(100), x = randn(100))
#         @test skl.K[] == 1 + maximum(skl.r; init = 0)
#     end
#     @testset "w" begin
#         skl = GSBPSkeleton(; y = randn(100), x = randn(100))
#         @test length(skl.w) == skl.K[]
#     end
# end

# # Notes

# # [1]
# # https://doi.org/10.1016/j.csda.2020.106940
