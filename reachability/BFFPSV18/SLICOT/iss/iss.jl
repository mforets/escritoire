#=
Model: ISS (270 variables, 3 inputs)
=#
using Reachability, MAT, SparseArrays

iss(o::Pair{Symbol, <:Any}...) = iss(Options(Dict{Symbol, Any}(o)))

function iss(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    file = matopen(@relpath "iss.mat")
    A = sparse(read(file, "A"))

    # initial set
    # -0.0001 <= xi <= 0.0001 for all i
    X0 = BallInf(zeros(size(A, 1)), .0001)

    # input set
    B = read(file, "B")
    U = Hyperrectangle([0.05, 0.9, 0.95], [0.05, 0.1, 0.05])

    # instantiate continuous LTI system
    S = InitialValueProblem(
        ConstrainedLinearControlContinuousSystem(A, B, nothing, U), X0)

    # property: y < 7e-4 for linear combination y
    property = SafeStatesProperty(HalfSpace(
        read(matopen(@relpath "out.mat"), "M")[1, :], 7e-4))

    # =======================
    # Problem default options
    # =======================
    partition_2D = [(2*i-1:2*i) for i in 1:135] # 2D blocks
    partition_135D = [1:135, 136:270] # 135D blocks
    partition_1D_135D = vcat([[i] for i in 1:135], [136:270]) # mixed 1D and 135D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [182],
                                  :partition => partition_2D,
                                  :plot_vars => [0, 182],
                                  :assume_sparse => true)
    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => 136:270,
                                  :partition => partition_1D_135D,
                                  :property => property,
                                  :lazy_inputs_interval => -1,
                                  :assume_sparse => true)
    end

    return (S, merge(problem_options, input_options))
end
