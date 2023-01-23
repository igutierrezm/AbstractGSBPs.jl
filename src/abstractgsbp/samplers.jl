@doc raw"""
    rand_rnew(m::AbstractGSBP)

Return a draw from ``p(r_{new} | s, p)``,
using the current values of ``s`` and ``p``.

See also [`AbstractGSBP`](@ref).
"""
function rand_rnew(m::AbstractGSBP)
    (; s, p) = get_skeleton(m)
    return 1 + rand(NegativeBinomial(s[], p[]))
end

@doc raw"""
    rand_dnew(m::AbstractGSBP, rnew::Int)

Return a draw from ``p(d_{new} | r_{new})``.

See also [`AbstractGSBP`](@ref).
"""
function rand_dnew(m::AbstractGSBP, rnew::Int)
    return rand(1:rnew)
end

@doc raw"""
    step!(m::AbstractGSBP; update_s::Bool = false)

Update ``(\theta, d, r, p)`` as described in
[[1]](https://doi.org/10.1016/j.spl.2009.01.005).
If `update_s = true`, it will also update ``s`` as described in
[[2]](https://pubmed.ncbi.nlm.nih.gov/25279391).

See also [`AbstractGSBP`](@ref).
"""
function step!(m::AbstractGSBP; update_s::Bool = false)
    step_atoms!(m, get_K(m))
    step_d!(m)
    step_r!(m)
    step_K!(m)
    step_p!(m)
    update_s && step_s!(m)
    return m
end

# Get K := maximum(r)
function get_K(m::AbstractGSBP)
    return get_skeleton(m).K[]
end

# Update p, as described in [1]
function step_p!(m::AbstractGSBP)
    (; a0p, b0p, r, s, p) = get_skeleton(m)
    p[] = rand(Beta(s[] * length(r) + a0p, sum(r) + b0p - length(r)))
    return m
end

# Update s, as described in [2]
function step_s!(m::AbstractGSBP)
    (; a0s, b0s, r, s, p) = get_skeleton(m)
    s0 = s[]
    sumq = 0
    for i in eachindex(r)
        qi = 0
        for j in 1:(r[i] - 1)
            qi += rand() <= s0 / (s0 + j - 1)
        end
        sumq += qi
    end
    a1s = a0s + sumq
    b1s = b0s - length(r) * log(1.0 - p[])
    s[] = rand(Gamma(a1s, 1 / b1s))
    return m
end

# Update d, as described in [1]
function step_d!(m::AbstractGSBP)
    (; y, x, r, d) = get_skeleton(m)
    for i in eachindex(y)
        yi = y[i]
        xi = x[i]
        ri = r[i]
        kstar = 0
        pstar = -Inf
        for k in 1:ri
            p = loglikcontrib(m, yi, xi, k) - log(-log(rand()))
            if p > pstar
                kstar = k
                pstar = p
            end
        end
        d[i] = kstar
    end
    return m
end

# Update r, as described in [1]
function step_r!(m::AbstractGSBP)
    (; r, d, s, p) = get_skeleton(m)
    for i in eachindex(r)
        vi = rand(Gamma(r[i] + s[] - 1, 1))
        zi = rand(Beta(r[i] - d[i] + 1, d[i]))
        r[i] = rand(Poisson((1 - p[]) * zi * vi)) + d[i]
    end
    return m
end

# Update K := maximum(r; init = 0)
function step_K!(m::AbstractGSBP)
    (; r, K) = get_skeleton(m)
    K[] = maximum(r; init = 0)
    return m
end

# Notes

# [1]
# https://doi.org/10.1016/j.csda.2020.106940

# [2]
# https://pubmed.ncbi.nlm.nih.gov/25279391
