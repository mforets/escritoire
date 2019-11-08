#=
Model: FOM (1006 variables, 1 input)
=#
using Reachability, MAT

fom(o::Pair{Symbol, <:Any}...) = fom(Options(Dict{Symbol, Any}(o)))

function fom(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    file = matopen(@relpath "fom.mat")
    A = float(read(file, "A")) # this matrix has Int entries

    # initial set
    X0 = Hyperrectangle(zeros(1006), [fill(0.0001, 400); zeros(606)])

    # input set
    B = read(file, "B")
    U = BallInf([0.0], 1.0)

    # instantiate continuous LTI system
    S = InitialValueProblem(
        ConstrainedLinearControlContinuousSystem(A, B, nothing, U), X0)

    # property: y < 185
    property = SafeStatesProperty(HalfSpace(
        read(matopen(@relpath "out.mat"), "M")[1, :], 185.))

    # =======================
    # Problem default options
    # =======================
    partition_2D = [(2*i-1:2*i) for i in 1:503] # 2D blocks
    partition_6D = vcat([(6*i-5:6*i) for i in 1:167], [1003:1006]) # 6D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [1],
                                  :partition => partition_2D,
                                  :plot_vars => [0, 1],
                                  :lazy_expm_discretize => true,
                                  :assume_sparse => true)
        # :projection_matrix => sparse(read(matopen(@relpath "out.mat"), "M")),
    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => 1:1006,
                                  :partition => partition_6D,
                                  :property => property,
                                  :lazy_inputs_interval => -1,
                                  :lazy_expm_discretize => true,
                                  :assume_sparse => true)
    end

    return (S, merge(problem_options, input_options))
end
