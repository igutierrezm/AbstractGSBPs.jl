@doc raw"""
    get_weight(m::AbstractGSBP, k0::Int)

Return the `k0`th weight of the mixture implied by the model, namely:

```math
\begin{aligned}
    w_k
    &=
    \sum_{\ell \geq k}
    \text{NegativeBinomial}(\ell \mid s, p) / \ell
\end{aligned}
```

where ``\text{NegativeBinomial}(\cdot \mid s, p)`` denotes the pmf of
a ``\text{NegativeBinomial}(s, p)`` distribution at ``\ell``
[([1])](https://doi.org/10.1016/j.spl.2009.01.005).

See also [`AbstractGSBP`](@ref).
"""
function get_weight(m::AbstractGSBP, k0::Int)
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
    get_fgrid!(m::AbstractGSBP; fgrid::Vector{Float64}, ygrid, xgrid)

Replace `fgrid` with ``p(y_{new} | x_{new}, \theta)`` for
each ``(y_{new}, x_{new})`` in `zip(ygrid, xgrid)`, using the current atoms.

See also [`AbstractGSBP`](@ref).
"""
function get_fgrid!(m::AbstractGSBP; fgrid::Vector{Float64}, ygrid, xgrid)
    (; y, x, w, K) = get_skeleton(m)
    w = zeros(K[])
    val_ygrid(ygrid, y)
    val_fgrid(fgrid, ygrid)
    val_xgrid(xgrid, ygrid, x)
    for k0 in 1:K[]
        w[k0] = get_weight(m, k0)
    end
    for i in eachindex(fgrid)
        f0 = 0.0
        y0 = ygrid[i]
        x0 = xgrid[i]
        for k in 1:K[]
            f0 += w[k] * exp(loglikcontrib(m, y0, x0, k))
        end
        fgrid[i] = f0
    end
    return fgrid
end

function val_ygrid_(ygrid::Vector{T}, y::Vector{T}) where {T}
    @assert !isempty(ygrid)
    @assert all(length.(ygrid) .== length(y[1]))
end

function val_fgrid_(fgrid::Vector{Float64}, ygrid::Vector{T}) where {T}
    @assert length(fgrid) == length(ygrid)
end

function val_xgrid_(xgrid::Vector{T}, ygrid::Vector{S}, x::Vector{T}) where {T, S}
    @assert length(xgrid) == length(ygrid)
    @assert all(length.(xgrid) .== length(x[1]))
end
