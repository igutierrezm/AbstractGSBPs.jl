#region Constructor
@doc raw"""
    GSBPSkeleton(; kwargs...)

The standard blocks of a GSBP, namely
``(y, x, a_{0p}, a_{0s}, b_{0p}, b_{0s}, s, p, r, d)``.

# Required keywords

* `y::Vector{T}`: The sample of outcomes (one element per observation).
* `x::Vector{S}`: The sample of features (one element per observation).

# Optional keywords

* `a0p::Float64 = init_a0p()`: ``a_{0p}``.
* `b0p::Float64 = init_b0p()`: ``b_{0p}``.
* `a0s::Float64 = init_a0s()`: ``a_{0s}``.
* `b0s::Float64 = init_b0s()`: ``b_{0s}``.
* `s::Float64 = init_s()`: ``s``.
* `p::Float64 = init_p()`: ``p``.
* `r::Vector{Int} = init_r(y)`: ``r := (r_1, \ldots, r_N)``.
* `d::Vector{Int} = init_d(y)`: ``d := (d_1, \ldots, d_N)``.

See also [`AbstractGSBP`](@ref).
"""
struct GSBPSkeleton{T, S}
    # Data
    y::Vector{T} # sample of outcomes
    x::Vector{S} # sample of features
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
    K::Base.RefValue{Int} # := max(r)
    function GSBPSkeleton(;
        # Required data
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
        rp = Ref(p)
        rs = Ref(s)
        rK = Ref(maximum(r; init = 0))
        # Return the validated skeleton
        new{T, S}(y, x, a0p, b0p, a0s, b0s, rp, rs, r, d, rK)
    end
end
#endregion

#region Initializers

"""
    init_a0p()

Return the dafault initial value of ``a_{0p}``: `a0p = 1.0`.

See also [`AbstractGSBP`](@ref).
"""
function init_a0p()
    1.0
end

"""
    init_b0p()

Return the dafault initial value of ``b_{0p}``: `b0p = 1.0`.

See also [`AbstractGSBP`](@ref).
"""
function init_b0p()
    1.0
end

"""
    init_a0s()

Return the dafault initial value of ``a_{0s}``: `a0s = 8.0`.

See also [`AbstractGSBP`](@ref).
"""
function init_a0s()
    8.0
end

"""
    init_b0s()

Return the dafault initial value of ``b_{0s}``: `b0s = 4.0`.

See also [`AbstractGSBP`](@ref).
"""
function init_b0s()
    4.0
end

"""
    init_p()

Return the dafault initial value of ``p``: `p = 0.5`.

See also [`AbstractGSBP`](@ref).
"""
function init_p()
    0.5
end

"""
    init_s()

Return the dafault initial value of ``s``: `s = 2.0`.

See also [`AbstractGSBP`](@ref).
"""
function init_s()
    2.0
end

"""
    init_r(y::Vector{T}) where {T}

Return the dafault initial value of ``r``: `r = ones(Int, length(y))`.

See also [`AbstractGSBP`](@ref).
"""
function init_r(y::Vector{T}) where {T}
    ones(Int, length(y))
end

"""
    init_d(y::Vector{T}) where {T}

Return the dafault initial value of ``d``: `d = ones(Int, length(y))`.

See also [`AbstractGSBP`](@ref).
"""
function init_d(y::Vector{T}) where {T}
    ones(Int, length(y))
end
#endregion

#region Validators

function val_y(y::Vector{T}) where {T}
    @assert length(y) > 0
    @assert length(y[1]) > 0
    @assert all(length.(y) .== length(y[1]))
end

function val_x(x::Vector{S}, y::Vector{T}) where {S, T}
    @assert length(x) == length(y)
    @assert all(length.(x) .== length(x[1]))
end

function val_a0p(a0p::Float64)
    @assert a0p > 0
end

function val_b0p(b0p::Float64)
    @assert b0p > 0
end

function val_a0s(a0s::Float64)
    @assert a0s > 0
end

function val_b0s(b0s::Float64)
    @assert b0s > 0
end

function val_p(p::Float64)
    @assert 0 < p < 1
end

function val_s(s::Float64)
    @assert s > 0
end

function val_r(r::Vector{Int}, y::Vector{T}) where {T}
    @assert length(r) == length(y)
    @assert all(r .> 0)
end

function val_d(d::Vector{Int}, r::Vector{Int})
    @assert length(d) == length(r)
    @assert all(1 .≤ d .≤ r)
end
#endregion

#region Notes

# [1]
# https://doi.org/10.1016/j.csda.2020.106940

# [2]
# https://pubmed.ncbi.nlm.nih.gov/25279391
#endregion
