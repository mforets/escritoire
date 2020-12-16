# =========================================================================================================================
# Theoretical error bounds
#
# References:
#
# - [1] Explicit Error Bounds for Carleman Linearization: https://arxiv.org/abs/1711.02552
#
# - [2] Efficient quantum algorithm for dissipative nonlinear differential equations: https://arxiv.org/pdf/2011.03185.pdf   
#
# =========================================================================================================================

using LinearAlgebra
using SparseArrays
using Kronecker

# See Theorem 4.2 in [1]
function error_bound_apriori(α, F₁, F₂; N, p=Inf)
    nF₂ = opnorm(F₂, p)
    μF₁ = logarithmic_norm(F₁, p)

    β = α * nF₂ / μF₁
    ε = t -> α * β^N * (exp(μF₁ * t) - 1)^N
    return ε
end

# See Theorem 4.2 in [1]
function convergence_radius_apriori(α, F₁, F₂; N, p=Inf)
    nF₂ = opnorm(F₂, p)
    μF₁ = logarithmic_norm(F₁, p)
    
    β = α * F₂ / μF₁
    T = (1/μF₁) * log(1 + 1/β)
    return T
end

# see Theorem 4.3 in [1]
function error_bound_pseries(x₀, F₁, F₂; N, p=Inf)
    nx₀ = norm(x₀, p)
    nF₁ = opnorm(F₁, p)
    nF₂ = opnorm(F₂, p)

    β₀ = nx₀ * nF₂ / nF₁
    ε = t -> nx₀ * exp(nF₁ * t) / (1 - β₀ * (exp(nF₁ * t) - 1)) * (β₀ * (exp(nF₁ * t) - 1))^N
    return ε
end

function convergence_radius_pseries(x₀, F₁, F₂; N, p=Inf)
    nx₀ = norm(x₀, p)
    nF₁ = opnorm(F₁, p)
    nF₂ = opnorm(F₂, p)
    
    β₀ = nx₀ * nF₂ / nF₁
    T = (1/nF₁) * log(1 + 1/β₀)
    return T
end

# see Lemma 2 in [2]
function error_bound_specabs(x₀, F₁, F₂; N, p=Inf, check=true)
    nx₀ = norm(x₀, p)  
    
    # compute eigenvalues and sort them by increasing real part
    λ = eigvals(F₁, sortby=real)
    λ₁ = last(λ)
    Re_λ₁ = real(λ₁)
    nF₂ = opnorm(F₂, p)
    R = nx₀ * nF₂ / Re_λ₁ 
    if check
        @assert Re_λ₁ < 1 "expected R < 1, got R = $R; try scaling the ODE"
        @assert R < 1 "expected R < 1, got R = $R; try scaling the ODE"
    end
    ε = t -> nx₀ * R^N * (1 - exp(Re_λ₁ * t))^N
    return ε
end

# TODO: build sparse matrices directly
function linearize_N4(F1, F2)
    n = size(F1, 1)
    @assert size(F1, 1) == size(F2, 1) == n
    @assert size(F2, 2) == n^2

    Id = sparse(Matrix(1.0I, n, n))
    A11 = sparse(F1)
    A12 = sparse(F2)
    A13 = sparse(zeros(n, n^3))
    A14 = sparse(zeros(n, n^4))

    A21 = sparse(zeros(n^2, n))
    A22 = sparse(collect(F1 ⊗ Id + Id ⊗ F1));
    A23 = sparse(collect(F2 ⊗ Id + Id ⊗ F2));
    A24 = sparse(zeros(n^2, n^4))

    A31 = sparse(zeros(n^3, n))
    A32 = sparse(zeros(n^3, n^2))
    A33 = sparse(collect(F1 ⊗ Id ⊗ Id + Id ⊗ F1 ⊗ Id + Id ⊗ Id ⊗ F1));
    A34 = sparse(collect(F2 ⊗ Id ⊗ Id + Id ⊗ F2 ⊗ Id + Id ⊗ Id ⊗ F2));

    A41 = sparse(zeros(n^4, n))
    A42 = sparse(zeros(n^4, n^2))
    A43 = sparse(zeros(n^4, n^3))
    A44 = sparse(collect(F1 ⊗ Id ⊗ Id ⊗ Id + Id ⊗ F1 ⊗ Id ⊗ Id + Id ⊗ Id ⊗ F1 ⊗ Id + Id ⊗ Id ⊗ Id ⊗ F1));
    
    A1 = [A11 A12 A13 A14];
    A2 = [A21 A22 A23 A24];
    A3 = [A31 A32 A33 A34];
    A4 = [A41 A42 A43 A44];
    
    A_N4 = [A1; A2; A3; A4]
    
    return A_N4
end

# ======================================
# Kronecker powers
# ======================================

using ReachabilityAnalysis

import Base: kron

Base.kron(R::TaylorModelReachSet, S::TaylorModelReachSet) = kronecker(R, S)
Base.kron(R::TaylorModelReachSet, pow::Integer) = kronecker(R, pow)

# compute the Kronecker product R ⊗ R
function kronecker(R::TaylorModelReachSet, S::TaylorModelReachSet)
    Δt = tspan(R)
    @assert Δt == tspan(S)
    P = set(R)
    Q = set(S)

    out = Vector{eltype(P)}()
    for (i, pi) in enumerate(P)
        for qj in Q
            push!(out, pi * qj)
        end
    end
    return TaylorModelReachSet(out, Δt)
end

# higher order concrete Kronecker power: R ⊗ R ⊗ ... ⊗ R, pow times
function kronecker(R::TaylorModelReachSet, pow::Integer)
    @assert pow > 0 "expected positive power, got $pow"
    if pow == 1
        return R
    else
        return kron(R, kron(R, pow-1))
    end
end

# [X, X ⊗ X, X ⊗ X ⊗ X, ... , X]
function kronecker_stack(X::TaylorModelReachSet, order::Integer)
    out = [kronecker(X, pow) for pow in 1:order]
    Y = reduce(vcat, set.(out))
    return TaylorModelReachSet(Y, tspan(X))
end

# for an interval x and an integer pow, compute [x, x^2, x^3, ... , x^pow]
function kronecker_powers(x::IA.Interval, pow::Integer)
    [x^i for i in 1:pow]
end
