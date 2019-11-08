#=
Model: PDE (84 variables, 1 input)
=#
using Reachability, MAT

pde(o::Pair{Symbol, <:Any}...) = pde(Options(Dict{Symbol, Any}(o)))

function pde(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    file = matopen(@relpath "pde.mat")
    A = float(read(file, "A")) # this matrix has Int entries

    # initial set
    n = size(A, 1)
    center0 = zeros(n)
    radius0 = zeros(n)
    center0[65:80] .= 0.00125
    center0[81:84] .= -0.00175
    radius0[65:84] .= 0.00025
    X0 = Hyperrectangle(center0, radius0)

    # input set
    B = read(file, "B")
    U = BallInf([0.75], .25)

    # instantiate continuous LTI system
    S = InitialValueProblem(
        ConstrainedLinearControlContinuousSystem(A, B, nothing, U), X0)

    # property: y < 12 for linear combination y
    property = SafeStatesProperty(HalfSpace(
        read(matopen(@relpath "out.mat"), "M")[1, :], 12.))

    # =======================
    # Problem default options
    # =======================
    partition = [(2*i-1:2*i) for i in 1:42] # 2D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [1],
                                  :partition => partition,
                                  :plot_vars => [0, 1])
        # :projection_matrix => sparse(read(matopen(@relpath "out.mat"), "M"))
    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => 1:84,
                                  :partition => partition,
                                  :property => property)
    end

    return (S, merge(problem_options, input_options))
end
