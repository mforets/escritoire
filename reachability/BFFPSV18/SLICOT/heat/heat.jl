#=
Model: Heat (200 variables, 1 input)
=#
using Reachability, MAT, SparseArrays

heat(o::Pair{Symbol, <:Any}...) = heat(Options(Dict{Symbol, Any}(o)))

function heat(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    file = matopen(@relpath "heat.mat")
    A = read(file, "A")

    # initial set
    # - x1-x300 are 0.0,
    # - the rest is in [0.002, 0.0015]
    X0 = Hyperrectangle([fill(0.6125, 2); zeros(198)],
                        [fill(0.0125, 2); zeros(198)])

    # input set
    B = sparse([67], [1], [1.0], size(A, 1), 1)
    U = BallInf([0.0], 0.5)

    # instantiate continuous LTI system
    S = InitialValueProblem(
        ConstrainedLinearControlContinuousSystem(A, B, nothing, U), X0)

    # property: x133 < 0.1
    property = SafeStatesProperty(HalfSpace(sparsevec([133], [1.0], 200), 0.1))

    # =======================
    # Problem default options
    # =======================
    partition = [(2*i-1:2*i) for i in 1:100] # 2D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [133],
                                  :partition => partition,
                                  :plot_vars => [0, 133])
    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => [133],
                                  :partition => partition,
                                  :property => property)
    end

    return (S, merge(problem_options, input_options))
end
