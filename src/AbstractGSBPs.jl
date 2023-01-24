@doc raw"""
    AbstractGSBPs

AbstractGSBPs offers tools for working with geometric stick breaking
processes [(GSBP)](https://doi.org/10.1016/j.csda.2020.106940), namely:[^1]

```math
\begin{aligned}
    y_i \mid x_i, w, \theta
    & \sim
    \textstyle{\sum_{k \geq 1}}
    w_k f(\cdot \mid x_i, \theta_k),
    &
    i
    &=
    1, \ldots, N
    \\
    w_k
    & =
    \textstyle{\sum_{\ell \geq k}}
    \text{NegativeBinomial}(\ell \mid s, p) / \ell,
    &
    k
    &\in
    \mathbb{N}
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

where:

* All the aforementioned variables are independent by default.
* ``y_i`` comprises the outcomes associated to the ``i``th observation.
* ``x_i`` comprises the features associated to the ``i``th observation.
* ``(a_{0p}, a_{0s}, b_{0p}, b_{0s})`` is a tuple of hyperparameters.
* ``f(\cdot)`` and ``g(\cdot)`` are known pdfs/pmfs.

and, for notational convenience:

- I parametrize each distribution as in Distributions.jl.
- I represent each pdf/pmf using the so-called *probability notation*
    [[1, p. 6]](http://www.stat.columbia.edu/~gelman/book/)[^2].
- I represent each distribution through its pdf/pmf[^3].

In particular, `AbstractGSBPs` offers methods for:

- Defining custom GSBPs.
- Initializing their parameters.
- Evaluating the mixture density at an out-of-sample point.
- Performing one iteration of the Gibbs samplers decribed in
    [[1]](https://doi.org/10.1016/j.csda.2020.106940) and
    [[2]](https://pubmed.ncbi.nlm.nih.gov/25279391).

[^1]:
    This is the GSBP described in
    [[2]](https://doi.org/10.1016/j.csda.2020.106940)
    with two minor modifications: I allow for feature-dependent ``f(\cdot)``
    and a random ``s``.

[^2]:
    So, for example,
    ``\text{Gamma}(\cdot \mid a_{0p}, 1 / b_{0p})`` represents
    the pdf of a ``\text{Gamma}(a_{0p}, 1 / b_{0p})`` distribution.

[^3]:
    So, for example,
    ``p \sim \text{Gamma}(\cdot \mid a_{0p}, 1 / b_{0p})``
    should be interpreted as ``p \sim \text{Gamma}(a_{0p}, 1 / b_{0p})``.
"""
module AbstractGSBPs


# Imports
using Distributions: Beta, DiscreteUniform, Gamma, NegativeBinomial, Poisson
using HypergeometricFunctions: _₂F₁
using SpecialFunctions: logabsbeta

# Exports
export AbstractGSBP
export get_cluster_labels
export get_skeleton
export gen_mixture_weight
export gen_mixture_density
export get_x
export get_y
export GSBPSkeleton
export init_a0p
export init_a0s
export init_b0p
export init_b0s
export init_d
export init_p
export init_r
export init_s
export init_xgrid
export init_ygrid
export loglikcontrib
export pop_observation!
export push_observation!
export rand_dnew
export rand_rnew
export rand_ynew!
export step_atom!
export step_atoms!
export step!

# Each GSBP must be a subtype of AbstractGSBP:
include("abstractgsbp/abstractgsbp.jl")

# Each GSBP must extend `GSBPSkeleton` by composition:
include("gsbpskeleton.jl")

# Each GSBP must implement the following methods:
include("interface.jl")

# The functionality provided for each GSBP satisfying the contract is here:
include("abstractgsbp/accessors.jl")
include("abstractgsbp/generators.jl")
include("abstractgsbp/mutators.jl")
include("abstractgsbp/samplers.jl")

end
