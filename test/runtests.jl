using AbstractGSBPs
using Test

# Add some testing models
include("models/Foo1.jl")
include("models/Foo2.jl")

@testset "AbstractGSBP.jl" begin
    @testset "GSBPSkeleton" begin
        include("gsbpskeleton.jl")
    end
    @testset "Interface" begin
        include("interface.jl")
    end
    @testset "AbstractGSBP" begin
        include("abstractgsbp.jl")
    end
end
