@doc raw"""
    get_y(m::AbstractGSBP)

Return the sample of outcomes: ``y = (y_1, \ldots, y_N)``.

See also [`AbstractGSBP`](@ref).
"""
function get_y(m::AbstractGSBP)
    return get_skeleton(m).y
end

@doc raw"""
    get_x(m::AbstractGSBP)

Return the sample of features: ``x = (x_1, \ldots, x_N)``.

See also [`AbstractGSBP`](@ref).
"""
function get_x(m::AbstractGSBP)
    return get_skeleton(m).x
end

@doc raw"""
    get_cluster_labels(m::AbstractGSBP)

Return the vector of cluster labels: ``d = (d_1, \ldots, d_N)``.

See also [`AbstractGSBP`](@ref).
"""
function get_cluster_labels(m::AbstractGSBP)
    return get_skeleton(m).d
end
