@doc raw"""
    get_skeleton(m::AbstractGSBP)

Return the model skeleton, as an object of type `GSBPSkeleton`.

See also [`AbstractGSBP`](@ref), [`GSBPSkeleton`](@ref).
"""
function get_skeleton(m::AbstractGSBP)
    error("not implemented")
end

@doc raw"""
    step_atoms!(m::AbstractGSBP, K::Int)

Update the first ``K`` atoms: ``(\theta_k)_{k=1}^K``.

See also [`AbstractGSBP`](@ref).
"""
function step_atoms!(m::AbstractGSBP, K::Int)
    error("not implemented")
end

@doc raw"""
    step_atom!(m::AbstractGSBP, k::Int)

Update the ``k``th atom: ``\theta_k``.

See also [`AbstractGSBP`](@ref).
"""
function step_atom!(m::AbstractGSBP, k::Int)
    error("not implemented")
end

@doc raw"""
    loglikcontrib(m::AbstractGSBP, y0, x0, d0::Int)

Compute ``\log f(y_0 | x_0, \theta_{d_0})``,
using the current value of ``\theta_{d_0}``.

See also [`AbstractGSBP`](@ref).
"""
function loglikcontrib(m::AbstractGSBP, y0, x0, d0::Int)
    error("not implemented")
end

@doc raw"""
    rand_ynew!(m::AbstractGSBP, ynew, xnew, dnew::Int)

Replace `ynew` with a draw from ``f(y_{new} | x_{new}, \theta_{d_{new}})``,
using the current value of ``\theta_{d_{new}}``.

See also [`AbstractGSBP`](@ref).
"""
function rand_ynew!(m::AbstractGSBP, ynew, xnew, dnew::Int)
    error("not implemented")
end
