module AbstractGSBPs

export get_skeleton
export step_atoms!
export step_atom!
export logf

export GSBPSkeleton

# Each GSBP must be a subtype of AbstractGSBP:
include("abstractgsbp.jl")

# Each GSBP must extend `GSBPSkeleton` by composition:
include("gsbpskeleton.jl")

# Each GSBP must implement the following methods:
include("interface.jl")

# The functionality provided for each GSBP satisfying the contract is here:
include("methods.jl")

end
