using ReachabilityAnalysis
using LazySets.Arrays

# functions for Kronecker powers and sums
using ReachabilityAnalysis: kron_pow, kron_sum, kron_pow_stack

# functions for error bounds
using ReachabilityAnalysis: error_bound_pseries,
                            error_bound_specabs,
                            convergence_radius_specabs,
                            _error_bound_specabs_R


# functions to build Carleman linearization
using ReachabilityAnalysis: build_matrix, ReachSolution


function _template(; n, N)
    dirs = Vector{SingleEntryVector{Float64}}()
    d = sum(n^i for i in 1:N)

    for i in 1:n
        x = SingleEntryVector(i, d, 1.0)
        push!(dirs, x)
    end
    for i in 1:n
        x = SingleEntryVector(i, d, -1.0)
        push!(dirs, x)
    end
    return CustomDirections(dirs)
end

function _project(sol, vars)
    πsol_1n = Flowpipe([ReachSet(set(project(R, vars)), tspan(R)) for R in sol])
end

function _solve_CARLIN_LGG09(X0, F1, F2;
                             resets=0, N, T, δ, Δt0=interval(0),
                             error_bound_func=error_bound_specabs)
    n = dim(X0)
    dirs = _template(n=n, N=N)
    alg = LGG09(δ=δ, template=dirs)
    if resets == 0
        _solve_CARLIN(X0, F1, F2; alg=alg, N=N, T=T, Δt0=interval(0), error_bound_func=error_bound_func)
    else
        _solve_CARLIN_resets(X0, F1, F2; resets=resets, alg=alg, N=N, T=T, Δt0=interval(0), error_bound_func=error_bound_func)
    end
end

function _solve_CARLIN(X0, F1, F2; alg, N, T, Δt0=interval(0), A=nothing,
                                   error_bound_func=error_bound_specabs)
    
    # lift initial states
    n = dim(X0)
    ŷ0 = kron_pow_stack(X0, N) |> box_approximation

    # solve continuous ODE
    if isnothing(A)
        A = build_matrix(F1, F2, N)
    end
    prob = @ivp(ŷ' = Aŷ, ŷ(0) ∈ ŷ0)
    sol = solve(prob, T=T, alg=alg, Δt0=Δt0)

    # compute errors
    errfunc = error_bound_func(X0, Matrix(F1), Matrix(F2), N=N)

    # evalute error bounds for each reach-set in the solution
    E = [errfunc.(tspan(R)) for R in sol]

    # symmetrize intervals
    E_rad = [symmetric_interval_hull(Interval(ei)) for ei in E]
    E_ball = [BallInf(zeros(n), max(ei)) for ei in E_rad]

    # sum the solution with the error
    # πsol_1n = project(sol, 1:n) # projection onto the first n variables
    πsol_1n = _project(sol, 1:n)
    fp_bloated = [ReachSet(set(Ri) ⊕ Ei, tspan(Ri)) for (Ri, Ei) in zip(πsol_1n, E_ball)] |> Flowpipe
    
    return ReachSolution(πsol_1n, alg), ReachSolution(fp_bloated, alg)
end

function _solve_CARLIN_resets(X0, F1, F2; resets, alg, N, T, Δt0=interval(0),
                                          error_bound_func=error_bound_specabs)

    # build state matrix (remains unchanged upon resets)
    A = build_matrix(F1, F2, N)
    
    # time intervals to compute
    time_intervals = mince(0 .. T, resets+1)
    
    # compute until first chunk
    T1 = sup(first(time_intervals))
    sol_1, sol_1_err = _solve_CARLIN(X0, F1, F2; alg=alg, N=N, T=T1, Δt0=interval(0), A=A, error_bound_func=error_bound_func)

    fp_1 = flowpipe(sol_1)
    fp_err_1 = flowpipe(sol_1_err)

    out = Vector{typeof(fp_1)}()
    out_err = Vector{typeof(fp_err_1)}()
    
    push!(out, fp_1)
    push!(out_err, fp_err_1)

    Rlast = sol_1_err[end]
    X0 = box_approximation(set(Rlast))

    # compute remaining chunks
    for i in 2:length(time_intervals)
        T0 = T1
        Ti = sup(time_intervals[i])
        sol_i, sol_i_err = _solve_CARLIN(X0, F1, F2; alg=alg, N=N, T=Ti-T0, Δt0=interval(T0), A=A, error_bound_func=error_bound_func)
        push!(out, flowpipe(sol_i))
        push!(out_err, flowpipe(sol_i_err))
        X0 = box_approximation(set(sol_i_err[end]))
        T1 = Ti
    end
    
    return ReachSolution(MixedFlowpipe(out), alg), ReachSolution(MixedFlowpipe(out_err), alg)
end
