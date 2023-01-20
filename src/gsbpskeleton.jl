@doc raw"""
    GSBPSkeleton(; kwargs...)

The standard blocks of a GSBP, namely
``(y, x, a_{0p}, a_{0s}, b_{0p}, b_{0s}, s, p, r, d)``.

# Required keywords

* `y::Vector{T}`: The sample of outcomes (one element per observation).
* `x::Vector{S}`: The sample of features (one element per observation).

# Optional keywords

* `a0p::Float64 = init_a0p()`: ``a_{0p}``.
* `a0s::Float64 = init_a0s()`: ``a_{0s}``.
* `b0p::Float64 = init_b0p()`: ``b_{0p}``.
* `b0s::Float64 = init_b0s()`: ``b_{0s}``.
* `s::Float64 = init_s()`: ``s``.
* `p::Float64 = init_p()`: ``p``.
* `r::Vector{Int} = init_r(y)`: ``r := (r_1, \ldots, r_N)``.
* `d::Vector{Int} = init_d(y)`: ``d := (d_1, \ldots, d_N)``.

See also [`AbstractGSBP`](@ref).
"""
struct GSBPSkeleton{T, S}
    # Data
    y::Vector{T} # outcomes
    x::Vector{S} # predictors
    # Hyperparameters
    a0p::Float64 # p ~ Beta(a0p, b0p), α in [1]
    b0p::Float64 # p ~ Beta(a0p, b0p), β in [1]
    a0s::Float64 # s ~ Gamma(a0s, 1 / b0s)
    b0s::Float64 # s ~ Gamma(a0s, 1 / b0s)
    # Parameters
    p::Base.RefValue{Float64} # as in [1]
    s::Base.RefValue{Float64} # as in [1]
    r::Vector{Int} # as in [1]
    d::Vector{Int} # as in [1]
    # Transformed parameters
    K::Base.RefValue{Int} # := 1 + max(r)
    function GSBPSkeleton(;
        # Data
        y::Vector{T},
        x::Vector{S},
        # Hyperparameters
        a0p::Float64 = init_a0p(),
        b0p::Float64 = init_b0p(),
        a0s::Float64 = init_a0s(),
        b0s::Float64 = init_b0s(),
        # Parameters
        p::Float64 = init_p(),
        s::Float64 = init_s(),
        r::Vector{Int} = init_r(y),
        d::Vector{Int} = init_d(y),
    ) where {T, S}
        # Check data
        val_y(y)
        val_x(x, y)
        # Check hyperparameters
        val_a0p(a0p)
        val_b0p(b0p)
        val_a0s(a0s)
        val_b0s(b0s)
        # Check parameters
        val_p(p)
        val_s(s)
        val_r(r, y)
        val_d(d, r)
        # Generate transformed parameters
        K = 1 + maximum(r; init = 0)
        # Return the validated skeleton
        new{T, S}(y, x, a0p, b0p, a0s, b0s, Ref(p), Ref(s), r, d, Ref(K))
    end
end

# Initializers

function init_a0p()
    1.0
end

function init_b0p()
    1.0
end

function init_a0s()
    8.0
end

function init_b0s()
    4.0
end

function init_p()
    0.5
end

function init_s()
    2.0
end

function init_r(y)
    N = length(y)
    C = max(5, log(N))
    C = ceil(Int, C)
    ones(Int, N) * C
end

function init_d(y)
    N = length(y)
    C = max(5, log(N))
    C = ceil(Int, C)
    rand(1:C, N)
end

# Validators

function val_y(y)
    @assert length(y) > 0
    @assert length(y[1]) > 0
    @assert all(length.(y) .== length(y[1]))
end

function val_x(x, y)
    @assert length(x) == length(y)
    @assert all(length.(x) .== length(x[1]))
end

function val_a0p(a0p)
    @assert a0p > 0
end

function val_b0p(b0p)
    @assert b0p > 0
end

function val_a0s(a0s)
    @assert a0s > 0
end

function val_b0s(b0s)
    @assert b0s > 0
end

function val_p(p)
    @assert 0 < p < 1
end

function val_s(s)
    @assert s > 0
end

function val_r(r, y)
    @assert length(r) == length(y)
    @assert all(r .> 0)
end

function val_d(d, r)
    @assert length(d) == length(r)
    @assert all(1 .≤ d .≤ r)
end

# Notes

# [1]
# https://doi.org/10.1016/j.csda.2020.106940

# [2]
# https://pubmed.ncbi.nlm.nih.gov/25279391
