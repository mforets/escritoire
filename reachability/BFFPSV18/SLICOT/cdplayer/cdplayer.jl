#=
Model: CD-Player (120 variables, 2 inputs)
=#
using Reachability, MAT, SparseArrays

cdplayer(o::Pair{Symbol, <:Any}...) = cdplayer(Options(Dict{Symbol, Any}(o)))

function cdplayer(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    file = matopen(@relpath "cdplayer.mat")
    A = read(file, "A")

    # initial set
    X0 = BallInf(zeros(120), 1.0)

    # input set
    B = read(file, "B")
    U = BallInf([0.0, 0.0], 1.0)

    # instantiate continuous LTI system
    S = InitialValueProblem(
        ConstrainedLinearControlContinuousSystem(A, B, nothing, U), X0)

    # prpoperty: 2*x1 -3*x2 < 450.8
    property =
        SafeStatesProperty(HalfSpace(sparsevec([1, 2], [2., -3.], 120), 450.8))

    # =======================
    # Problem default options
    # =======================
    partition = [(2*i-1:2*i) for i in 1:60] # 2D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [1],
                                  :partition => partition,
                                  :plot_vars => [0, 1],
                                  :assume_sparse => true)
    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => [1, 2],
                                  :partition => partition,
                                  :property => property,
                                  :assume_sparse => true)
    end

    return (S, merge(problem_options, input_options))
end
