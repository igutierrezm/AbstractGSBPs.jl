@doc raw"""
    push_observation!(m::AbstractGSBP; y0, x0, d0::Int, r0::Int)

Push an observation (including its unit-specific parameters) to the model.

See also [`AbstractGSBP`](@ref).
"""
function push_observation!(m::AbstractGSBP; y0, x0, d0, r0)
    @assert d0 <= r0
    (; y, x, r, d) = get_skeleton(m)
    push!(y, y0)
    push!(x, x0)
    push!(d, d0)
    push!(r, r0)
    return m
end

@doc raw"""
    pop_observation!(m::AbstractGSBP)

Pop an observation (including its unit-specific parameters) from the model.

See also [`AbstractGSBP`](@ref).
"""
function pop_observation!(m::AbstractGSBP)
    (; y, x, r, d) = get_skeleton(m)
    pop!(y)
    pop!(x)
    pop!(d)
    pop!(r)
    return m
end
