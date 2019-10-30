# transform a flowpipe by adding the time interval
# this implementation is algorithm-specific to BFFPSV18, as it assumes that the 
# input flowpipe is a vector of sparse reach sets
function add_time!(X::Vector{SparseReachSet{CPA{NUM, ST}}}) where {NUM, ST}
    for Xk in X
        Tk = Interval(time_start(Xk), time_end(Xk))
        # we push onto the array of the CPA, with time on the left (beginning) of the array 
        pushfirst!(set(Xk).array, Tk)
    end
end
