@doc raw"""
    gen_mixture_weight(m::AbstractGSBP, k0::Int)

Return the ``k_0``-th mixture weight.

See also [`AbstractGSBPs`](@ref).
"""
function gen_mixture_weight(m::AbstractGSBP, k0::Int)
    (; p, s) = get_skeleton(m)
    logwk = 0.0
    if s[] ≈ 2.0
        logwk = log(p[]) + (k0 - 1) * log(1 - p[])
    elseif s[] ≈ 3.0
        logwk = log(p[]) + (k0 - 1) * log(1 - p[]) + log(1 + k0 * p[]) - log(2)
    else
        logwk = (
            - log(k0) -
            log(k0 + s[] - 1) -
            logabsbeta(k0, s[])[1] +
            s[] * log(p[]) +
            (k0 - 1) * log(1 - p[]) +
            log(_₂F₁(big(k0 + s[] - 1), 1, k0 + 1, 1 - p[]))
        )
        logwk = Float64(logwk)
    end
    return exp(logwk)
end

@doc raw"""
    gen_mixture_density(m::AbstractGSBP, y0, x0)

Compute the mixture density at an out-of-sample point ``(y_0, x_0)``.

See also [`AbstractGSBPs`](@ref).
"""
function gen_mixture_density(m::AbstractGSBP, ygrid, xgrid)
    # (; y, x, K) = get_skeleton(m)
    # w = zeros(K[])
    # val_ygrid(ygrid, y)
    # val_mgrid(mgrid, ygrid)
    # val_xgrid(xgrid, ygrid, x)
    # for k0 in 1:K[]
    #     w[k0] = gen_mixture_weight(m, k0)
    # end
    # for i in eachindex(mgrid)
    #     f0 = 0.0
    #     y0 = ygrid[i]
    #     x0 = xgrid[i]
    #     for k in 1:K[]
    #         f0 += w[k] * exp(loglikcontrib(m, y0, x0, k))
    #     end
    #     mgrid[i] = f0
    # end
    # return mgrid
end

function val_ygrid(
        ygrid::Vector{T},
        y::Vector{T}
    ) where {T}
    @assert !isempty(ygrid)
    @assert all(length.(ygrid) .== length(y[1]))
end

function val_mgrid(
        mgrid::Vector{Float64},
        ygrid::Vector{T}
    ) where {T}
    @assert length(mgrid) == length(ygrid)
end

function val_xgrid(
        xgrid::Vector{T},
        ygrid::Vector{S},
        x::Vector{T}
    ) where {T, S}
    @assert length(xgrid) == length(ygrid)
    @assert all(length.(xgrid) .== length(x[1]))
end
