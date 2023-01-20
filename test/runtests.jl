using AbstractGSBPs
using Test

@testset "AbstractGSBP.jl" begin
    @testset "GSBPSkeleton" begin
        include("gsbpskeleton.jl")
    end
    # @testset "Interface" begin
    #     include("interface.jl")
    # end
    # @testset "AbstractModel" begin
    #     include("abstractmodel.jl")
    # end
end
