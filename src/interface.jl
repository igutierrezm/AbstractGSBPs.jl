@doc raw"""
    get_skeleton(m::AbstractGSBP)

Return the model skeleton, as an object of type `GSBPSkeleton`.

See also [`GSBPSkeleton`](@ref).
"""
function get_skeleton(m::AbstractGSBP)
    error("not implemented")
end

@doc raw"""
    step_atoms!(m::AbstractGSBP, K::Int)

Update the atoms associated with the first `K` components.
"""
function step_atoms!(m::AbstractGSBP, K::Int)
    error("not implemented")
end

@doc raw"""
    step_atom!(m::AbstractGSBP, k::Int)

Update the atom associated with the `k`th component.
"""
function step_atom!(m::AbstractGSBP, k::Int)
    error("not implemented")
end

@doc raw"""
    loglikcontrib(m::AbstractGSBP, y0, x0, k::Int)

Compute ``\log f(y_0 | x_0, \theta_k)`` using the current value of ``\theta_k``.
"""
function loglikcontrib(m::AbstractGSBP, y0, x0, k::Int)
    error("not implemented")
end

"""
    rand_ynew!(m::AbstractGSBP, ynew, xnew, dnew)

Simulate a new outcome given a feature vector `xnew`, a cluster label `dnew`
and its current model parameters, then save the result in `ynew`.
"""
function rand_ynew!(m::AbstractGSBP, xnew, dnew, ynew)
    error("not implemented")
end
