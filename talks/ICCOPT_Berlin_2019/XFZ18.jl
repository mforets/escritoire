# load dependencies
using MultivariatePolynomials,
      DynamicPolynomials,
      JuMP,
      PolyJuMP,
      SumOfSquares,
      MathOptInterfaceMosek,
      SemialgebraicSets,
      MathematicalSystems

const MP = MultivariatePolynomials
const ∂ = MP.differentiate

import IntervalArithmetic
const IA = IntervalArithmetic

# solvers
using MosekTools,
      SDPA

using Reachability
using MathematicalSystems: PolynomialContinuousSystem, InitialValueProblem

using HomotopyContinuation
const HC = HomotopyContinuation

abstract type AbstractSolution end

struct XFZ18Solution{PT} <: AbstractSolution
   obj::Float64
   under::PT
   over::PT
end

# build the SOS problem
function build_sos(S::PolynomialContinuousSystem, opts)

    #@assert statedim(S) == 2
    
    # scale dynamics
    T = opts[:T]
    f = T * S.p

    # time variable
    t = opts[:t]
    
    # define polynomial symbolic variables
    vars = variables(S)
    
    # set of initial states X₀ = {x: V₀(x) <= 0}
    V₀ = opts[:V0] # eg. x₁^2 + x₂^2 - 0.25

    # constraints Y = {x: g(x) >= 0} compact search space Y x [0, T]
    g = opts[:g] # eg. g = 25 - x₁^2 - x₂^2

    k = opts[:relaxation_degree]
    
    # monomial vector up to order k
    # 0 <= sum_i alpha_i <= k, if alpha_i is the exponent of x_i
    X = monomials(vars, 0:k)
    XT = monomials([vars; t], 0:k)

    # create a SOS JuMP model to solve with Mosek
    solver = opts[:solver]
    verbose = opts[:verbose]
    model = SOSModel(with_optimizer(solver, QUIET=!verbose))

    # add unknown Φ to the model
    @variable(model, Φ, Poly(XT))

    # jacobian
    ∂t = α -> ∂(α, t)
    # eg. ∂xf = α -> ∂(α, x₁) * f[1] + ∂(α, x₂) * f[2]
    ∂xf = α -> sum(i -> ∂(α, vars[i]) * f[i], 1:length(vars))
    LΦ = ∂t(Φ) + ∂xf(Φ)

    # Φ(x, t) at time 0
    Φ₀ = subs(Φ, t => 0.)

    # scalar variable
    @variable(model, ϵ)

    dom1 = @set t*(T-t) >= 0 && g >= 0
    dom2 = @set g >= 0
    @constraint(model, ϵ >= 0.)
    @constraint(model, LΦ ∈ SOSCone(), domain = dom1)
    @constraint(model, ϵ - LΦ ∈ SOSCone(), domain = dom1)
    @constraint(model, Φ₀ - V₀ ∈ SOSCone(), domain = dom2)
    @constraint(model, ϵ + V₀ - Φ₀ ∈ SOSCone(), domain = dom2)

    @objective(model, Min, ϵ)
    return model
end

# build the SOS problem, generalized to more than one polynomial
# in the description of the system
function build_sos_gen(S::PolynomialContinuousSystem, opts)

    #@assert statedim(S) == 2
    
    # scale dynamics
    T = opts[:T]
    f = T * S.p

    # time variable
    t = opts[:t]
    
    # define polynomial symbolic variables
    vars = variables(S)
    
    # set of initial states X₀ = {x: V₀(x) <= 0}
    V₀ = opts[:V0] # eg. x₁^2 + x₂^2 - 0.25

    # constraints Y = {x: g(x) >= 0} compact search space Y x [0, T]
    g = opts[:g] # eg. g = 25 - x₁^2 - x₂^2

    k = opts[:relaxation_degree]
    
    # monomial vector up to order k
    # 0 <= sum_i alpha_i <= k, if alpha_i is the exponent of x_i
    X = monomials(vars, 0:k)
    XT = monomials([vars; t], 0:k)

    # create a SOS JuMP model to solve with Mosek
    solver = opts[:solver]
    verbose = opts[:verbose]
    model = SOSModel(with_optimizer(solver, QUIET=!verbose))

    # add unknown Φ to the model
    @variable(model, Φ, Poly(XT))

    # jacobian
    ∂t = α -> ∂(α, t)
    # eg. ∂xf = α -> ∂(α, x₁) * f[1] + ∂(α, x₂) * f[2]
    ∂xf = α -> sum(i -> ∂(α, vars[i]) * f[i], 1:length(vars))
    LΦ = ∂t(Φ) + ∂xf(Φ)

    # Φ(x, t) at time 0
    Φ₀ = subs(Φ, t => 0.)

    # scalar variable
    @variable(model, ϵ)

    dom1 = @set t*(T-t) >= 0 && g >= 0
    dom2 = @set g >= 0
    @constraint(model, ϵ >= 0.)
    @constraint(model, LΦ ∈ SOSCone(), domain = dom1)
    @constraint(model, ϵ - LΦ ∈ SOSCone(), domain = dom1)
    @constraint(model, Φ₀ - V₀ ∈ SOSCone(), domain = dom2)
    @constraint(model, ϵ + V₀ - Φ₀ ∈ SOSCone(), domain = dom2)

    @objective(model, Min, ϵ)
    return model
