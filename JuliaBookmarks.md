## Algebra

- [Intel MKL linear algebra library](https://github.com/JuliaComputing/MKL.jl)
- [Padded matrices](https://github.com/chriselrod/PaddedMatrices.jl)
- [Gaius](https://github.com/MasonProtter/Gaius.jl)
- [Tullio.jl](https://github.com/mcabbott/Tullio.jl). Example [here](https://discourse.julialang.org/t/accelerate-non-linear-function-evaluation/42105/16).

### Arrays

- [ElasticArrays](https://github.com/JuliaArrays/ElasticArrays.jl)
- [IdentityMatrix.jl](https://github.com/jlapeyre/IdentityMatrix.jl)
- https://github.com/mateuszbaran/HybridArrays.jl
- [Block arrays](https://github.com/JuliaArrays/BlockArrays.jl)
- [RecursiveArrayTools](https://github.com/JuliaDiffEq/RecursiveArrayTools.jl)

### Tensors




## Calculus

- https://github.com/JuliaDiff/ForwardDiff.jl
- https://github.com/JuliaDiff/FiniteDiff.jl
- https://github.com/JuliaMath/Calculus.jl

### Integration

- https://github.com/SciML/Quadrature.jl

#### More on differentiation

- https://discourse.julialang.org/t/am-i-using-diffresults-jl-correctly/35894
- https://discourse.julialang.org/t/a-way-to-obtain-the-value-and-derivatives-with-forwarddiff/22862
- http://www.juliadiff.org/DiffResults.jl/latest/

## Code introspection & Profiling

- [Treeview.jl](https://github.com/JuliaTeX/TreeView.jl) (view Julia syntax trees as a graph)
- [Flatten.jl](https://github.com/rafaqz/Flatten.jl) (type queries)
- [ProfileVega.jl](https://github.com/davidanthoff/ProfileVega.jl)
- [TimerOutputs.jl](https://github.com/KristofferC/TimerOutputs.jl)
- [Traceur.jl](https://github.com/JunoLab/Traceur.jl)
- [OwnTime.jl](https://github.com/DevJac/OwnTime.jl)
- [Timeout.jl](https://github.com/ararslan/Timeout.jl)
- https://github.com/FluxML/IRTools.jl

## Differential equations & numerical simulations

- DynamicalSystems.jl
- [DifferentialEquations.jl webpage](https://juliadiffeq.org/)
- [DifferentialEquations.jl documentation](https://docs.juliadiffeq.org/dev/index.html)
   - https://github.com/SciML/OrdinaryDiffEq.jl
- [Mera.jl](https://github.com/ManuelBehrendt/Mera.jl)
- [Jusdl.jl](https://github.com/zekeriyasari/Jusdl.jl)
- ModiaSim
- [SimJulia](https://benlauwens.github.io/SimJulia.jl/)
- [NetworkDynamics.jl](https://github.com/FHell/NetworkDynamics.jl)
- https://github.com/PSORLab/DynamicBoundspODEsIneq.jl

## More on dynamical systems

- [TrajectoryOptimization.jl](https://github.com/RoboticExplorationLab/TrajectoryOptimization.jl)

## Documentation

- [Hosting documentation. Documenter help](https://juliadocs.github.io/Documenter.jl/v0.24/man/hosting/#Hosting-Documentation-1).
- [Documenter showcase](https://juliadocs.github.io/Documenter.jl/v0.24/showcase/#Doctest-showcase-1).
- [SafeTestsets](https://github.com/YingboMa/SafeTestsets.jl)
- [latex_symbols.jl](https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/src/latex_symbols.jl)
- [Unicode input](https://docs.julialang.org/en/v1/manual/unicode-input/)
- [Literate.jl](https://github.com/fredrikekre/Literate.jl)
- https://github.com/JunoLab/Weave.jl

## Domain-specific language tools (DSL)

- [ModelingToolkit](https://github.com/JuliaDiffEq/ModelingToolkit.jl)
- [Sims.jl](https://github.com/tshort/Sims.jl)
- [Modia.jl](https://github.com/ModiaSim/Modia.jl)
- [Symbolics.jl](https://github.com/MasonProtter/Symbolics.jl)
- [ModelKit.jl](https://github.com/saschatimme/ModelKit.jl/)

## Macros

- [ExprTools](https://github.com/invenia/ExprTools.jl)
- [MacroTools](https://github.com/FluxML/MacroTools.jl)
- [Espresso](https://github.com/dfdx/Espresso.jl)
- [Keyword dispatch](https://github.com/simonbyrne/KeywordDispatch.jl)
- [ExtractMacro](https://github.com/carlobaldassi/ExtractMacro.jl)

Other useful references:

- [Some useful macros for Julia (MikeInnes)](https://gist.github.com/MikeInnes/8299575)

## API

- https://github.com/jw3126/ArgCheck.jl
- https://simeonschaub.github.io/OptionalArgChecks.jl/dev/
- Unpack
- Parameters

## Other

- https://github.com/JuliaReinforcementLearning/ReinforcementLearning.jl
- https://github.com/eschnett/SIMD.jl
- https://etymoio.github.io/EvolvingGraphs.jl/latest/
- Memoization
    - https://discourse.julialang.org/t/memoization-performance/26361
    - https://gist.github.com/tk3369/877c2c60f41f6b0941e76e977e916192
- Interactive plotting
    - https://angusmoore.github.io/Matte.jl/stable/index.html#Examples-1
- https://github.com/bcbi/ExtensibleUnions.jl
- https://github.com/bcbi/GitCommand.jl

## Traits

- [Traits.jl](https://github.com/schlichtanders/Traits.jl)
- [SimpleTraits.jl](https://github.com/mauro3/SimpleTraits.jl)
- [BinaryTraits.jl](https://github.com/tk3369/BinaryTraits.jl), [on discourse](https://discourse.julialang.org/t/ann-binarytraits-jl-a-new-traits-package/37475)

## Optimization

- https://github.com/ds4dm/Tulip.jl
- http://www.juliaopt.org/MathOptInterface.jl/dev/apimanual/#Standard-form-problem-1
- https://github.com/jump-dev/MatrixOptInterface.jl
- https://github.com/oxfordcontrol/COSMO.jl
- https://github.com/JuliaLinearOptimizers/Simplex.jl
- https://github.com/SCIP-Interfaces/SCIP.jl
- https://github.com/IainNZ/RationalSimplex.jl
- https://github.com/jw3126/Convex1D.jl
- https://github.com/SciML/GalacticOptim.jl
- [CMAEvolutionStrategy](https://github.com/jbrea/CMAEvolutionStrategy.jl/tree/f421335dad3c9133b4e0c1796d33508cef08834e), [discourse announcement](https://discourse.julialang.org/t/ann-cmaevolutionstrategy-jl/39411/5).

### PDEs

- ....
- https://github.com/PetrKryslUCSD/Elfel.jl

---

- https://shields.io/
- https://github.com/danielfrg/pelican-ipynb
- http://www.pelicanthemes.com/

---

## Parallelism

- https://github.com/jishnub/ParallelUtilities.jl
- https://stackoverflow.com/questions/50802184/julia-macro-threads-and-parallel
- https://julialang.org/blog/2019/07/multithreading/

---

## SAT solvers

- https://github.com/newptcai/BEE.jl

## Repeatability

- https://github.com/bcbi/SimpleContainerGenerator.jl


### Blogs, discussions, ...

- [High order functions](https://discourse.julialang.org/t/to-factor-or-not-to-factor-functions-with-small-differences-within-loops/39532/4)
- [Dynamical systems modeling in Julia]()
