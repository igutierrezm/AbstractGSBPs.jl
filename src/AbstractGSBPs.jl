@doc raw"""
    AbstractGSBPs

AbstractGSBPs offers tools for working with geometric stick breaking
processes [(GSBP)](https://doi.org/10.1016/j.csda.2020.106940), namely[^1][^2]

```math
\begin{aligned}
y_i | x_i, d_i, \theta_{d_i}
& \sim
f(\cdot | x_i, \theta_{d_i}),
&
i
&=
1, \ldots, N
\\
d_i | r_i
& \sim
\text{Uniform}(\cdot | 1, r_i),
\\
r_i - 1 | s, p
& \sim
\text{NegativeBinomial}(\cdot | s, p),
\\
s
& \sim
\text{Gamma}(\cdot | a_{0s}, 1 / b_{0s}),
\\
p
& \sim
\text{Gamma}(\cdot | a_{0p}, 1 / b_{0p}),
\\
\theta_k
& \sim
g(\cdot),
\end{aligned}
```

where:

* All the aforementioned variables are independent by default.
* ``y_i`` comprises the outcomes associated to the ``i``th observation.
* ``x_i`` comprises the features associated to the ``i``th observation.
* ``(a_{0p}, a_{0s}, b_{0p}, b_{0s})`` is a tuple of hyperparameters.
* ``f(\cdot)`` and ``g(\cdot)`` are known pdfs/pmfs.

In particular, `AbstractGSBPs` offers methods for:

- Defining custom GSBPs.
- Initializing their parameters.
- Updating their parameters using the Gibbs samplers decribed in
    [[1]](https://doi.org/10.1016/j.csda.2020.106940) and
    [[2]](https://pubmed.ncbi.nlm.nih.gov/25279391).

[^1]:
    This is the GSBP described in
    [[2]](https://doi.org/10.1016/j.csda.2020.106940)
    with two minor modifications: I allow for feature-dependent ``f(\cdot)``
    and a random ``s``.

[^2]:
    For notational convenience,
    I'll parametrize each distribution as in
    Distributions.jl, I'll represent each distribution through its pdf/pmf, and
    I'll represent each pdf/pmf using the so-called *probability notation*
    [[1, p. 6]](http://www.stat.columbia.edu/~gelman/book/).
"""
module AbstractGSBPs


# Imports
using Distributions: Beta, DiscreteUniform, Gamma, NegativeBinomial, Poisson
using HypergeometricFunctions: _₂F₁
using SpecialFunctions: logabsbeta

# Exports
export AbstractGSBP
export GSBPSkeleton
export get_labels
export get_skeleton
export get_x
export get_y
export init_a0p
export init_a0s
export init_b0p
export init_b0s
export init_d
export init_p
export init_r
export init_s
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
include("abstractgsbp.jl")

# Each GSBP must extend `GSBPSkeleton` by composition:
include("gsbpskeleton.jl")

# Each GSBP must implement the following methods:
include("interface.jl")

# The functionality provided for each GSBP satisfying the contract is here:
include("methods.jl")

end
