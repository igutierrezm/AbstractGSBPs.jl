@doc raw"""
    AbstractGSBP

An abstract representation of a geometric stick breaking process
in hierarchical form:

```math
\begin{aligned}
    y_i \mid x_i, \theta_{d_i}
    & \sim
    f(\cdot \mid x_i, \theta_{d_i}),
    &
    i
    &=
    1, \ldots, N
    \\
    d_i
    & \sim
    \text{Uniform}(\cdot \mid 1, r_i),
    &
    i
    &=
    1, \ldots, N
    \\
    r_i - 1
    & \sim
    \text{NegativeBinomial}(\cdot \mid s, p),
    &
    i
    &=
    1, \ldots, N
    \\
    \theta_k
    & \sim
    g(\cdot),
    &
    k
    &\in
    \mathbb{N}
    \\
    s
    & \sim
    \text{Gamma}(\cdot \mid a_{0s}, 1 / b_{0s}),
    \\
    p
    & \sim
    \text{Gamma}(\cdot \mid a_{0p}, 1 / b_{0p}),
\end{aligned}
```

under the notation introduced in [AbstractGSBPs](@ref).

See also [`AbstractGSBPs`](@ref).
"""
abstract type AbstractGSBP end
