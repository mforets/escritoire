#=
Model: MNA_1 (578 variables, 9 inputs)
=#
using Reachability, MAT, SparseArrays

mna1(o::Pair{Symbol, <:Any}...) = mna1(Options(Dict{Symbol, Any}(o)))

function mna1(input_options::Options)
    # =====================
    # Problem specification
    # =====================
    # dynamics
    file = matopen(@relpath "mna1.mat")
    A = sparse(read(file, "A"))
    n = size(A, 1)
    b = sparsevec(570:578, [fill(-0.1, 5); fill(-0.2, 4)], n)

    # initial set
    X0 = Hyperrectangle([fill(0.00125, 2); zeros(576)],
                        [fill(0.00025, 2); zeros(576)])

    # instantiate continuous LTI system
    S = IVP(CACS(A, b, nothing), X0)

    # property: x1 < 0.5
    property = SafeStatesProperty(HalfSpace(sparsevec([1], [1.0], n), 0.5))

    # =======================
    # Problem default options
    # =======================
    partition = [(2*i-1:2*i) for i in 1:289] # 2D blocks

    if input_options[:mode] == "reach"
        problem_options = Options(:vars => [1],
                                  :partition => partition,
                                  :plot_vars => [0, 1])
    elseif input_options[:mode] == "check"
        problem_options = Options(:vars => [1],
                                  :partition => partition,
                                  :property => property)
    end

    return (S, merge(problem_options, input_options))
end