end

# solve model, check feasibility and return polynomials
function solve!(model, verbose=true)
    
    optimize!(model)
    
    if verbose
        println("JuMP.termination_status(model) = ", JuMP.termination_status(model))
        println("JuMP.primal_status(model) = ", JuMP.primal_status(model))
        println("JuMP.dual_status(model) = ", JuMP.dual_status(model))
        println("JuMP.objective_bound(model) = ", JuMP.objective_bound(model))
        println("JuMP.objective_value(model) = ", JuMP.objective_value(model))
    end
end

# extraction of the underapproximation and overapproximation
function extract(model, opts)

    # time horizon
    T = opts[:T]

    t = opts[:t]

    # recovering the solution:
    ϵopt = JuMP.objective_value(model)

    # Punder <= 0  TODO: @set Punder <= 0
    Punder = subs(JuMP.value(model[:Φ]), t => T)

    # Pover <= 0   TODO: @set Pover <= 0
    Pover = subs(JuMP.value(model[:Φ]), t => T) - ϵopt * (T+1)

    return XFZ18Solution(ϵopt, Punder, Pover)
end

# ================================
# ROOT EXTRACTION
# ================================

using HomotopyContinuation

# compute the real roots of the given polynomial p in two variables
# in the doman -x₂_max ... x₂_max with step-size Δ
function rroots_2d!(sol_vec, p, x₂_max, Δ)
    x₂ = variables(p)[2] # get second variable
    dom = -x₂_max:Δ:x₂_max

    for α ∈ dom
        sol_α = HC.solve([p, x₂ + α])
        push!(sol_vec, real_solutions(sol_α)...)
    end
    return sol_vec
end

# compute the real roots of the given polynomial p in two variables
# in the doman -x₂_max ... x₂_max with step-size Δ
function rroots_2d_old!(sol_vec, p, x₂_max, Δ)
    x₂ = variables(p)[2] # get second variable
    dom = -x₂_max:Δ:x₂_max

    for α ∈ dom
        sol_α = HC.solve([p, x₂ + α])
        sol_α_Re = filter(isreal, collect(sol_α))

        for si in sol_α_Re
            sol_x₁_α = real(si.solution[1]) # complex part is zero
            # α == sol_x₁_α.solution[2]
            push!(sol_vec, [sol_x₁_α, α])
        end
    end
    return sol_vec
end

# ================================
# OPTIMIZATION OVER SUBLEVEL SETS
# ================================

# transform a dom (Interval or IntervalBox) into a basic semialgebraic set
function _get_box_domain(vars, dom)
    if length(vars) == 1
        # box constraints dimension one
        x = first(vars)
        B = @set IA.inf(dom) <= x && x <= IA.sup(dom)
    else
        # box constraints multidimensional case
        x = vars
        N = length(vars)
        Bi =[@set IA.inf(dom[i]) <= x[i] && x[i] <= IA.sup(dom[i]) for i in 1:N]
        B = reduce(intersect, Bi)
    end
    return B
end

# optimize the function f(x) subject to the constraint p(x) <= 0
function optimize_sublevel(p, f, opts)
    # unpack solver and options
    solver = opts[:solver]
    verbose = opts[:verbose]
    order = opts[:relaxation_degree]
    
    model = SOSModel(with_optimizer(solver, QUIET=!verbose))

    # define sub-level set of p as a basic semialgebraic set
    dom = @set p <= 0
    if :domain in keys(opts)
        B = opts[:domain]
        if B isa IA.Interval || B isa IA.IntervalBox
            B = _get_box_domain(variables(p), opts[:domain])
        end
        dom = dom ∩ B
    end
    @variable(model, γ)
    
    # max value of f s.t. sub-level set constraint
    @constraint(model, f <= γ, domain=dom, maxdegree=order)
    @objective(model, Min, γ)

    solve!(model, verbose)
    return objective_value(model)
end

# optimize the function f(x) = <d, x> subject to the constraint p(x) <= 0
function ρ_sublevel(p, d::AbstractVector, opts)
    optimize_sublevel(p, dot(d, variables(p)), opts)
end


# =========================
# TM -> Zonotope flowpipes
# =========================

using LazySets, TaylorModels
const TM = TaylorModels

const zeroI = IA.Interval(1.0)
const oneI = IA.Interval(1.0)
const symI = IA.Interval(-1.0, 1.0)
const zeroBox = IA.IntervalBox(zeroI, 2)
const symBox = IA.IntervalBox(symI, 2)

function to_zonotope_flowpipe(xTM, Nmax)
    m = 2 # dimension 2 only
    res = Vector{Zonotope{Float64}}(undef, Nmax)
   
    for i in 1:Nmax
        Xk = xTM[:, i]
        Δt = Xk[1].dom
        Xk_Δt = TM.evaluate(Xk, Δt)
        X̂k = [TaylorModelN(Xk_Δt[k], Xk[k].rem, zeroBox, symBox) for k in 1:m]
        fX̂k = fp_rpa.(X̂k)
        res[i] = overapproximate(fX̂k, Zonotope)
    end
    return res
end
