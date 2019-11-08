================================================================
no_wrapping_effect_homogeneous

iss_r1.png

julia> run()
System Construction...
elapsed time: 0.982133765 seconds
Time Discretization...
αδ = 0
βδ = 0
elapsed time: 0.157948856 seconds
Reachable LazySets Computation...
no_wrapping_effect_homogeneous
elapsed time: 3.093506568 seconds
Adding time dimension
elapsed time: 4.5892e-5 seconds
Projections...
elapsed time: 2.62667261 seconds

................................................

U = BallInf(zeros(n), 0.0)
X0 = BallInf(ones(n), .1)
δ = 0.1
ɛ = 1.
N = 250
x1 = n+1  # variable to plot in the x-axis. for time choose n+1
x2 = 8  # variable to plot in the y-axis
M = zeros(2, n+1)
M[1, x1] = 1.
M[2, x2] = 1.
RsetsProj = HPolygonOpt[]
for s in Rsets.a
    push!(RsetsProj, overapproximate(M*s, ɛ * 0.001)) # we can be a little bit more precise at the output
end

================================================================