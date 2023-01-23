# A trivial model with:
# - Fixed f() inside each component.
# - Known atoms (so there is no need to update them).
# See the implementation of `loglikcontrib()` below and you will understand.
begin
    struct Foo2 <: AbstractGSBP
        skl::GSBPSkeleton{Float64, Float64}
        function Foo2(;
            N::Int = 1,
            K::Int = 1,
            p::Float64 = 0.5,
            s::Float64 = 2.0
        )
            y = rand(N)
            x = ones(N)
            r = rand(1:K, N)
            d = [rand(1:ri) for ri in r]
            skl = GSBPSkeleton(; y, x, d, r, p, s)
            new(skl)
        end
    end
    function AbstractGSBPs.loglikcontrib(m::Foo2, y0, x0, d0::Int)
        x = log(0.0)
        d0 == 1 && (x = log(1.0))
        d0 == 3 && (x = log(2.0))
        return x
    end
    AbstractGSBPs.get_skeleton(m::Foo2) = m.skl
    AbstractGSBPs.step_atom!(m::Foo2, k::Int) = nothing
    AbstractGSBPs.step_atoms!(m::Foo2, K::Int) = nothing
    AbstractGSBPs.rand_ynew!(m::Foo2, ynew, xnew, dnew::Int) = 1.0
end
