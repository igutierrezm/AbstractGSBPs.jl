# Getting Started

This user guide describes the main tools offered by `AbstractGSBPs`
to work with a GSBP.

## Creating a GSBP model

To create a new model, define a new type  `T <: ` [`AbstractGSBP`](@ref)
and specialize these methods:

* [`loglikcontrib()`](@ref).
* [`get_skeleton()`](@ref).
* [`step_atoms!()`](@ref).
* [`step_atom!()`](@ref).
* [`rand_ynew!()`](@ref).

In a nutshell, you should explain:

- How to compute the likelihood contribution of a single observation.
- How to expose the standard blocks of the model (*aka*, its *skeleton*).
- How to simulate out-of-sample outcomes.
- How to update the atoms.

## Using a GSBP model

### Accesing the model variables

You can inspect the main components of a GSBP `m` using the following methods:

* [`get_y()`](@ref): return the sample of outcomes.
* [`get_x()`](@ref): return the sample of features.
* [`get_cluster_labels()`](@ref): return the sample of cluster labels.
* [`gen_mixture_density()`](@ref): return the mixture density at a given point.
* [`gen_mixture_weight()`](@ref): return one of the mixture weights.

See [`AbstractGSBP`](@ref) for details.

### Updating the model parameters

You can update the parameters of a GSBP `m` using the Gibbs sampler described
in [[1]](https://doi.org/10.1016/j.csda.2020.106940) using
[`step!()`](@ref).

### Worked example

