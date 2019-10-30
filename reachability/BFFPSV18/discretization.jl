# special cases
@inline _exp_Aδ(A::AbstractMatrix, δ) = exp(Matrix(A * δ))
@inline _exp_Aδ(A::StaticArray, δ) = exp(A * δ)
@inline _exp_Aδ_lazy(A, δ) = SparseMatrixExp(A*δ) # to be selected by a kwarg

# homogeneous case
# we assume that P is a constrained linear continous system
function _discretize_homog(P::IVP{<:CLCS, <:LazySet}, δ)
    A, X0 = P.s.A, P.x0
    ϕ = _exp_Aδ(A, δ)
    Phi2Aabs = Reachability.ReachSets.Φ₂(abs.(A), δ, exp_method="base")
    # "forward" algorithm, uses E⁺
    Einit = symmetric_interval_hull(Phi2Aabs * symmetric_interval_hull((A * A) * X0))
    # cf. Ω0 = Reachability.ReachSets._discretize_interpolation_homog(X0, ϕ, Einit, Val(:lazy))
    Ω0 = ConvexHull(X0, ϕ * X0 ⊕ Einit)
    Pdiscr = ConstrainedLinearDiscreteSystem(ϕ, stateset(P.s))
    return InitialValueProblem(Pdiscr, Ω0)
end

# inhomogeneous case
# we assume that P is a CLCCS with a constant input
function _discretize_inhomog(P::IVP{<:CLCCS, <:LazySet}, δ)
    A, X0 = P.s.A, P.x0
    U0 = inputset(P).U # get the wrapped set, same behavior as next_set(inputset(P), 1)
    ϕ = _exp_Aδ(A, δ)
    Phi2Aabs = Reachability.ReachSets.Φ₂(abs.(A), δ, exp_method="base")
    Einit = symmetric_interval_hull(Phi2Aabs * symmetric_interval_hull((A * A) * X0))
    # cf. _discretize_interpolation_inhomog
    Eψ0 = symmetric_interval_hull(Phi2Aabs * symmetric_interval_hull(A * U0))
    Ω0 = ConvexHull(X0, ϕ * X0 ⊕ δ*U0 ⊕ Eψ0 ⊕ Einit)
    Ud = ConstantInput(δ*U0 ⊕ Eψ0)
    return IVP(CLCDS(ϕ, I(size(A, 1)), stateset(P.s), Ud), Ω0)
end

function discretization(P::IVP{<:LCS, <:LazySet}, δ)
    # transforms to a CLCS (ConstrainedLinearContinuousSystem),
    # where the constraint is the universal set
    Snorm = Reachability.normalize(P.s)
    Pnorm = InitialValueProblem(Snorm, P.x0)
    return _discretize_homog(Pnorm, δ)
end

function discretization(P::IVP{<:CLCCS, <:LazySet}, δ)
    # transforms to a Constrained Linear Control Continuous System
    # in particular, inputs passed as a LazySet are wrapped into a
    # ConstantInput and inputs passed as a vector are wrapped as a
    # VaryingInput
    Snorm = Reachability.normalize(P.s)
    Pnorm = InitialValueProblem(Snorm, P.x0)
    return _discretize_inhomog(Pnorm, δ)
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
