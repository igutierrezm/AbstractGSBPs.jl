@doc raw"""
    AbstractGSBP

An abstract representation of a (fixed-weight) dependent geometric stick
breaking process ([[1]](https://doi.org/10.1016/j.spl.2009.01.005),
[[2]](https://doi.org/10.1016/j.csda.2020.106940)), namely:[^1]

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

This is the GSBP described in [[2]](https://doi.org/10.1016/j.csda.2020.106940),
with two minor modifications:

* We allow for feature-dependent ``f(\cdot)``.
* We allow for a random ``s``.

[^1]:
    For notational convenience,
    I'll parametrize each distribution as in
    Distributions.jl, I'll represent each distribution through its pdf/pmf, and
    I'll represent each pdf/pmf using the so-called *probability notation*
    [[1, p. 6]](http://www.stat.columbia.edu/~gelman/book/).
"""
abstract type AbstractGSBP end
