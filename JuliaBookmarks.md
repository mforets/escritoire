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
- [LazyArrays.jl](https://github.com/JuliaArrays/LazyArrays.jl)

### Tensors

- https://ericforgy.github.io/TensorAlgebra.jl/dev/#TensorKit.jl
- https://github.com/thisrod/Tensars.jl
- SymbolicTensors, see JuliaCon 2020 talk
- https://github.com/lanaperisa/TensorToolbox.jl
- https://github.com/adtzlr/ttb

## Calculus

- https://github.com/JuliaDiff/ForwardDiff.jl
- https://github.com/JuliaDiff/FiniteDiff.jl
- https://github.com/JuliaMath/Calculus.jl

## Geometry

- https://github.com/JuliaGeometry/CoordinateTransformations.jl


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
- https://github.com/antoine-levitt/Exfiltrator.jl
- https://github.com/c42f/TerminalLoggers.jl
- https://github.com/oxinabox/LoggingExtras.jl

## Differential equations & numerical simulations

- DynamicalSystems.jl
- [DifferentialEquations.jl webpage](https://juliadiffeq.org/)
- [DifferentialEquations.jl documentation](https://docs.juliadiffeq.org/dev/index.html)
   - https://github.com/SciML/OrdinaryDiffEq.jl
- [Mera.jl](https://github.com/ManuelBehrendt/Mera.jl)
- [Causal.jl](https://github.com/zekeriyasari/Causal.jl/issues)
- ModiaSim
- [SimJulia](https://benlauwens.github.io/SimJulia.jl/)
- [NetworkDynamics.jl](https://github.com/FHell/NetworkDynamics.jl)
- https://github.com/PSORLab/DynamicBoundspODEsIneq.jl
- https://github.com/SciML/DiffEqUncertainty.jl

## More on dynamical systems

- [TrajectoryOptimization.jl](https://github.com/RoboticExplorationLab/TrajectoryOptimization.jl)


### Model formats

- https://github.com/SciML/CellMLToolkit.jl

### Circuits

- https://discourse.julialang.org/t/tann-view-post-process-analog-circuit-simulations/44658

## Documentation

- [Hosting documentation. Documenter help](https://juliadocs.github.io/Documenter.jl/v0.24/man/hosting/#Hosting-Documentation-1).
- [Documenter showcase](https://juliadocs.github.io/Documenter.jl/v0.24/showcase/#Doctest-showcase-1).
- [SafeTestsets](https://github.com/YingboMa/SafeTestsets.jl)
- [latex_symbols.jl](https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/src/latex_symbols.jl)
- [Unicode input](https://docs.julialang.org/en/v1/manual/unicode-input/)
- [Literate.jl](https://github.com/fredrikekre/Literate.jl)
- https://github.com/JunoLab/Weave.jl
- https://juliadocs.github.io/DocStringExtensions.jl/latest/index.html
- [Publish.jl](https://github.com/MichaelHatherly/Publish.jl)
- [Latexify.jl](https://github.com/korsbo/Latexify.jl)
- [Citations.jl](https://github.com/adamslc/Citations.jl)
- [DocumenterBibliographyTest.jl](https://github.com/ali-ramadhan/DocumenterBibliographyTest.jl)
- [BibTeXFormat.jl](https://lucianolorenti.github.io/BibTeXFormat.jl/latest/)
- [BibTex.jl](https://github.com/JuliaTeX/BibTeX.jl)


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

### Memoisation

- https://github.com/BenLauwens/ResumableFunctions.jl
- https://discourse.julialang.org/t/memoization-performance/26361
- https://gist.github.com/tk3369/877c2c60f41f6b0941e76e977e916192
- https://github.com/dalum/Purses.jl

### Other tools

- https://github.com/oxinabox/AutoPreallocation.jl
- https://github.com/pengwyn/AutoParameters.jl

## API

- https://github.com/jw3126/ArgCheck.jl
- https://simeonschaub.github.io/OptionalArgChecks.jl/dev/
- Unpack
- Parameters
- https://juliahub.com/ui/Packages/ArgTools/aGHFV/1.1.1

## Other

- https://github.com/JuliaReinforcementLearning/ReinforcementLearning.jl
- https://github.com/eschnett/SIMD.jl
- https://etymoio.github.io/EvolvingGraphs.jl/latest/
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
- https://psorlab.github.io/EAGO.jl/dev/

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


## Blogs, discussions, ...

- [High order functions](https://discourse.julialang.org/t/to-factor-or-not-to-factor-functions-with-small-differences-within-loops/39532/4)
- [Dynamical systems modeling in Julia]()
- https://github.com/johnmyleswhite/julia_tutorials

## Neural networks

- https://github.com/vtjeng/MIPVerify.jl


## Web 

- Presentations from markdown https://github.com/oxinabox/Remark.jl

## Generators

- https://discourse.julialang.org/t/creating-generators/3962/28
- https://medium.com/@Jernfrost/generators-and-iterators-in-julia-and-python-6c9ace18fa93


----

## Tutorials

- https://github.com/DataWookie/MonthOfJulia
- https://github.com/mitmath/18330/tree/spring20/lectures
- Fundamentales of Numerical Computation. By Tobin A. Driscoll and Richard J. Braun
 https://fncbook.github.io/fnc/intro/overview.html
 
 ---
 
 ## JSoc / GSOC 2020
 
 - https://nextjournal.com/sguadalupe
