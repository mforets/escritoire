using Revise, Reachability, LazySets, MathematicalSystems

import IntervalArithmetic
const IA = IntervalArithmetic
using LinearAlgebra
const IVP = InitialValueProblem
const LCS = LinearContinuousSystem

function discretizar_homog(S, δ)
    A, X0 = S.s.A, S.x0
    ϕ = Reachability.ReachSets.exp_Aδ(A, δ, exp_method="base")
    Phi2Aabs = Reachability.ReachSets.Φ₂(abs.(A), δ, exp_method="base")
    Einit = symmetric_interval_hull(Phi2Aabs * symmetric_interval_hull((A * A) * X0))
    Ω0 = Reachability.ReachSets._discretize_interpolation_homog(X0, ϕ, Einit, Val(:lazy))
    Pdiscr = ConstrainedLinearDiscreteSystem(ϕ, stateset(S.s))
    return InitialValueProblem(Pdiscr, Ω0)
end

function discretization(P, δ)
    S = Reachability.normalize(P.s)
    P = InitialValueProblem(S, P.x0)
    return discretizar_homog(P, δ)
end

# uniform block partition
function _decompose(S::LazySet{N}, partition::AbstractVector{<:AbstractVector{Int}}, block_options::Type{T}) where {N, T<:LazySet}
    n = dim(S)
    result = Vector{T}(undef, length(partition))

    @inbounds for (i, block) in enumerate(partition)
        result[i] = project(S, block, block_options, n)
    end
    return CartesianProductArray(result)
end

# GENERIC
function reach_homog!(res, ϕ, Xhat0, δ, N, vars, block_indices, row_blocks, column_blocks, NUM, ST)
 
    # store first element
    ti, tf = 0.0, δ
    R0 = ReachSet(CartesianProductArray(Xhat0[block_indices]), ti, tf)
    res[1] = SparseReachSet(R0, vars)

    # cache matrix
    ϕpowerk = copy(ϕ)
    ϕpowerk_cache = similar(ϕ)

    # preallocate buffer for each row-block
    buffer = Vector{LazySets.LinearMap{NUM, ST, NUM, Matrix{NUM}}}(undef, length(column_blocks))

    # preallocate overapproximated Minkowski sum for each row-block
    Xhatk = Vector{ST}(undef, length(row_blocks))

    @inbounds for k in 2:N
        for (i, bi) in enumerate(row_blocks) # loop over row-blocks of interest
            for (j, bj) in enumerate(column_blocks) # loop over all column-blocks
                buffer[j] = ϕpowerk[bi, bj] * Xhat0[j]
            end
            Xhatk[i] = overapproximate(MinkowskiSumArray(buffer), ST)
        end
        ti = tf
        tf += δ
        Rk = ReachSet(CartesianProductArray(copy(Xhatk)), ti, tf)
        @inbounds res[k] = SparseReachSet(Rk, vars)

        mul!(ϕpowerk_cache, ϕpowerk, ϕ)
        copyto!(ϕpowerk, ϕpowerk_cache)
    end
    return res
end

# INTERVALS
function reach_homog!(res, ϕ, Xhat0, δ, N, vars, block_indices, row_blocks, column_blocks,
                      NUM, ST::Type{<:Interval})

    # store first element
    ti, tf = 0.0, δ
    R0 = ReachSet(CartesianProductArray(Xhat0[block_indices]), ti, tf)
    res[1] = SparseReachSet(R0, vars)

    # cache matrix
    ϕpowerk = copy(ϕ)
    ϕpowerk_cache = similar(ϕ)

    # preallocate overapproximated Minkowski sum for each row-block
    Xhatk = Vector{ST}(undef, length(row_blocks))

    @inbounds for k in 2:N
        for (i, bi) in enumerate(row_blocks) # loop over row-blocks of interest
            Xhatk[i] = Interval(zero(NUM), zero(NUM))
            for (j, bj) in enumerate(column_blocks) # loop over all column-blocks
                Xhatk[i] += Interval(ϕpowerk[bi[1], bj[1]] * Xhat0[j].dat)
            end
        end
        ti = tf
        tf += δ
        Rk = ReachSet(CartesianProductArray(copy(Xhatk)), ti, tf)
        res[k] = SparseReachSet(Rk, vars)

        mul!(ϕpowerk_cache, ϕpowerk, ϕ)
        copyto!(ϕpowerk, ϕpowerk_cache)
    end
    return res
end

function solve_BFFPSV18(P::IVP{<:LCS, <:LazySet}, opts)
    
    # unwrap some options
    vars = opts[:vars]
    δ = opts[:δ]
    N = opts[:N]
    NUM = opts[:num_type]
    ST = opts[:set_type]
    partition = opts[:partition]
    block_indices = opts[:block_indices]
    column_blocks = opts[:column_blocks]
    row_blocks = opts[:row_blocks]

    # normalize and discretize system
    Pdiscr = discretization(P, δ)

    Ω0 = Pdiscr.x0 # bloated initial set
    # decompose into a cartesian product
    Ω0deco = _decompose(Ω0, partition, ST)

    Xhat0 = Ω0deco.array # pointer to the CPA array
    ϕ = Pdiscr.s.A

    # preallocate output flowpipe
    SRS = SparseReachSet{CartesianProductArray{NUM, ST}}
    res = Vector{SRS}(undef, N)
    
    # compute flowpipe
    reach_homog!(res, ϕ, Xhat0, δ, N, vars, block_indices, row_blocks, column_blocks, NUM, ST)

    return res
end
