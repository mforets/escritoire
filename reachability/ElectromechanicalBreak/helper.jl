# ------------------------------------
# For Reachability.jl version 0.6.x
# ------------------------------------
function LazySets.project(F::Reachability.Flowpipe{ST, <:ReachSet}, vars) where {ST}
    return [project(F.reachsets[i].X, vars, LazySets.LinearMap) for i in eachindex(F.reachsets)]
end

function LazySets.project(F::Reachability.Flowpipe{ST, <:SparseReachSet}, vars) where {ST}
    return [project(F.reachsets[i].rs.X, vars, LazySets.LinearMap) for i in eachindex(F.reachsets)]
end

function times(F::Reachability.Flowpipe{ST, <:ReachSet}) where {ST}
    return [LazySets.Interval(F.reachsets[i].t_start, F.reachsets[i].t_end) for i in eachindex(F.reachsets)]
end

function times(F::Reachability.Flowpipe{ST, <:SparseReachSet}) where {ST}
    return [LazySets.Interval(F.reachsets[i].rs.t_start, F.reachsets[i].rs.t_end) for i in eachindex(F.reachsets)] 
end

#=
# ------------------------------------
# For Reachability.jl version 0.5.x
# ------------------------------------

function LazySets.project(F::Vector{<:SparseReachSet}, vars)
    return [project(F[i].rs.X, vars, LazySets.LinearMap) for i in eachindex(F)]
end

function LazySets.project(F::Vector{<:SparseReachSet}, vars)
    return [project(F[i].rs.X, vars, LazySets.LinearMap) for i in eachindex(F)]
end

times(F::Vector{<:ReachSet}) = [LazySets.Interval(F[i].t_start, F[i].t_end) for i in eachindex(F)]

times(F::Vector{<:SparseReachSet}) = [LazySets.Interval(F[i].rs.t_start, F[i].rs.t_end) for i in eachindex(F)] 
=#