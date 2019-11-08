#=
Model: Building (48 variables, 1 input)
=#
using Reachability, MAT, SparseArrays

building(o::Pair{Symbol, <:Any}...) = building(Options(Dict{Symbol, Any}(o)))

function building(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    file = matopen(@relpath "building.mat")
    A = read(file, "A")

    # initial set
    # - x1-x10 are in [0.0002, 0.00025],
    # - x25 is in [-0.0001, 0.0001],
    # - the rest is 0
    X0 = Hyperrectangle([fill(0.000225, 10); zeros(38)],
                        [fill(0.000025, 10); zeros(14); 0.0001; zeros(23)])

    # input set
    B = read(file, "B")
    U = BallInf([0.9], .1)

    # instantiate continuous LTI system
    S = InitialValueProblem(
        ConstrainedLinearControlContinuousSystem(A, B, nothing, U), X0)

    # property: x25 < 6e-3
    property = SafeStatesProperty(HalfSpace(sparsevec([25], [1.0], 48), 6e-3))

    # =======================
    # Problem default options
    # =======================
    partition = [(2*i-1:2*i) for i in 1:24] # 2D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [25],
                                  :partition => partition,
                                  :plot_vars => [0, 25])
    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => [25],
                                  :partition => partition,
                                  :property => property)
    end

    return (S, merge(problem_options, input_options))
end
