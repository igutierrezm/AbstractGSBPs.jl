# Getting Started

This user guide describes the main tools offered by `AbstractGSBPs`
to work with a GSBP.

## Creating a GSBP model

To create a new model, create a subtype of [`AbstractGSBP`](@ref)
and specialize these methods:

* [`get_skeleton()`](@ref).
* [`rand_ynew!()`](@ref).
* [`step_atom!()`](@ref).
* [`step_atoms!()`](@ref).
* [`loglikcontrib()`](@ref).

## Using a GSBP model

### Accesing the model variables

You can inspect the main components of a GSBP `m` using the following methods:

* [`get_y(m)`](@ref): return the sample of outcomes.
* [`get_x(m)`](@ref): return the sample of features.
* [`get_labels(m)`](@ref): return the sample of cluster labels.
* [`get_weight()`](@ref): return one of the implied mixture weights.
* [`get_mixture()`](@ref): return the implied mixture at a given point.

See [`AbstractGSBP`](@ref) for details.

### Updating the model parameters

You can update the parameters of a GSBP `m` using the Gibbs sampler described
in [[1]](https://doi.org/10.1016/j.csda.2020.106940) using
[`step!()`](@ref).

### Generators

You can generate some quantites from the model parameters using the following methods:

* [`get_fgrid()`](@ref).
