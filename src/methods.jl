function get_y(m::AbstractGSBP)
    return get_skeleton(m).y
end

function get_x(m::AbstractGSBP)
    return get_skeleton(m).x
end

function get_labels(m::AbstractGSBP)
    return get_skeleton(m).d
end

function get_ncomponents(m::AbstractGSBP)
    return get_skeleton(m).K[]
end

function push_observation!(m::AbstractGSBP; ynew, xnew, dnew, rnew)
    @assert dnew <= rnew
    (; y, x, r, d) = get_skeleton(m)
    push!(y, ynew)
    push!(x, xnew)
    push!(d, dnew)
    push!(r, rnew)
    return m
end

function pop_observation!(m::AbstractGSBP)
    (; y, x, r, d) = get_skeleton(m)
    pop!(y)
    pop!(x)
    pop!(d)
    pop!(r)
    return m
end

function step!(m::AbstractGSBP)
    step_atoms!(m, get_ncomponents(m))
    step_p!(m)
    step_s!(m)
    step_d!(m)
    step_r!(m)
    step_K!(m)
    return m
end

function step_p!(m::AbstractGSBP)
    (; a0p, b0p, r, s, p) = get_skeleton(m)
    p[] = rand(Beta(s[] * length(r) + a0p, sum(r) + b0p - length(r)))
    return m
end

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

function step_d!(m::AbstractGSBP)
    (; y, x, r, d) = get_skeleton(m)
    for i in eachindex(y)
        yi = y[i]
        xi = x[i]
        ri = r[i]
        kstar = 0
        pstar = -Inf
        for k in 1:ri
            p = logkernel(m, yi, xi, k) - log(-log(rand()))
            if p > pstar
                kstar = k
                pstar = p
            end
        end
        d[i] = kstar
    end
    return m
end

function step_r!(m::AbstractGSBP)
    (; r, d, s, p) = get_skeleton(m)
    for i in eachindex(r)
        vi = rand(Gamma(r[i] + s[] - 1, 1))
        zi = rand(Beta(r[i] - d[i] + 1, d[i]))
        r[i] = rand(Poisson((1 - p[]) * zi * vi)) + d[i]
    end
    return m
end

function step_K!(m::AbstractGSBP)
    (; r, K) = get_skeleton(m)
    K[] = 1 + maximum(r; init = 0)
    return m
end

function get_weights(m::AbstractGSBP, C::Int)
    (; p, s) = get_skeleton(m)
    w = zeros(C)
    wrem = 1.0
    for c = 1:(C - 1)
        if s[] ≈ 2.0
            w[c] = p[] * (1 - p[])^(c - 1)
        elseif s[] ≈ 3.0
            w[c] = p[] * (1 - p[])^(c - 1) * (1 + c * p[]) / 2
        else
            logwc =
                - log(c) -
                log(c + s[] - 1) -
                logabsbeta(c, s[])[1] +
                s[] * log(p[]) +
                (c - 1) * log(1 - p[]) +
                log(_₂F₁(big(c + s[] - 1), 1, c + 1, 1 - p[]))
            w[c] = exp(logwc)
        end
        wrem -= w[c]
    end
    w[C] = wrem
    return w
end

# function get_fgrid!(
#     m::AbstractGSBP;
#     fgrid::Vector{Float64},
#     ygrid,
#     xgrid
# )
#     (; y, x, K, w) = get_skeleton(m)
#     val_ygrid(ygrid, y)
#     val_fgrid(fgrid, ygrid)
#     val_xgrid()
#     w = get_weights(m, K[])
#     for i in eachindex(fgrid)
#         f0 = 0.0
#         y0 = ygrid[i]
#         x0 = xgrid[i]
#         for k in 1:K[]
#             f0 += w[k] * exp(logkernel(m, y0, x0, k))
#         end
#         fgrid[i] = f0
#     end
#     return fgrid
# end

# function val_ygrid(ygrid, y)
#     @assert !isempty(ygrid)
#     @assert all(length.(ygrid) .== length(y[1]))
# end

# function val_fgrid(fgrid::Vector{Float64}, ygrid)
#     @assert length(fgrid) == length(ygrid)
# end

# function val_xgrid(xgrid, ygrid, x)
#     @assert length(xgrid) == length(ygrid)
#     @assert all(length.(xgrid) .== length(x[1]))
# end

function sim_rnew(m::AbstractGSBP)
    (; s, p) = get_skeleton(m)
    return 1 + rand(NegativeBinomial(s[], p[]))
end

function sim_rnew(m::AbstractGSBP, rnew)
    return rand(1:rnew)
end
