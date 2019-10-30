# =================================================
# Load dependencies and define convenience aliases
# =================================================

include("startup.jl")

# ============================
# Discretization
# ============================

include("discretization.jl")

# ============================
# Implementation of BFFPSV18
# ============================

# x' = Ax
include("reach_homog.jl")

# x' = Ax + u, u in U
include("reach_inhomog.jl")

# ============================
# User API
# ============================

include("solve.jl")

# ==========================
# Post-processing functions
# ==========================

include("process.jl")
