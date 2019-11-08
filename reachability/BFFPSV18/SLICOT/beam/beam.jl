#=
Model: Beam (348 variables, 1 input)
=#
using Reachability, MAT, SparseArrays

beam(o::Pair{Symbol, <:Any}...) = beam(Options(Dict{Symbol, Any}(o)))

function beam(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    file = matopen(@relpath "beam.mat")
    A = read(file, "A")

    # initial set
    # - x1-x300 are 0,
    # - the rest is in [0.002, 0.0015]
    X0 = Hyperrectangle([zeros(300); fill(0.00175, 48)],
                        [zeros(300); fill(0.00025, 48)])

    # input set
    B = read(file, "B")
    U = BallInf([0.5], 0.3)

    # instantiate continuous LTI system
    S = InitialValueProblem(
        ConstrainedLinearControlContinuousSystem(A, B, nothing, U), X0)

    # safety property: x89 < 2100
    property = SafeStatesProperty(HalfSpace(sparsevec([89], [1.0], 348), 2100.))

    # =======================
    # Problem default options
    # =======================
    partition = [(2*i-1:2*i) for i in 1:174] # 2D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [89],
                                  :partition => partition,
                                  :plot_vars => [0, 89])

    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => [89],
                                  :partition => partition,
                                  :property => property)
    end

    return (S, merge(problem_options, input_options))
end
