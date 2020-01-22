function LazySets.project(F::Vector{<:ReachSet}, vars)
    return [project(F[i].X, vars, LazySets.LinearMap) for i in eachindex(F)]
end

function LazySets.project(F::Vector{<:SparseReachSet}, vars)
    return [project(F[i].rs.X, vars, LazySets.LinearMap) for i in eachindex(F)]
end

times(F::Vector{<:ReachSet}) = [LazySets.Interval(F[i].t_start, F[i].t_end) for i in eachindex(F)]

times(F::Vector{<:SparseReachSet}) = [LazySets.Interval(F[i].rs.t_start, F[i].rs.t_end) for i in eachindex(F)] 
